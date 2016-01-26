# FastEasyMapping

[![Build Status](https://travis-ci.org/Yalantis/FastEasyMapping.png)](https://travis-ci.org/Yalantis/FastEasyMapping)

### Note
This is a fork of [EasyMapping](https://github.com/EasyMapping/EasyMapping), a flexible and easy framework for JSON mapping.

## Reason
It turns out, that almost all popular libraries for JSON mapping are SLOW. The main reason for that is multiple trips to database during the lookup of existing objects. We [decided](https://yalantis.com/blog/from-json-to-core-data-fast-and-effectively/) to take an already existing [flexible solution](https://github.com/EasyMapping/EasyMapping) (i.e. EasyMapping) and improve its overall performance.

<p align="center" >
  <img src="https://raw.githubusercontent.com/Yalantis/FastEasyMapping/efabb88b0831c7ece88e728b9665edc4d3af5b1f/Assets/performance.png" alt="FastEasyMapping" title="FastEasyMapping">
</p>

# Installation

#### Cocoapods:
```ruby
#Podfile
platform :ios, '7.0'
pod 'FastEasyMapping', '~> 1.0'
```
or add as a static library.

## Architecture

### Mapping

* `FEMMapping`
* `<FEMProperty>`
	- `FEMAttribute`
	- `FEMRelationship`

### Deserialization _(JSON to Object)_
- `FEMDeserializer`

### Serialization _(Object to JSON)_
- `FEMSerializer`

### Advanced Deserialization
- `FEMObjectStore`
- `FEMManagedObjectStore`
- `FEMManagedObjectCache`

## Usage
### Deserialization

Today NSObject and NSManagedObject mapping are supported out of the box. Lets take a look at how a basic mapping looks like: For example, we have JSON:

```json
{
    "name": "Lucas",
    "user_email": "lucastoc@gmail.com",
    "car": {
        "model": "i30",
        "year": "2013"
    },
    "phones": [
        {
            "ddi": "55",
            "ddd": "85",
            "number": "1111-1111"
        },
        {
            "ddi": "55",
            "ddd": "11",
            "number": "2222-222"
        }
    ]
}
```

and corresponding [CoreData](https://www.objc.io/issues/4-core-data/core-data-overview/)-generated classes: 

```objective-c
@interface Person : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) Car *car;
@property (nonatomic, retain) NSSet *phones;

@end

@interface Car : NSManagedObject

@property (nonatomic, retain) NSString *model;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) Person *person;

@end

@interface Phone : NSManagedObject

@property (nonatomic, retain) NSString *ddi;
@property (nonatomic, retain) NSString *ddd;
@property (nonatomic, retain) NSString *number;
@property (nonatomic, retain) Person *person;

@end
```

In order to map _JSON to Object_ and vice versa we have to describe the mapping rules:

```objective-c
@implementation Person (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Person"];
    [mapping addAttributesFromArray:@[@"name"]];
    [mapping addAttributesFromDictionary:@{@"email": @"user_email"}];

    [mapping addRelationshipMapping:[Car defaultMapping] forProperty:@"car" keyPath:@"car"];
    [mapping addToManyRelationshipMapping:[Phone defaultMapping] forProperty:@"phones" keyPath:@"phones"];

    return mapping;
}

@end

@implementation Car (Mapping)

+ (FEMMapping *)defaultMapping {
	FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Car"];
    [mapping addAttributesFromArray:@[@"model", @"year"]];

  	return mapping;
}

@end


@implementation Phone (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Phone"];
    [mapping addAttributesFromArray:@[@"number", @"ddd", @"ddi"]];

    return mapping;
}

@end
```

Now we can deserialize _JSON to Object_ easily:

```objective-c
FEMMapping *mapping = [Person defaultMapping];
Person *person = [FEMDeserializer objectFromRepresentation:json mapping:mapping context:managedObjectContext];
```

Or collection of Objects:

```objective-c
NSArray *persons = [FEMDeserializer collectionFromRepresentation:json mapping:mapping context:managedObjectContext];
```

Or even update an Object:
```objective-c
[FEMDeserializer fillObject:person fromRepresentation:json mapping:mapping];

```

### Serialization

Also we can serialize an _Object to JSON_ using the mapping defined above:
```objective-c
FEMMapping *mapping = [Person defaultMapping];
Person *person = ...;
NSDictionary *json = [FEMSerializer serializeObject:person usingMapping:mapping];
```

Or collection to JSON: 
```objective-c
FEMMapping *mapping = [Person defaultMapping];
NSArray *persons = ...;
NSArray *json = [FEMSerializer serializeCollection:persons usingMapping:mapping];
```

## Mapping
### FEMAttribute
`FEMAttribute` is a core class of FEM. Briefly it is a description of relationship between the Object's `property` and the JSON's `keyPath`. Also it encapsulates knowledge of how the value needs to be mapped from _Object to JSON_ and back via blocks. 

```objective-c
typedef __nullable id (^FEMMapBlock)(id value __nonnull);

@interface FEMAttribute : NSObject <FEMProperty>

@property (nonatomic, copy, nonnull) NSString *property;
@property (nonatomic, copy, nullable) NSString *keyPath;

- (nonnull instancetype)initWithProperty:(nonnull NSString *)property keyPath:(nullable NSString *)keyPath map:(nullable FEMMapBlock)map reverseMap:(nullable FEMMapBlock)reverseMap;

- (nullable id)mapValue:(nullable id)value;
- (nullable id)reverseMapValue:(nullable id)value;

@end
```

Alongside with `property` and `keyPath` value you can pass mapping blocks that allow to describe completely custom mappings.

Examples:

#### Mapping of value with the same keys and type:
```objective-c
FEMAttribute *attribute = [FEMAttribute mappingOfProperty:@"url"];
// or 
FEMAttribute *attribute = [[FEMAttribute alloc] initWithProperty:@"url" keyPath:@"url" map:NULL reverseMap:NULL];
``` 

#### Mapping of value with different keys and the same type:
```objective-c
FEMAttribute *attribute = [FEMAttribute mappingOfProperty:@"urlString" toKeyPath:@"URL"];
// or 
FEMAttribute *attribute = [[FEMAttribute alloc] initWithProperty:@"urlString" keyPath:@"URL" map:NULL reverseMap:NULL];
``` 

#### Mapping of different types:
Quite often value type in JSON needs to be converted to more useful internal representation. For example HEX to `UIColor`, `String` to `NSURL`, `Integer` to `enum` and so on. For this purpose you can use `map` and `reverseMap` properties. For example lets describe attribute that maps `String` to [NSDate](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSDate_Class/) using [NSDateFormatter](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSDateFormatter_Class/):
```objective-c
NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];

FEMAttribute *attribute = [[FEMAttribute alloc] initWithProperty:@"updateDate" keyPath:@"timestamp" map:^id(id value) {
	if ([value isKindOfClass:[NSString class]]) {
		return [formatter dateFromString:value];
	} 
	return nil;
} reverseMap:^id(id value) {
	return [formatter stringFromDate:value];
}];
```
First of all we've defined [NSDateFormatter](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSDateFormatter_Class/) that fits our requirements. Next step is to define Attribute instance with correct mapping. Briefly `map` block is invoked during deserialization (_JSON to Object_) while `reverseMap` is used for serialization process. Both are quite stratforward with but with few gotchas: 

- `map` can receive `NSNull` instance. This is a valid case for `null` value in JSON.
- map won't be invoked for missing keys. Therefore, if JSON doesn't contain keyPath specified by your attribute, reverse mapping not called.
- from map you can return either `nil` or `NSNull` for empty values
- `reverseMap` invoked only when `property` contains a non-nil value.	
- from `reverseMap` you can return either `nil` or `NSNull`. Both will produce `{"keyPath": null}`

#### Adding attribute to FEMMapping
There are several shortcuts that allow you to add attributes easier to the mapping itself:
##### Explicitly
```objective-c
FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[Person class]];
FEMAttribute *attribute = [FEMAttribute mappingOfProperty:@"url"];
[mapping addAttribute:attribute];
```

##### Implicitly
```objective-c
FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[Person class]];
[mapping addAttributeWithProperty:@"property" keyPath:@"keyPath"];
```

##### As a Dictionary
```objective-c
FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[Person class]];
[mapping addAttributesFromDictionary:@{@"property": @"keyPath"}];
```

##### As an Array
Useful when the `property` is equal to the `keyPath`:
```objective-c
FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[Person class]];
[mapping addAttributesFromArray:@[@"propertyAndKeyPathAreTheSame"]];
```

### FEMRelationship
`FEMRelationship` is a class that describes relationship between two `FEMMapping` instances. 
```objective-c
@interface FEMRelationship

@property (nonatomic, copy, nonnull) NSString *property;
@property (nonatomic, copy, nullable) NSString *keyPath;

@property (nonatomic, strong, nonnull) FEMMapping *mapping;
@property (nonatomic, getter=isToMany) BOOL toMany;

@property (nonatomic) BOOL weak;
@property (nonatomic, copy, nonnull) FEMAssignmentPolicy assignmentPolicy;

@end
```

Relationship is also bound to a `property` and `keyPath`. Obviously, it has a reference to Object's `FEMMapping` and a flag that indicates whether it’s a to-many relationship. Moreover, it allows you to specify assignment policy and "weakifying" behaviour of the relationship.

Example: 

```objective-c
FEMMapping *childMapping = ...;

FEMRelationship *childRelationship = [[FEMRelationship alloc] initWithProperty:@"parentProperty" keyPath:@"jsonKeyPath" mapping:childMapping];
childRelationship.toMany = YES;
```

#### Assignment policy
Assignment policy describes how deserialized relationship value should be assigned to a property. FEM supports 5 policies out of the box:

- `FEMAssignmentPolicyAssign` - replace Old property's value by New. Designed for to-one and to-many relationship. Default policy.
- `FEMAssignmentPolicyObjectMerge` - assigns New relationship value unless it is `nil`. Designed for to-one relationship.
- `FEMAssignmentPolicyCollectionMerge` - merges a New and Old values of relationship. Supported collections are: [NSSet](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSSet_Class/), [NSArray](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSArray_Class/), [NSOrderedSet](https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSOrderedSet_Class/) and their successors. Designed for to-many relationship.
- `FEMAssignmentPolicyObjectReplace` - replaces Old value with New by deleting Old. Designed for to-one relationship.
- `FEMAssignmentPolicyCollectionReplace` - deletes objects not presented in [union](https://en.wikipedia.org/wiki/Union_(set_theory)) of New and Old values sets. Union set is used as a New value. Supported collections are: [NSSet](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSSet_Class/), [NSArray](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSArray_Class/), [NSOrderedSet](https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSOrderedSet_Class/) and their successors. Designed for to-many relationship.

#### Adding relationship to FEMMapping

##### Explicitly
```objective-c
FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[Person class]];
FEMMapping *carMapping = [[FEMMapping alloc] initWithObjectClass:[Car class]];

FEMRelationship *carRelationship = [[FEMRelationship alloc] initWithProperty:@"car" keyPath:@"car" mapping:carMapping];
[mapping addRelationship:carRelationship];
```

##### Implicitly
```objective-c
FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[Person class]];
FEMMapping *phoneMapping = [[FEMMapping alloc] initWithObjectClass:[Phone class]];

[mapping addToManyRelationshipMapping:phoneMapping property:@"phones" keyPath:@"phones"];
```

### FEMMapping
Generally `FEMMapping` is a class that describes mapping for `NSObject` or `NSManagedObject` by encapsulating a set of attributes and relationships. In addition, it defines the possibilities for objects uniquing (supported by CoreData only).

The only difference between `NSObject` and `NSManagedObject` is in `init` methods:

##### NSObject
```objective-c
FEMMapping *objectMapping = [[FEMMapping alloc] initWithObjectClass:[CustomNSObjectSuccessor class]];
```

##### NSManagedObject
```objective-c
FEMMapping *managedObjectMapping = [[FEMMapping alloc] initWithEntityName:@"EntityName"];
```

#### Root Path
Sometimes a desired JSON is nested by a keyPath. In this case you can use `rootPath` property. Let’s modify Person JSON by nesting Person representation:
```
{
	result: {
		"name": "Lucas",
    	"user_email": "lucastoc@gmail.com",
    	"car": {
        	"model": "i30",
        	"year": "2013"
    	}
	}
}
```

Mapping will look like this:
```objective-c
@implementation Person (Mapping)

+ (FEMMapping *)defaultMapping {
	FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Person"];
	mapping.rootPath = @"result";

    [mapping addAttributesFromArray:@[@"name"]];
    [mapping addAttributesFromDictionary:@{@"email": @"user_email"}];
    [mapping addRelationshipMapping:[Car defaultMapping] forProperty:@"car" keyPath:@"car"];
  
  	return mapping;
}

@end
```

> IMPORTANT: `FEMMapping.rootPath` is ignore during relationship mapping. Use `FEMRelationship.keyPath` instead!

## Uniquing
It is a common case when you're deserializing JSON into CoreData and don't want to duplicate data in your database. This can be easily achieved by utilizing `FEMMapping.primaryKey`. It informs `FEMDeserializer` to track primary keys and avoid data copying. For example lets make Person's `email` a primary key attribute: 
```objective-c
@implementation Person (Mapping)

+ (FEMMapping *)defaultMapping {
	FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Person"];
    mapping.primaryKey = @"email";
    [mapping addAttributesFromArray:@[@"name"]];
    [mapping addAttributesFromDictionary:@{@"email": @"user_email"}];

    [mapping addRelationshipMapping:[Car defaultMapping] forProperty:@"car" keyPath:@"car"];
  
  	return mapping;
}

@end
```

> We recommend to index your primary key in datamodel to speedup keys lookup. Supported values for primary keys are Strings and Integers.

Starting from second import `FEMDeserializer` will update existing `Person`. 

### Relationship bindings by PK
Sometimes object representation contains a relationship described by a PK of the target entity:
```
{
	"result": {
		"id": 314
		"title": "https://github.com"
		"category": 4
	}
}
```
As you can see, from JSON we have two objects: `Website` and `Category`. If `Website` can be imported easily, there is an external reference to a `Category` represented by its primary key `id`. Can we bind the `Website` to the corresponding category? Yep! We just need to treat Website's representation as a Category:

First of all let’s declare our classes:
```objective-c
@interface Website: NSManagedObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) Category *category;

@end

@interface Category: NSManagedObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSSet *websites

@end
```

Now it is time to define mapping for `Website`:

```objective-c
@implementation Website (Mapping)

+ (FEMMapping *)defaultMapping {
	FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Website"];
	mapping.primaryKey = @"identifier";
	[mapping addAttributesFromDictionary:@{@"identifier": @"id", @"title": @"title"}];

	FEMMapping *categoryMapping = [[FEMMapping alloc] initWithEntityName:@"Category"];
	categoryMapping.primaryKey = @"identifier";
	[categoryMapping addAttributesFromDictionary:@{@"identifier": @"category"}];

	[mapping addRelationshipMapping:categoryMapping property:@"category" keyPath:nil];

	return mapping;
}

@end

```

By specifying `nil` as a `keyPath` for the category `Website`'s representation is treated as a `Category` at the same time. In this way it is easy to bind objects that are passed by PKs (which is quite common for network). 

### Weak relationship
In the example above there is an issue: what if our database doesn't contain `Category` with `PK = 4`? By default `FEMDeserializer` creates new objects during deserialization lazily. In our case this leads to insertion of `Category` instance without any data except `identifier`. In order to prevent such inconsistencies we can set `FEMRelationship.weak` to `YES`:

```objective-c
@implementation Website (Mapping)

+ (FEMMapping *)defaultMapping {
	FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Website"];
	mapping.primaryKey = @"identifier";
	[mapping addAttributesFromDictionary:@{@"identifier": @"id", @"title": @"title"}];

	FEMMapping *categoryMapping = [[FEMMapping alloc] initWithEntityName:@"Category"];
	categoryMapping.primaryKey = @"identifier";
	categoryMapping.weak = YES;
    [categoryMapping addAttributeWithProperty:@"identifier" keyPath:nil];

	[mapping addRelationshipMapping:categoryMapping property:@"category" keyPath:@"category"];

	return mapping;
}

@end

```
As a result it'll bind the `Website` with the corresponding `Category` only if the latter exists.

## Delegation
You can customize deserialization process by implementing `FEMDeserializerDelegate` protocol:
```objective-c
@protocol FEMDeserializerDelegate <NSObject>

@optional
- (void)deserializer:(nonnull FEMDeserializer *)deserializer willMapObjectFromRepresentation:(nonnull id)representation mapping:(nonnull FEMMapping *)mapping;
- (void)deserializer:(nonnull FEMDeserializer *)deserializer didMapObject:(nonnull id)object fromRepresentation:(nonnull id)representation mapping:(nonnull FEMMapping *)mapping;

- (void)deserializer:(nonnull FEMDeserializer *)deserializer willMapCollectionFromRepresentation:(nonnull NSArray *)representation mapping:(nonnull FEMMapping *)mapping;
- (void)deserializer:(nonnull FEMDeserializer *)deserializer didMapCollection:(nonnull NSArray *)collection fromRepresentation:(nonnull NSArray *)representation mapping:(nonnull FEMMapping *)mapping;

@end
```

However, if you're using Delegate you also have to instantiate `FEMDeserializer` manually:
##### NSObject 
```objective-c
FEMDeserializer *deserializer = [[FEMDeserializer alloc] init];
deserializer.delegate = self;
```

##### NSManagedObject
```objective-c
FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithContext:managedObjectContext];
deserializer.delegate = self;
```

Note, that delegate methods will be called on every object and collection during deserialization. Lets use `Person` example:
```
{
    "name": "Lucas",
    "user_email": "lucastoc@gmail.com",
    "phones": [
        {
            "ddi": "55",
            "ddd": "85",
            "number": "1111-1111"
        }
    ]
}
```

Mapping:
```objective-c
@implementation Person (Mapping)

+ (FEMMapping *)defaultMapping {
	FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Person"];
    [mapping addAttributesFromArray:@[@"name"]];
    [mapping addAttributesFromDictionary:@{@"email": @"user_email"}];
    [mapping addToManyRelationshipMapping:[Person defaultMapping] forProperty:@"phones" keyPath:@"phones"];

  	return mapping;
}

@end

@implementation Phone (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Phone"];
    [mapping addAttributesFromArray:@[@"number", @"ddd", @"ddi"]];

    return mapping;
}

@end
```
During deserialization of persons collection order will be the following:

1. willMapCollectionFromRepresentation:`Persons Array` mapping:`Person mapping`
2. willMapObjectFromRepresentation:`Person Dictionary` mapping:`Person mapping`
3. willMapCollectionFromRepresentation:`Phones Array` mapping:`Phone mapping`
4. willMapObjectFromRepresentation:`Phone Dictionary` mapping:`Phone mapping`
5. didMapObject:`Phone instance` fromRepresentation:`Phone Dictionary` mapping:`Phone mapping`
6. didMapObject:`Person instance` fromRepresentation:`Person Dictionary` mapping:`Person mapping`
7. didMapCollection:`Persons instances Array` fromRepresentation:`Persons Array` mapping:`Person mapping`

# Changelog
Moved to [releases](https://github.com/Yalantis/FastEasyMapping/releases)

# Thanks
* Special thanks to [lucasmedeirosleite](https://github.com/lucasmedeirosleite) for amazing framework.

# Extra
Read out [blogpost](https://yalantis.com/blog/from-json-to-core-data-fast-and-effectively/) about FastEasyMapping.
