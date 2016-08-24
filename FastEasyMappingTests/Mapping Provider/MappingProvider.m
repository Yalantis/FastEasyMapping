// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "MappingProvider.h"
#import "Car.h"
#import "Phone.h"
#import "Person.h"
#import "FEMMapping.h"
#import "FEMMapping.h"
#import "FEMAttribute.h"
#import "FEMRelationship.h"

@implementation MappingProvider

+ (FEMMapping *)carMappingWithPrimaryKey {
	FEMMapping *mapping = [self carMapping];
    mapping.primaryKey = @"carID";
    [mapping addAttributesFromDictionary:@{@"carID": @"id"}];

	return mapping;
}

+ (FEMMapping *)carMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Car"];
    [mapping addAttributesFromArray:@[@"model", @"year"]];

    return mapping;
}

+ (FEMMapping *)carWithRootKeyMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Car" rootPath:@"car"];
    [mapping addAttributesFromDictionary:@{@"carID" : @"id"}];
    [mapping addAttributesFromArray:@[@"model", @"year"]];

    return mapping;
}

+ (FEMMapping *)carNestedAttributesMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Car"];
    [mapping addAttributesFromDictionary:@{@"carID" : @"id", @"year" : @"information.year"}];
    [mapping addAttributesFromArray:@[@"model"]];

    return mapping;
}

+ (FEMMapping *)carWithDateMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Car"];
    [mapping addAttributesFromDictionary:@{@"carID" : @"id"}];
    [mapping addAttributesFromArray:@[@"model", @"year"]];
    FEMAttribute *createdAtAttribute = [FEMAttribute mappingOfProperty:@"createdAt" toKeyPath:@"created_at" dateFormat:@"yyyy-MM-dd"];
    [mapping addAttribute:createdAtAttribute];

    return mapping;
}

+ (FEMMapping *)phoneMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Phone"];
    mapping.primaryKey = @"phoneID";
    [mapping addAttributesFromDictionary:@{@"phoneID" : @"id"}];
    [mapping addAttributesFromArray:@[@"number", @"ddd", @"ddi"]];

    return mapping;
}

+ (FEMMapping *)personMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Person"];
    mapping.primaryKey = @"personID";
    [mapping addAttributesFromDictionary:@{@"personID" : @"id"}];
    [mapping addAttributesFromArray:@[@"name", @"email", @"gender"]];

    [mapping addRelationshipMapping:[self carMapping] forProperty:@"car" keyPath:@"car"];
    [mapping addToManyRelationshipMapping:[self phoneMapping] forProperty:@"phones" keyPath:@"phones"];

    return mapping;
}

+ (FEMMapping *)personWithPhoneMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Person"];
    mapping.primaryKey = @"personID";
    [mapping addAttributesFromDictionary:@{@"personID" : @"id"}];
    [mapping addAttributesFromArray:@[@"name", @"email", @"gender"]];
    
    FEMMapping *phoneMapping = [self phoneMapping];
    phoneMapping.primaryKey = @"phoneID";
    [mapping addToManyRelationshipMapping:phoneMapping forProperty:@"phones" keyPath:@"phones"];
    
    return mapping;
}

+ (FEMMapping *)personWithRecursiveMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Person"];
    mapping.primaryKey = @"personID";
    [mapping addAttributesFromDictionary:@{@"personID" : @"id"}];
    [mapping addAttributesFromArray:@[@"name", @"email", @"gender"]];
    [mapping addRecursiveRelationshipMappingForProperty:@"partner" keypath:@"partner"];
    
    return mapping;
}

+ (FEMMapping *)personWithRecursiveToManyMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Person"];
    mapping.primaryKey = @"personID";
    [mapping addAttributesFromDictionary:@{@"personID" : @"id"}];
    [mapping addAttributesFromArray:@[@"name", @"email", @"gender"]];
    [mapping addRecursiveToManyRelationshipForProperty:@"friends" keypath:@"friends"];
    
    return mapping;
}

+ (FEMMapping *)personWithCarMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Person"];
    mapping.primaryKey = @"personID";
    [mapping addAttributesFromDictionary:@{@"personID": @"id"}];
    [mapping addAttributesFromArray:@[@"name", @"email"]];
    [mapping addRelationshipMapping:[self carMappingWithPrimaryKey] forProperty:@"car" keyPath:@"car"];

    return mapping;
}

+ (FEMMapping *)personWithCarPKMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Person"];
    mapping.primaryKey = @"personID";
    [mapping addAttributesFromDictionary:@{@"personID": @"id"}];
    [mapping addAttributesFromArray:@[@"name", @"email"]];

    FEMMapping *carMapping = [[FEMMapping alloc] initWithEntityName:@"Car"];
    carMapping.primaryKey = @"carID";
    [carMapping addAttributeWithProperty:@"carID" keyPath:nil];
    [mapping addRelationshipMapping:carMapping forProperty:@"car" keyPath:@"car"];

    return mapping;
}

@end
