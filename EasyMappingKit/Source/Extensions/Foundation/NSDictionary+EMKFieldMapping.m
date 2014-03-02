//
// NSDictionary+EMKAttributeMapping.m
// EasyMappingCoreDataExample
//
// Created by dmitriy on 2/24/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import "NSDictionary+EMKFieldMapping.h"
#import "EMKAttributeMapping.h"
#import "EMKMapping.h"

@implementation NSDictionary (EMKFieldMapping)

- (id)ek_objectRepresentationForMapping:(EMKMapping *)mapping
{
	if (mapping.rootPath) {
		return [self valueForKeyPath:mapping.rootPath];
	}

	return self;
}

@end