# FastEasyMapping

[![Build Status](https://travis-ci.org/Yalantis/FastEasyMapping.png)](https://travis-ci.org/Yalantis/FastEasyMapping)

### Note
This is fork of [EasyMapping](https://github.com/lucasmedeirosleite/EasyMapping) - flexible and easy way of JSON mapping.

## Reason to be
It turns out, that almost all popular libraries for JSON mapping SLOW. The main reason is often trips to database during lookup of existing objects. So we [decided](http://yalantis.com/blog/2014/03/17/from-json-to-core-data-fast-and-effectively/) to take already existing [flexible solution](https://github.com/lucasmedeirosleite/EasyMapping) and improve overall performance.
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

Nowadays `NSObject` and `NSManagedObject` mapping supported out of the box. Lets take a look on how basic mapping looks like:. For example, we have JSON:

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

In order to map _JSON to Object_ and vice versa we have to describe mapping rules:

```objective-c
@implementation Person (Mapping)

+ (FEMMapping *)defaultMapping {
	FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Person"];
    [mapping addAttributesFromArray:@[@"name"]];
    [mapping addAttributesFromDictionary:@{@"email": @"user_email"}];

    [mapping addRelationshipMapping:[Car defaultMapping] forProperty:@"car" keyPath:@"car"];
    [mapping addToManyRelationshipMapping:[Person defaultMapping] forProperty:@"phones" keyPath:@"phones"];

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

Or collection of objects:

```objective-c
NSArray *persons = [FEMDeserializer collectionFromRepresentation:json mapping:mapping context:managedObjectContext];
```

Or even update object:
```objective-c
[FEMDeserializer fillObject:person fromRepresentation:json mapping:mapping];

```

### Serialization

Also we can serialize an _Object to JSON_ using mapping defined above:
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

#### Mapping of value with same keys and type:
```objective-c
FEMAttribute *attribute = [FEMAttribute mappingOfProperty:@"url"];
// or 
FEMAttribute *attribute = [[FEMAttribute alloc] initWithProperty:@"url" keyPath:@"url" map:NULL, reverseMap:NULL];
``` 

#### Mapping of value with different keys and same type:
```objective-c
FEMAttribute *attribute = [FEMAttribute mappingOfProperty:@"urlString" toKeyPath:@"URL"];
// or 
FEMAttribute *attribute = [[FEMAttribute alloc] initWithProperty:@"urlString" keyPath:@"URL" map:NULL, reverseMap:NULL];
``` 

#### Mapping of different types:
Quite often value type in JSON needs to be converted to more useful internal representation. For example HEX to `UIColor`, `String` to `NSURL`, `Integer` to `enum` and so on. For this purpose you can use `map` and `reverseMap` properties. For example lets describe attribute that maps String to `NSDate` using `NSDateFormatter`:
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
- `map` won't be invoked for missing keys. Therefore if JSON doesn't contain `keyPath` specified by your attribute, reverse mapping not called.
- you can return from `map` either `nil` or `NSNull` for empty values
- `reverseMap` invoked only when `property` contains non-nil value.
- you can return from `reverseMap` either `nil` or `NSNull`. Both will produce `{"keyPath": null}`


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

Relationship also bound to a `property` and `keyPath`. Obviously it has a reference to Object's `FEMMapping` and flag that indicates whethere it is a to-many relationship. Moreover it allows you to specify assignment policy and "weakifying" behaviour of the relationship.

Example: 

```objective-c
FEMMapping *childMapping = ...;

FEMRelationship *childRelationship = [[FEMRelationship alloc] initWithProperty:@"parentProperty" keyPath:@"jsonKeyPath" mapping:childMapping];
childRelationship.toMany = YES;
```

### FEMMapping


#### Nil Keypath


Mapping is a core of this project which consists of 3 classes:
- `FEMMapping` - class that describes an Object. It encapsulates all Object's attributes and relationships.
- `FEMAttribute` - description of relationship between an Object's `property` and a JSON's `keyPath`. Also it encapsulates rules of how the value needs to be mapped from _Object to JSON_ and back.
- `FEMRelationship` - 


Converting a NSDictionary or NSArray to a object class or collection now becomes easy:

```objective-c
Person *person = [FEMManagedObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
                                                                          usingMapping:[MappingProvider personMapping]
                                                                               context:context];

NSArray *cars = [FEMManagedObjectDeserializer deserializeCollectionExternalRepresentation:externalRepresentation
                                                                             usingMapping:[MappingProvider carMapping]
                                                                                  context:moc];
```


Filling an existent object:

```objective-c
Person *person = // fetch somehow;

FEMManagedObjectMapping *mapping = [MappingProvider personMapping];
[FEMManagedObjectDeserializer fillObject:person fromExternalRepresentation:externalRepresentation usingMapping:mapping];
```

### Assignment Policy

Now relationship can use one of three predefined assignment policies: `FEMAssignmentPolicyAssign`, `FEMAssignmentPolicyMerge` and `FEMAssignmentPolicyReplace`.

## Deserialization. NSObject

If you are using NSObject use `FEMObjectMapping` instead of `FEMManagedObjectMapping` and  `FEMObjectDeserializer` instead of `FEMManagedObjectDeserializer`.

## Serialization

For both NSManagedObject and NSObject serialization to JSON looks the same:

```objective-c
NSDictionary *representation = [FEMSerializer serializeObject:car usingMapping:[MappingProvider carMapping]];
NSArray *collectionRepresentation = [FEMSerializer serializeCollection:cars usingMapping:[MappingProvider carMapping]];
```

# Changelog

### 0.5.1
- Rename [FEMAttributeMapping](https://github.com/Yalantis/FastEasyMapping/blob/release/0.5.1/FastEasyMapping/Source/Core/Mapping/Attribute/FEMAttributeMapping.h) to [FEMAttribute](https://github.com/Yalantis/FastEasyMapping/blob/release/0.5.1/FastEasyMapping/Source/Core/Mapping/Attribute/FEMAttribute.h), [FEMRelationshipMapping](https://github.com/Yalantis/FastEasyMapping/blob/release/0.5.1/FastEasyMapping/Source/Core/Mapping/Relationship/FEMRelationshipMapping.h) to [FEMRelationship](https://github.com/Yalantis/FastEasyMapping/blob/release/0.5.1/FastEasyMapping/Source/Core/Mapping/Relationship/FEMRelationship.h)
- [Shorten FEMMapping mutation methods](https://github.com/Yalantis/FastEasyMapping/blob/release/0.5.1/FastEasyMapping/Source/Core/Mapping/FEMMapping.h#42)

### 0.4.1
- Resolves: [#19](https://github.com/Yalantis/FastEasyMapping/issues/19), [#18](https://github.com/Yalantis/FastEasyMapping/issues/18), [#16](https://github.com/Yalantis/FastEasyMapping/issues/16), [#12](https://github.com/Yalantis/FastEasyMapping/issues/12)
- Add Specs for AttributeMapping

### 0.3.7
- Added equality check before objects removal in FEMAssignmentPolicyObjectReplace
- Fixed minor issues


### 0.3.7
- Add synchronization to [FEMManagedObjectDeserializer](https://github.com/Yalantis/FastEasyMapping/blob/release/0.3.7/FastEasyMapping/Source/Core/Deserializer/FEMManagedObjectDeserializer.h#L43)
- Minor refactoring
- Fixed minor naming issues

### 0.3.3
- Update null-relationship handling in Managed Object Deserializer & Cache [handling of nil-relationship](https://github.com/Yalantis/FastEasyMapping/issues/7)

### 0.3.2
- Fix [handling of nil-relationship](https://github.com/Yalantis/FastEasyMapping/issues/7) data during deserialization
- Remove compiler warnings

### 0.3.1
- Set deployment target to 6.0
- Fix missing cache for + [FEMManagedObjectDeserializer fillObject:fromExternalRepresentation:usingMapping:]
- Update hanlding of nil relationships in assignment policies

### 0.3.0
- Add assignment policy support for FEMManagedObjectDeserializer: Assign, Merge, Replace
- Cover FEMCache by tests

### 0.2.1
- Improved types introspection by @advantis

### 0.2.0
- Renamed to FastEasyMapping

### 0.1.2
- Fixed serialization of BOOL properties on 64 bits

### 0.1.1
- Fixed caching behaviour for new objects

### 0.1
- Added managed objects cache for deserialization

# Thanks
* Special thanks to [lucasmedeirosleite](https://github.com/lucasmedeirosleite) for amazing framework.

# Extra
Read out [blogpost](http://yalantis.com/blog/from-json-to-core-data-fast-and-effectively/) about FastEasyMapping.
