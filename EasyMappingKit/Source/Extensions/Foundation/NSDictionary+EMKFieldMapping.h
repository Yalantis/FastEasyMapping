//
// NSDictionary+EMKAttributeMapping.h
// EasyMappingCoreDataExample
//
// Created by dmitriy on 2/24/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import <Foundation/Foundation.h>

@class EMKMapping;

@interface NSDictionary (EMKFieldMapping)

- (id)ek_objectRepresentationForMapping:(EMKMapping *)mapping;

@end