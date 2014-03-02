//
//  NSArray+EMKExtension.m
//  EasyMappingCoreDataExample
//
//  Created by Lucas Medeiros on 2/24/14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "NSArray+EMKExtension.h"

@implementation NSArray (EMKExtension)

- (id)ek_propertyRepresentation:(objc_property_t)property {
	id convertedObject = self;
	if (property) {
		NSString *propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
		if ([propertyAttributes length] > 0) {
			if (!NSEqualRanges([propertyAttributes rangeOfString:@"NSSet"], NSMakeRange(NSNotFound, 0))) {
				convertedObject = [NSSet setWithArray:self];
			}
			else if (!NSEqualRanges([propertyAttributes rangeOfString:@"NSMutableSet"], NSMakeRange(NSNotFound, 0))) {
				convertedObject = [[NSSet setWithArray:self] mutableCopy];
			}
			else if (!NSEqualRanges([propertyAttributes rangeOfString:@"NSOrderedSet"], NSMakeRange(NSNotFound, 0))) {
				convertedObject = [NSOrderedSet orderedSetWithArray:self];
			}
			else if (!NSEqualRanges([propertyAttributes rangeOfString:@"NSMutableOrderedSet"], NSMakeRange(NSNotFound, 0))) {
				convertedObject = [[NSOrderedSet orderedSetWithArray:self] mutableCopy];
			}
			else if (!NSEqualRanges([propertyAttributes rangeOfString:@"NSMutableArray"], NSMakeRange(NSNotFound, 0))) {
				convertedObject = [NSMutableArray arrayWithArray:self];
			}
		}
	}
	return convertedObject;
}

@end