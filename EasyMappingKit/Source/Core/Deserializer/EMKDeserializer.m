//
// EMKDeserializer.m 
// EasyMappingKit
//
// Created by dmitriy on 3/2/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import "EMKDeserializer.h"
#import "EMKAttributeMapping.h"

@implementation EMKDeserializer

+ (id)deserializeAttributeFromRepresentation:(NSDictionary *)representation usingMapping:(EMKAttributeMapping *)mapping {
	id value = mapping.keyPath ? [representation objectForKey:mapping.keyPath] : representation;
	return [mapping mapValue:value];
}

@end