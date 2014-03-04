//
// NSObject+EMKKVC.m 
// EasyMappingKit
//
// Created by dmitriy on 3/4/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import "NSObject+EMKKVC.h"

@implementation NSObject (EMKKVC)

- (void)emk_setValueIfDifferent:(id)value forKey:(NSString *)key {
	id _value = [self valueForKey:key];
	if (_value == value) return;

	if (_value != nil && value == nil) {
		[self setValue:nil forKey:key];
	} else if (![value isEqual:_value]) {
		[self setValue:value forKey:key];
	}
}

@end