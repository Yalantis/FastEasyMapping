//
//  MappingProvider.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 23/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "MappingProvider.h"
#import "Car.h"
#import "Phone.h"
#import "Person.h"
#import "EMKManagedObjectMapping.h"
#import "EMKAttributeMapping.h"
#import "EMKRelationshipMapping.h"

@implementation MappingProvider

+ (EMKManagedObjectMapping *)carMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Car" configuration:^(EMKManagedObjectMapping *mapping) {
		[mapping setPrimaryKey:@"carID"];
		[mapping addAttributeMappingDictionary:@{@"carID" : @"id"}];
		[mapping addAttributeMappingFromArray:@[@"model", @"year"]];
	}];
}

+ (EMKManagedObjectMapping *)carWithRootKeyMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Car" rootPath:@"car" configuration:^(EMKManagedObjectMapping *mapping) {
       [mapping setPrimaryKey:@"carID"];
       [mapping addAttributeMappingDictionary:@{@"carID" : @"id"}];
       [mapping addAttributeMappingFromArray:@[@"model", @"year"]];
   }];
}

+ (EMKManagedObjectMapping *)carNestedAttributesMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Car" configuration:^(EMKManagedObjectMapping *mapping) {
		[mapping setPrimaryKey:@"carID"];
		[mapping addAttributeMappingDictionary:@{@"carID" : @"id", @"year" : @"information.year"}];
		[mapping addAttributeMappingFromArray:@[@"model"]];
	}];
}

+ (EMKManagedObjectMapping *)carWithDateMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Car" configuration:^(EMKManagedObjectMapping *mapping) {
		[mapping setPrimaryKey:@"carID"];
		[mapping addAttributeMappingDictionary:@{@"carID" : @"id"}];
		[mapping addAttributeMappingFromArray:@[@"model", @"year"]];
		[mapping addAttributeMapping:[EMKAttributeMapping mappingOfProperty:@"createdAt"
		                                                            keyPath:@"created_at"
			                                                     dateFormat:@"yyyy-MM-dd"]];
	}];
}

+ (EMKManagedObjectMapping *)phoneMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Phone" configuration:^(EMKManagedObjectMapping *mapping) {
		[mapping setPrimaryKey:@"phoneID"];
		[mapping addAttributeMappingDictionary:@{@"phoneID" : @"id"}];
		[mapping addAttributeMappingFromArray:@[@"number", @"ddd", @"ddi"]];
	}];
}

+ (EMKManagedObjectMapping *)personMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Person" configuration:^(EMKManagedObjectMapping *mapping) {
		[mapping setPrimaryKey:@"personID"];
		[mapping addAttributeMappingDictionary:@{@"personID": @"id"}];
		[mapping addAttributeMappingFromArray:@[@"name", @"email", @"gender"]];
		[mapping addRelationshipMapping:[EMKRelationshipMapping mappingOfProperty:@"car"
		                                                            configuration:^(EMKRelationshipMapping *relationshipMapping) {
            [relationshipMapping setObjectMapping:[self carMapping] forKeyPath:@"car"];
		}]];

		[mapping addRelationshipMapping:[EMKRelationshipMapping mappingOfProperty:@"phones"
		                                                            configuration:^(EMKRelationshipMapping *relationshipMapping) {
            [relationshipMapping setToMany:YES];
            [relationshipMapping setObjectMapping:[self phoneMapping] forKeyPath:@"phones"];
        }]];
	}];
}

+ (EMKManagedObjectMapping *)personWithCarMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Person" configuration:^(EMKManagedObjectMapping *mapping) {
		[mapping setPrimaryKey:@"personID"];
		[mapping addAttributeMappingDictionary:@{@"personID": @"id"}];
		[mapping addAttributeMappingFromArray:@[@"name", @"email"]];
		[mapping addRelationshipMapping:[EMKRelationshipMapping mappingOfProperty:@"car"
		                                                            configuration:^(EMKRelationshipMapping *relationshipMapping) {
            [relationshipMapping setObjectMapping:[self carMapping] forKeyPath:@"car"];
        }]];
	}];
}

+ (EMKManagedObjectMapping *)personWithPhonesMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Person" configuration:^(EMKManagedObjectMapping *mapping) {
		[mapping setPrimaryKey:@"personID"];
		[mapping addAttributeMappingDictionary:@{@"personID": @"id"}];
		[mapping addAttributeMappingFromArray:@[@"name", @"email"]];
		[mapping addRelationshipMapping:[EMKRelationshipMapping mappingOfProperty:@"phones"
		                                                            configuration:^(EMKRelationshipMapping *relationshipMapping) {
            [relationshipMapping setToMany:YES];
            [relationshipMapping setObjectMapping:[self phoneMapping] forKeyPath:@"phones"];
        }]];
	}];
}

+ (EMKManagedObjectMapping *)personWithOnlyValueBlockMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Person" configuration:^(EMKManagedObjectMapping *mapping) {
		[mapping setPrimaryKey:@"personID"];
		[mapping addAttributeMappingDictionary:@{@"personID": @"id"}];
		[mapping addAttributeMappingFromArray:@[@"name", @"email", @"gender"]];
	}];
}

@end
