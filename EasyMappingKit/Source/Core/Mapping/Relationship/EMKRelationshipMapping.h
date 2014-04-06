//
// EMKRelationshipMapping.h
// EasyMappingKit
//
// Created by dmitriy on 3/2/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import <Foundation/Foundation.h>
#import "EMKPropertyMapping.h"

@class EMKMapping;

@interface EMKRelationshipMapping : NSObject <EMKPropertyMapping>

@property (nonatomic, strong) EMKMapping *objectMapping;
@property (nonatomic, getter=isToMany) BOOL toMany;

- (void)setObjectMapping:(EMKMapping *)objectMapping forKeyPath:(NSString *)keyPath;

+ (instancetype)mappingOfProperty:(NSString *)property
                          keyPath:(NSString *)keyPath
	                configuration:(void (^)(EMKRelationshipMapping *mapping))configuration;

+ (instancetype)mappingOfProperty:(NSString *)property configuration:(void (^)(EMKRelationshipMapping *mapping))configuration;
+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath objectMapping:(EMKMapping *)objectMapping;

@end

@interface EMKRelationshipMapping (Extension)

- (id)extractRootFromExternalRepresentation:(id)externalRepresentation;

@end