//
// EMKObjectMapping.h
// EasyMappingCoreDataExample
//
// Created by dmitriy on 2/24/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import <Foundation/Foundation.h>
#import "EMKMapping.h"

@interface EMKObjectMapping : EMKMapping

@property (nonatomic, readonly) Class objectClass;

- (id)initWithObjectClass:(Class)objectClass;
- (id)initWithObjectClass:(Class)objectClass rootPath:(NSString *)rootPath;

+ (instancetype)mappingForClass:(Class)objectClass configuration:(void (^)(EMKObjectMapping *mapping))configuration;
+ (instancetype)mappingForClass:(Class)objectClass
                       rootPath:(NSString *)rootPath
		          configuration:(void (^)(EMKObjectMapping *mapping))configuration;

@end