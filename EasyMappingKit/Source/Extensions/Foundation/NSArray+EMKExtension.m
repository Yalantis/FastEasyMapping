//
//  NSArray+EMKExtension.m
//  EasyMappingCoreDataExample
//
//  Created by Lucas Medeiros on 2/24/14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "NSArray+EMKExtension.h"

extern NSString * getPropertyType(objc_property_t property);

@implementation NSArray (EMKExtension)

- (id)ek_propertyRepresentation:(objc_property_t)property {
	id convertedObject = self;
	if (property) {
		NSString *type = getPropertyType(property);
		if ([type isEqualToString:@"NSSet"]) {
			convertedObject = [NSSet setWithArray:self];
		}
		else if ([type isEqualToString:@"NSMutableSet"]) {
			convertedObject = [NSMutableSet setWithArray:self];
		}
		else if ([type isEqualToString:@"NSOrderedSet"]) {
			convertedObject = [NSOrderedSet orderedSetWithArray:self];
		}
		else if ([type isEqualToString:@"NSMutableOrderedSet"]) {
			convertedObject = [NSMutableOrderedSet orderedSetWithArray:self];
		}
		else if ([type isEqualToString:@"NSMutableArray"]) {
			convertedObject = [NSMutableArray arrayWithArray:self];
		}
	}
	return convertedObject;
}

@end