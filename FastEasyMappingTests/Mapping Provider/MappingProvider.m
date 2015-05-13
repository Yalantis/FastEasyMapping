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
        [mapping addRelationship:[FEMRelationship mappingOfProperty:@"car"
                                                      configuration:^(FEMRelationship *relationshipMapping) {
                                                          [relationshipMapping setObjectMapping:[self carMapping]
                                                                                     forKeyPath:@"car"];
                                                      }]];

        [mapping addRelationship:[FEMRelationship mappingOfProperty:@"phones"
                                                      configuration:^(FEMRelationship *relationshipMapping) {
                                                          [relationshipMapping setToMany:YES];
                                                          [relationshipMapping setObjectMapping:[self phoneMapping] forKeyPath:@"phones"];
                                                      }]];
	}];
}

+ (FEMMapping *)personWithPhoneMapping {
    return [FEMMapping mappingForEntityName:@"Person" configuration:^(FEMMapping *mapping) {
		[mapping setPrimaryKey:@"personID"];
        [mapping addAttributesFromDictionary:@{@"personID" : @"id"}];
        [mapping addAttributesFromArray:@[@"name", @"email", @"gender"]];

        [mapping addRelationship:[FEMRelationship mappingOfProperty:@"phones"
                                                      configuration:^(FEMRelationship *relationshipMapping) {
                                                          FEMMapping *phoneMapping = [self phoneMapping];
                                                          [phoneMapping setPrimaryKey:@"phoneID"];

                                                          [relationshipMapping setToMany:YES];
                                                          [relationshipMapping setObjectMapping:phoneMapping forKeyPath:@"phones"];
                                                      }]];
    }];
}

+ (FEMMapping *)personWithCarMapping {
	return [FEMMapping mappingForEntityName:@"Person" configuration:^(FEMMapping *mapping) {
		[mapping setPrimaryKey:@"personID"];
        [mapping addAttributesFromDictionary:@{@"personID" : @"id"}];
        [mapping addAttributesFromArray:@[@"name", @"email"]];
        [mapping addRelationship:[FEMRelationship mappingOfProperty:@"car"
                                                      configuration:^(FEMRelationship *relationshipMapping) {
                                                          [relationshipMapping setObjectMapping:[self carMappingWithPrimaryKey] forKeyPath:@"car"];
                                                      }]];
	}];
}

@end
