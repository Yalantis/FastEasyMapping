//
// EMKAttributeMapping+Extension.m
// EasyMappingCoreDataExample
//
// Created by dmitriy on 2/24/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import "EMKAttributeMapping+Extension.h"
#import "EMKPropertyHelper.h"
#import "NSObject+EMKKVC.h"

@implementation EMKAttributeMapping (Extension)

- (id)mappedValueFromRepresentation:(id)representation {
	id value = self.keyPath ? [representation valueForKeyPath:self.keyPath] : representation;
    
	return [self mapValue:value];
}

- (void)mapValueToObject:(id)object fromRepresentation:(id)representation {
	id value = [self mappedValueFromRepresentation:representation];
	if (value == NSNull.null && ![EMKPropertyHelper propertyNameIsNative:self.property fromObject:object]) {
		[object setValue:nil forKey:self.property];
	} else if (value) {
		[object emk_setValueIfDifferent:value forKey:self.property];
	}
}

@end