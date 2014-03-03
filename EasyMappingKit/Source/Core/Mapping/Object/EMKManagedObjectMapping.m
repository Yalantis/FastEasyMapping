//
//  EMKManagedObjectMapping.m
//  EasyMappingExample
//
//  Created by Alejandro Isaza on 2013-03-13.
//  Copyright (c) 2013 Alejandro Isaza. All rights reserved.
//

#import "EMKManagedObjectMapping.h"
#import "EMKAttributeMapping.h"

@implementation EMKManagedObjectMapping

#pragma mark - Init

- (id)initWithEntityName:(NSString *)entityName rootPath:(NSString *)rootPath {
	self = [self initWithRootPath:rootPath];
	if (self) {
		_entityName = [entityName copy];
	}
	return self;
}

- (id)initWithEntityName:(NSString *)entityName {
	return [self initWithEntityName:entityName rootPath:nil];
}

+ (EMKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName configuration:(void (^)(EMKManagedObjectMapping *mapping))configuration {
	EMKManagedObjectMapping *mapping = [[EMKManagedObjectMapping alloc] initWithEntityName:entityName];
	configuration(mapping);
	return mapping;
}

+ (EMKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName
                                         rootPath:(NSString *)rootPath
		                            configuration:(void (^)(EMKManagedObjectMapping *mapping))configuration {
	EMKManagedObjectMapping *mapping = [[EMKManagedObjectMapping alloc] initWithEntityName:entityName
	                                                                              rootPath:rootPath];
	configuration(mapping);
	return mapping;
}

#pragma mark - Properties

- (EMKAttributeMapping *)primaryKeyMapping {
	return [_attributesMap objectForKey:self.primaryKey];
}

@end
