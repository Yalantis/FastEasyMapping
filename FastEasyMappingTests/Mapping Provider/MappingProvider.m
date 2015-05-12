// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "MappingProvider.h"
#import "Car.h"
#import "Phone.h"
#import "Person.h"
#import "FEMObjectMapping.h"
#import "FEMManagedObjectMapping.h"
#import "FEMAttribute.h"
#import "FEMRelationship.h"

@implementation MappingProvider

+ (FEMManagedObjectMapping *)carMappingWithPrimaryKey {
	FEMManagedObjectMapping *mapping = [self carMapping];
	[mapping setPrimaryKey:@"carID"];
    [mapping addAttributesDictionary:@{@"carID" : @"id"}];

	return mapping;
}

+ (FEMManagedObjectMapping *)carMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Car" configuration:^(FEMManagedObjectMapping *mapping) {
        [mapping addAttributesFromArray:@[@"model", @"year"]];
	}];
}

+ (FEMManagedObjectMapping *)carWithRootKeyMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Car"
	                                            rootPath:@"car"
			                               configuration:^(FEMManagedObjectMapping *mapping) {
//       [mapping setPrimaryKey:@"carID"];
                                               [mapping addAttributesDictionary:@{@"carID" : @"id"}];
                                               [mapping addAttributesFromArray:@[@"model", @"year"]];
			                               }];
}

+ (FEMManagedObjectMapping *)carNestedAttributesMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Car" configuration:^(FEMManagedObjectMapping *mapping) {
//		[mapping setPrimaryKey:@"carID"];
        [mapping addAttributesDictionary:@{@"carID" : @"id", @"year" : @"information.year"}];
        [mapping addAttributesFromArray:@[@"model"]];
	}];
}

+ (FEMManagedObjectMapping *)carWithDateMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Car" configuration:^(FEMManagedObjectMapping *mapping) {
//		[mapping setPrimaryKey:@"carID"];
        [mapping addAttributesDictionary:@{@"carID" : @"id"}];
        [mapping addAttributesFromArray:@[@"model", @"year"]];
        [mapping addAttribute:[FEMAttribute mappingOfProperty:@"createdAt"
                                                    toKeyPath:@"created_at"
                                                   dateFormat:@"yyyy-MM-dd"]];
	}];
}

+ (FEMManagedObjectMapping *)phoneMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Phone" configuration:^(FEMManagedObjectMapping *mapping) {
//		[mapping setPrimaryKey:@"phoneID"];
        [mapping addAttributesDictionary:@{@"phoneID" : @"id"}];
        [mapping addAttributesFromArray:@[@"number", @"ddd", @"ddi"]];
	}];
}

+ (FEMManagedObjectMapping *)personMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Person" configuration:^(FEMManagedObjectMapping *mapping) {
//		[mapping setPrimaryKey:@"personID"];
        [mapping addAttributesDictionary:@{@"personID" : @"id"}];
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

+ (FEMManagedObjectMapping *)personWithPhoneMapping {
    return [FEMManagedObjectMapping mappingForEntityName:@"Person" configuration:^(FEMManagedObjectMapping *mapping) {
		[mapping setPrimaryKey:@"personID"];
        [mapping addAttributesDictionary:@{@"personID" : @"id"}];
        [mapping addAttributesFromArray:@[@"name", @"email", @"gender"]];

        [mapping addRelationship:[FEMRelationship mappingOfProperty:@"phones"
                                                      configuration:^(FEMRelationship *relationshipMapping) {
                                                          FEMManagedObjectMapping *phoneMapping = [self phoneMapping];
                                                          [phoneMapping setPrimaryKey:@"phoneID"];

                                                          [relationshipMapping setToMany:YES];
                                                          [relationshipMapping setObjectMapping:phoneMapping forKeyPath:@"phones"];
                                                      }]];
    }];
}

+ (FEMManagedObjectMapping *)personWithCarMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Person" configuration:^(FEMManagedObjectMapping *mapping) {
		[mapping setPrimaryKey:@"personID"];
        [mapping addAttributesDictionary:@{@"personID" : @"id"}];
        [mapping addAttributesFromArray:@[@"name", @"email"]];
        [mapping addRelationship:[FEMRelationship mappingOfProperty:@"car"
                                                      configuration:^(FEMRelationship *relationshipMapping) {
                                                          [relationshipMapping setObjectMapping:[self carMappingWithPrimaryKey] forKeyPath:@"car"];
                                                      }]];
	}];
}

@end
