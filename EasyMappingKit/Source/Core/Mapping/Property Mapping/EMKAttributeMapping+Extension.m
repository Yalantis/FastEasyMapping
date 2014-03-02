//
// EMKAttributeMapping+Extension.m
// EasyMappingCoreDataExample
//
// Created by dmitriy on 2/24/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import "EMKAttributeMapping+Extension.h"
#import "EMKPropertyHelper.h"

@implementation EMKAttributeMapping (Extension)

- (void)mapValueToObject:(id)object fromRepresentation:(NSDictionary *)representation {
	id value = [self mapValue:[representation valueForKeyPath:self.keyPath]];
	if (value == [NSNull null]) {
		if (![EMKPropertyHelper propertyNameIsNative:self.property fromObject:object]) {
			[object setValue:nil forKeyPath:self.property];
		}
	} else if (value) {
		[object setValue:value forKeyPath:self.property];
	}
}

@end