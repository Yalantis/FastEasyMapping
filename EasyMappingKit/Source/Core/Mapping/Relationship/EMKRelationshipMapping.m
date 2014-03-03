//
// EMKRelationshipMapping.m
// EasyMappingKit
//
// Created by dmitriy on 3/2/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import "EMKRelationshipMapping.h"
#import "EMKMapping.h"

@implementation EMKRelationshipMapping

@synthesize property = _property;
@synthesize keyPath = _keyPath;

#pragma mark - Init

- (id)initWithProperty:(NSString *)property keyPath:(NSString *)keyPath objectMapping:(EMKMapping *)objectMapping {
	NSParameterAssert(property.length > 0);

	self = [super init];
	if (self) {
		_property = [property copy];
		[self setObjectMapping:objectMapping];
	}

	return self;
}

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath configuration:(void (^)(
	EMKRelationshipMapping *mapping))configuration {
	NSParameterAssert(configuration);

	EMKRelationshipMapping *mapping = [[self alloc] initWithProperty:property keyPath:keyPath objectMapping:nil];
	configuration(mapping);
	return mapping;
}

+ (instancetype)mappingOfProperty:(NSString *)property configuration:(void (^)(EMKRelationshipMapping *mapping))configuration {
	return [self mappingOfProperty:property keyPath:nil configuration:configuration];
}

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath objectMapping:(EMKMapping *)objectMapping {
	return [[self alloc] initWithProperty:property keyPath:keyPath objectMapping:objectMapping];
}

#pragma mark - Property objectMapping

- (void)setObjectMapping:(EMKMapping *)objectMapping {
	_objectMapping = objectMapping;

	[_objectMapping setRootPath:self.keyPath];
}

- (void)setObjectMapping:(EMKMapping *)objectMapping forKeyPath:(NSString *)keyPath {
	[self setObjectMapping:objectMapping];
	[self setKeyPath:keyPath];
}

#pragma mark - Property keyPath

- (void)setKeyPath:(NSString *)keyPath {
	_keyPath = [keyPath copy];

	[self.objectMapping setRootPath:_keyPath];
}

- (NSString *)keyPath {
	NSParameterAssert(_keyPath == self.objectMapping.rootPath);

	return _keyPath;
}

@end