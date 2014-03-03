//
//  EMKSerializer.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 25/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "EMKSerializer.h"
#import "EMKAttributeMapping.h"
#import "EMKPropertyHelper.h"
#import "EMKRelationshipMapping.h"

@implementation EMKSerializer

+ (NSDictionary *)serializeObject:(id)object usingMapping:(EMKMapping *)mapping {
	NSMutableDictionary *representation = [NSMutableDictionary dictionary];

	for (EMKAttributeMapping *fieldMapping in mapping.attributeMappings) {
		[self setValueOnRepresentation:representation fromObject:object withFieldMapping:fieldMapping];
	}

	for (EMKRelationshipMapping *relationshipMapping in mapping.relationshipMappings) {
		[self setRelationshipObjectOn:representation usingMapping:relationshipMapping fromObject:object];
	}

	if (mapping.rootPath.length > 0) {
		return @{mapping.rootPath : representation};
	}

	return representation;
}

+ (NSArray *)serializeCollection:(NSArray *)collection usingMapping:(EMKMapping *)mapping {
	NSMutableArray *array = [NSMutableArray array];

	for (id object in collection) {
		NSDictionary *objectRepresentation = [self serializeObject:object usingMapping:mapping];
		[array addObject:objectRepresentation];
	}

	return [NSArray arrayWithArray:array];
}

+ (void)setValueOnRepresentation:(NSMutableDictionary *)representation fromObject:(id)object withFieldMapping:(EMKAttributeMapping *)fieldMapping {
	SEL selector = NSSelectorFromString(fieldMapping.property);
	id returnedValue = [EMKPropertyHelper performSelector:selector onObject:object];

	if (returnedValue) {
		returnedValue = [fieldMapping reverseMapValue:returnedValue];

		[self setValue:returnedValue forKeyPath:fieldMapping.keyPath inRepresentation:representation];
	}
}

+ (void)setValue:(id)value forKeyPath:(NSString *)keyPath inRepresentation:(NSMutableDictionary *)representation {
	NSArray *keyPathComponents = [keyPath componentsSeparatedByString:@"."];
	if ([keyPathComponents count] == 1) {
		[representation setObject:value forKey:keyPath];
	} else if ([keyPathComponents count] > 1) {
		NSString *attributeKey = [keyPathComponents lastObject];
		NSMutableArray *subPaths = [NSMutableArray arrayWithArray:keyPathComponents];
		[subPaths removeLastObject];

		id currentPath = representation;
		for (NSString *key in subPaths) {
			id subPath = [currentPath valueForKey:key];
			if (subPath == nil) {
				subPath = [NSMutableDictionary new];
				[currentPath setValue:subPath forKey:key];
			}
			currentPath = subPath;
		}
		[currentPath setValue:value forKey:attributeKey];
	}
}

+ (void)setRelationshipObjectOn:(NSMutableDictionary *)representation
                   usingMapping:(EMKRelationshipMapping *)relationshipMapping
			         fromObject:(id)object {
	id value = [EMKPropertyHelper performSelector:NSSelectorFromString(relationshipMapping.property) onObject:object];
	if (value) {
		id relationshipRepresentation = nil;
		if (relationshipMapping.isToMany) {
			relationshipRepresentation = [self serializeCollection:value usingMapping:relationshipMapping.objectMapping];
		} else {
			relationshipRepresentation = [self serializeObject:value usingMapping:relationshipMapping.objectMapping];
		}

		// todo: if there are no keypath - just add all fields
		[representation setObject:relationshipRepresentation forKey:relationshipMapping.objectMapping.rootPath];
	}
}

@end