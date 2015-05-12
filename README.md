# FastEasyMapping

[![Build Status](https://travis-ci.org/Yalantis/FastEasyMapping.png)](https://travis-ci.org/Yalantis/FastEasyMapping)

### Note
This is fork of [EasyMapping](https://github.com/lucasmedeirosleite/EasyMapping) - flexible and easy way of JSON mapping.

## Reason to be
It turns out, that almost all popular libraries for JSON mapping SLOW. The main reason is often trips to database during lookup of existing objects. So we [decided](http://yalantis.com/blog/2014/03/17/from-json-to-core-data-fast-and-effectively/) to take already existing [flexible solution](https://github.com/lucasmedeirosleite/EasyMapping) and improve overall performance.
<p align="center" >
  <img src="https://raw.githubusercontent.com/Yalantis/FastEasyMapping/efabb88b0831c7ece88e728b9665edc4d3af5b1f/Assets/performance.png" alt="FastEasyMapping" title="FastEasyMapping">
</p>

# Setup

#### Cocoapods:
```ruby
#Podfile

pod 'FastEasyMapping'
```
or add as a static library.

# Usage
## Deserialization. NSManagedObject

Supose you have these classes:

```objective-c
@interface Person : NSManagedObject

@property (nonatomic, retain) NSNumber *personID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) Car *car;
@property (nonatomic, retain) NSSet *phones;

@end

@interface Car : NSManagedObject

@property (nonatomic, retain) NSNumber *carID;
@property (nonatomic, retain) NSString *model;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) Person *person;

@end

@interface Phone : NSManagedObject

@property (nonatomic, retain) NSNumber *phoneID;
@property (nonatomic, retain) NSString *ddi;
@property (nonatomic, retain) NSString *ddd;
@property (nonatomic, retain) NSString *number;
@property (nonatomic, retain) Person *person;

@end
```

Mapping can be described in next way:

```objective-c
@implementation MappingProvider

+ (FEMManagedObjectMapping *)personMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Person" configuration:^(FEMManagedObjectMapping *mapping) {
		[mapping setPrimaryKey:@"personID"];  // object uniquing

		[mapping addAttributesFromDictionary:@{@"personID": @"id"}];
		[mapping addAttributesFromArray:@[@"name", @"email", @"gender"]];

		[mapping addRelationshipMapping:[self carMapping] forProperty:@"car" keyPath:@"car"];
		[mapping addToManyRelationshipMapping:[self phoneMapping] forProperty:@"phones" keyPath:@"phones"];
	}];
}

+ (FEMManagedObjectMapping *)carMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Car" configuration:^(FEMManagedObjectMapping *mapping) {
    [mapping setPrimaryKey:@"carID"];

		[mapping addAttributesFromArray:@[@"model", @"year"]];
	}];
}

+ (FEMManagedObjectMapping *)phoneMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Phone" configuration:^(FEMManagedObjectMapping *mapping) {
		[mapping addAttributesFromDictionary:@{@"phoneID" : @"id"}];
		[mapping addAttributesFromArray:@[@"number", @"ddd", @"ddi"]];
	}];
}

@end
```


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
