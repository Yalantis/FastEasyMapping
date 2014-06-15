// Copyright (c) 2014 Lucas Medeiros.
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
#import "FEMObjectMapping.h"
#import "FEMManagedObjectMapping.h"
#import "FEMAttributeMapping.h"
#import "FEMRelationshipMapping.h"

@implementation MappingProvider

+ (FEMManagedObjectMapping *)carMappingWithPrimaryKey {
	FEMManagedObjectMapping *mapping = [self carMapping];
	[mapping setPrimaryKey:@"carID"];
	[mapping addAttributeMappingDictionary:@{@"carID" : @"id"}];

	return mapping;
}

+ (FEMManagedObjectMapping *)carMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Car" configuration:^(FEMManagedObjectMapping *mapping) {
		[mapping addAttributeMappingFromArray:@[@"model", @"year"]];
	}];
}

+ (FEMManagedObjectMapping *)carWithRootKeyMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Car"
	                                            rootPath:@"car"
			                               configuration:^(FEMManagedObjectMapping *mapping) {
//       [mapping setPrimaryKey:@"carID"];
				                               [mapping addAttributeMappingDictionary:@{@"carID" : @"id"}];
				                               [mapping addAttributeMappingFromArray:@[@"model", @"year"]];
			                               }];
}

+ (FEMManagedObjectMapping *)carNestedAttributesMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Car" configuration:^(FEMManagedObjectMapping *mapping) {
//		[mapping setPrimaryKey:@"carID"];
		[mapping addAttributeMappingDictionary:@{@"carID" : @"id", @"year" : @"information.year"}];
		[mapping addAttributeMappingFromArray:@[@"model"]];
	}];
}

+ (FEMManagedObjectMapping *)carWithDateMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Car" configuration:^(FEMManagedObjectMapping *mapping) {
//		[mapping setPrimaryKey:@"carID"];
		[mapping addAttributeMappingDictionary:@{@"carID" : @"id"}];
		[mapping addAttributeMappingFromArray:@[@"model", @"year"]];
		[mapping addAttributeMapping:[FEMAttributeMapping mappingOfProperty:@"createdAt"
                                                                  toKeyPath:@"created_at"
                                                                 dateFormat:@"yyyy-MM-dd"]];
	}];
}

+ (FEMManagedObjectMapping *)phoneMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Phone" configuration:^(FEMManagedObjectMapping *mapping) {
//		[mapping setPrimaryKey:@"phoneID"];
		[mapping addAttributeMappingDictionary:@{@"phoneID" : @"id"}];
		[mapping addAttributeMappingFromArray:@[@"number", @"ddd", @"ddi"]];
	}];
}

+ (FEMManagedObjectMapping *)personMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Person" configuration:^(FEMManagedObjectMapping *mapping) {
//		[mapping setPrimaryKey:@"personID"];
		[mapping addAttributeMappingDictionary:@{@"personID" : @"id"}];
		[mapping addAttributeMappingFromArray:@[@"name", @"email", @"gender"]];
		[mapping addRelationshipMapping:[FEMRelationshipMapping mappingOfProperty:@"car"
		                                                            configuration:^(FEMRelationshipMapping *relationshipMapping) {
			                                                            [relationshipMapping setObjectMapping:[self carMapping]
			                                                                                       forKeyPath:@"car"];
		                                                            }]];

		[mapping addRelationshipMapping:[FEMRelationshipMapping mappingOfProperty:@"phones"
		                                                            configuration:^(FEMRelationshipMapping *relationshipMapping) {
			                                                            [relationshipMapping setToMany:YES];
			                                                            [relationshipMapping setObjectMapping:[self phoneMapping]
			                                                                                       forKeyPath:@"phones"];
		                                                            }]];
	}];
}

+ (FEMManagedObjectMapping *)personWithCarMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Person" configuration:^(FEMManagedObjectMapping *mapping) {
		[mapping setPrimaryKey:@"personID"];
		[mapping addAttributeMappingDictionary:@{@"personID" : @"id"}];
		[mapping addAttributeMappingFromArray:@[@"name", @"email"]];
		[mapping addRelationshipMapping:[FEMRelationshipMapping mappingOfProperty:@"car"
		                                                            configuration:^(FEMRelationshipMapping *relationshipMapping) {
            [relationshipMapping setObjectMapping:[self carMappingWithPrimaryKey] forKeyPath:@"car"];
        }]];
	}];
}

@end
