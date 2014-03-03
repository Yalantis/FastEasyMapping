//
// EMKObjectMapping.m
// EasyMappingCoreDataExample
//
// Created by dmitriy on 2/24/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import "EMKObjectMapping.h"

@implementation EMKObjectMapping

#pragma mark - Init

- (id)initWithObjectClass:(Class)objectClass rootPath:(NSString *)rootPath {
	self = [self initWithRootPath:rootPath];
	if (self) {
		_objectClass = objectClass;
	}
	return self;
}

- (id)initWithObjectClass:(Class)objectClass {
	return [self initWithObjectClass:objectClass rootPath:nil];
}

+ (instancetype)mappingForClass:(Class)objectClass configuration:(void (^)(EMKObjectMapping *mapping))configuration {
	EMKObjectMapping *mapping = [[self alloc] initWithObjectClass:objectClass];
	configuration(mapping);
	return mapping;
}

+ (instancetype)mappingForClass:(Class)objectClass
                       rootPath:(NSString *)rootPath
		          configuration:(void (^)(EMKObjectMapping *mapping))configuration {
	EMKObjectMapping *mapping = [[self alloc] initWithObjectClass:objectClass rootPath:rootPath];
	configuration(mapping);
	return mapping;
}

@end