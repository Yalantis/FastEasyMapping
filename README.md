# EasyMappingKit

[![Build Status](https://travis-ci.org/Yalantis/EasyMappingKit.png)](https://travis-ci.org/Yalantis/EasyMappingKit)

### Note
This is fork of [EasyMapping](https://github.com/lucasmedeirosleite/EasyMapping) - flexible and easy way of JSON mapping.

## Reason to be
It turns out, that almost all popular libraries for JSON mapping SLOW. The main reason is often trips to database during lookup of existing objects. So we decided to take already existing [flexible solution](https://github.com/lucasmedeirosleite/EasyMapping) and improve overall performance. 
<p align="center" >
  <img src="https://raw.githubusercontent.com/Yalantis/EasyMappingKit/master/Assets/com.yalantis.easymappingkit.performance.png" alt="EasyMappingKit" title="EasyMappingKit">
</p>

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

+ (EMKManagedObjectMapping *)personMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Person" configuration:^(EMKManagedObjectMapping *mapping) {
		[mapping setPrimaryKey:@"personID"];  // object uniquing

		[mapping addAttributeMappingDictionary:@{@"personID": @"id"}];
		[mapping addAttributeMappingFromArray:@[@"name", @"email", @"gender"]];

		[mapping addRelationshipMapping:[self carMapping] forProperty:@"car" keyPath:@"car"];
		[mapping addToManyRelationshipMapping:[self phoneMapping] forProperty:@"phones" keyPath:@"phones"];
	}];
}

+ (EMKManagedObjectMapping *)carMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Car" configuration:^(EMKManagedObjectMapping *mapping) {
    [mapping setPrimaryKey:@"carID"];

		[mapping addAttributeMappingFromArray:@[@"model", @"year"]];
	}];
}

+ (EMKManagedObjectMapping *)phoneMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Phone" configuration:^(EMKManagedObjectMapping *mapping) {
		[mapping addAttributeMappingDictionary:@{@"phoneID" : @"id"}];
		[mapping addAttributeMappingFromArray:@[@"number", @"ddd", @"ddi"]];
	}];
}

```

* Converting a NSDictionary or NSArray to a object class or collection now becomes easy:

```objective-c

Person *person = [EMKManagedObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
                                                                          usingMapping:[MappingProvider personMapping]
                                                                               context:context];
                                                                               
NSArray *cars = [EMKManagedObjectDeserializer deserializeCollectionExternalRepresentation:externalRepresentation
                                                                             usingMapping:[MappingProvider carMapping]
                                                                                  context:moc];

```

* Filling an existent object:

Supose you have something like this:

```objective-c
	
Person *person = // fetch somehow;

EMKManagedObjectMapping *mapping = [MappingProvider personMapping];
[EMKManagedObjectDeserializer fillObject:person fromExternalRepresentation:externalRepresentation usingMapping:mapping];

	
```

## Deserialization. NSObject

If you are using NSObject use `EKObjectMapping` instead of `EMKManagedObjectMapping` and  `EMKObjectDeserializer` instead of `EMKManagedObjectDeserializer`.

## Serialization

For both NSManagedObject and NSObject serialization to JSON looks the same:

```objective-c

NSDictionary *representation = [EMKSerializer serializeObject:car usingMapping:[MappingProvider carMapping]];
NSArray *collectionRepresentation = [EMKSerializer serializeCollection:cars usingMapping:[MappingProvider carMapping]];

```

# Thanks
* Special thanks to [lucasmedeirosleite](https://github.com/lucasmedeirosleite) for amazing framework.
