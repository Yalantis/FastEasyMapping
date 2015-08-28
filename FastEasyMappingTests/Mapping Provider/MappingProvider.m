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
	[mapping setPrimaryKey:@"carID"];
    [mapping addAttributesFromDictionary:@{@"carID" : @"id"}];

	return mapping;
}

+ (FEMMapping *)carMapping {
	return [FEMMapping mappingForEntityName:@"Car" configuration:^(FEMMapping *mapping) {
        [mapping addAttributesFromArray:@[@"model", @"year"]];
	}];
}

+ (FEMMapping *)carWithRootKeyMapping {
	return [FEMMapping mappingForEntityName:@"Car"
	                                            rootPath:@"car"
			                               configuration:^(FEMMapping *mapping) {
//       [mapping setPrimaryKey:@"carID"];
                                               [mapping addAttributesFromDictionary:@{@"carID" : @"id"}];
                                               [mapping addAttributesFromArray:@[@"model", @"year"]];
			                               }];
}

+ (FEMMapping *)carNestedAttributesMapping {
	return [FEMMapping mappingForEntityName:@"Car" configuration:^(FEMMapping *mapping) {
//		[mapping setPrimaryKey:@"carID"];
        [mapping addAttributesFromDictionary:@{@"carID" : @"id", @"year" : @"information.year"}];
        [mapping addAttributesFromArray:@[@"model"]];
	}];
}

+ (FEMMapping *)carWithDateMapping {
	return [FEMMapping mappingForEntityName:@"Car" configuration:^(FEMMapping *mapping) {
//		[mapping setPrimaryKey:@"carID"];
        [mapping addAttributesFromDictionary:@{@"carID" : @"id"}];
        [mapping addAttributesFromArray:@[@"model", @"year"]];
        [mapping addAttribute:[FEMAttribute mappingOfProperty:@"createdAt"
                                                    toKeyPath:@"created_at"
                                                   dateFormat:@"yyyy-MM-dd"]];
	}];
}

+ (FEMMapping *)phoneMapping {
	return [FEMMapping mappingForEntityName:@"Phone" configuration:^(FEMMapping *mapping) {
//		[mapping setPrimaryKey:@"phoneID"];
        [mapping addAttributesFromDictionary:@{@"phoneID" : @"id"}];
        [mapping addAttributesFromArray:@[@"number", @"ddd", @"ddi"]];
	}];
}

+ (FEMMapping *)personMapping {
	return [FEMMapping mappingForEntityName:@"Person" configuration:^(FEMMapping *mapping) {
//		[mapping setPrimaryKey:@"personID"];
        [mapping addAttributesFromDictionary:@{@"personID" : @"id"}];
        [mapping addAttributesFromArray:@[@"name", @"email", @"gender"]];

        [mapping addRelationshipMapping:[self carMapping] forProperty:@"car" keyPath:@"car"];
        [mapping addToManyRelationshipMapping:[self phoneMapping] forProperty:@"phones" keyPath:@"phones"];
	}];
}

+ (FEMMapping *)personWithPhoneMapping {
    return [FEMMapping mappingForEntityName:@"Person" configuration:^(FEMMapping *mapping) {
		[mapping setPrimaryKey:@"personID"];
        [mapping addAttributesFromDictionary:@{@"personID" : @"id"}];
        [mapping addAttributesFromArray:@[@"name", @"email", @"gender"]];

        FEMMapping *phoneMapping = [self phoneMapping];
        phoneMapping.primaryKey = @"phoneID";
        [mapping addToManyRelationshipMapping:phoneMapping forProperty:@"phones" keyPath:@"phones"];
    }];
}

+ (FEMMapping *)personWithCarMapping {
	return [FEMMapping mappingForEntityName:@"Person" configuration:^(FEMMapping *mapping) {
		[mapping setPrimaryKey:@"personID"];
        [mapping addAttributesFromDictionary:@{@"personID" : @"id"}];
        [mapping addAttributesFromArray:@[@"name", @"email"]];

        [mapping addRelationshipMapping:[self carMappingWithPrimaryKey] forProperty:@"car" keyPath:@"car"];
	}];
}

@end
