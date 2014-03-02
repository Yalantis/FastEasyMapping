//
// EMKDeserializer.h 
// EasyMappingKit
//
// Created by dmitriy on 3/2/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import <Foundation/Foundation.h>

@class EMKAttributeMapping;

@interface EMKDeserializer : NSObject

+ (id)deserializeAttributeFromRepresentation:(NSDictionary *)representation usingMapping:(EMKAttributeMapping *)mapping;

@end