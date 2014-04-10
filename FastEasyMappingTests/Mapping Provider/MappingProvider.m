// Copyright (c) 2014 Yalantis.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MappingProvider.h"
#import "Car.h"
#import "Phone.h"
#import "Person.h"
#import "EMKObjectMapping.h"
#import "EMKManagedObjectMapping.h"
#import "EMKAttributeMapping.h"
#import "EMKRelationshipMapping.h"

@implementation MappingProvider

+ (EMKManagedObjectMapping *)carMappingWithPrimaryKey {
	EMKManagedObjectMapping *mapping = [self carMapping];
	[mapping setPrimaryKey:@"carID"];
	[mapping addAttributeMappingDictionary:@{@"carID" : @"id"}];

	return mapping;
}

+ (EMKManagedObjectMapping *)carMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Car" configuration:^(EMKManagedObjectMapping *mapping) {
		[mapping addAttributeMappingFromArray:@[@"model", @"year"]];
	}];
}

+ (EMKManagedObjectMapping *)carWithRootKeyMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Car" rootPath:@"car" configuration:^(EMKManagedObjectMapping *mapping) {
//       [mapping setPrimaryKey:@"carID"];
       [mapping addAttributeMappingDictionary:@{@"carID" : @"id"}];
       [mapping addAttributeMappingFromArray:@[@"model", @"year"]];
   }];
}

+ (EMKManagedObjectMapping *)carNestedAttributesMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Car" configuration:^(EMKManagedObjectMapping *mapping) {
//		[mapping setPrimaryKey:@"carID"];
		[mapping addAttributeMappingDictionary:@{@"carID" : @"id", @"year" : @"information.year"}];
		[mapping addAttributeMappingFromArray:@[@"model"]];
	}];
}

+ (EMKManagedObjectMapping *)carWithDateMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Car" configuration:^(EMKManagedObjectMapping *mapping) {
//		[mapping setPrimaryKey:@"carID"];
		[mapping addAttributeMappingDictionary:@{@"carID" : @"id"}];
		[mapping addAttributeMappingFromArray:@[@"model", @"year"]];
		[mapping addAttributeMapping:[EMKAttributeMapping mappingOfProperty:@"createdAt"
		                                                            keyPath:@"created_at"
			                                                     dateFormat:@"yyyy-MM-dd"]];
	}];
}

+ (EMKManagedObjectMapping *)phoneMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Phone" configuration:^(EMKManagedObjectMapping *mapping) {
//		[mapping setPrimaryKey:@"phoneID"];
		[mapping addAttributeMappingDictionary:@{@"phoneID" : @"id"}];
		[mapping addAttributeMappingFromArray:@[@"number", @"ddd", @"ddi"]];
	}];
}

+ (EMKManagedObjectMapping *)personMapping {
	return [EMKManagedObjectMapping mappingForEntityName:@"Person" configuration:^(EMKManagedObjectMapping *mapping) {
//		[mapping setPrimaryKey:@"personID"];
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
//		[mapping setPrimaryKey:@"personID"];
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
//		[mapping setPrimaryKey:@"personID"];
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
//		[mapping setPrimaryKey:@"personID"];
		[mapping addAttributeMappingDictionary:@{@"personID": @"id"}];
		[mapping addAttributeMappingFromArray:@[@"name", @"email", @"gender"]];
	}];
}

@end
