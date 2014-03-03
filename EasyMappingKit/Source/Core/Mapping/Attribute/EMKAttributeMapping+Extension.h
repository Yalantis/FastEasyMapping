//
// EMKAttributeMapping+Extension.h
// EasyMappingCoreDataExample
//
// Created by dmitriy on 2/24/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import <Foundation/Foundation.h>
#import "EMKAttributeMapping.h"

@interface EMKAttributeMapping (Extension)

- (id)mappedValueFromRepresentation:(id)representation;
- (void)mapValueToObject:(id)object fromRepresentation:(id)representation;

@end