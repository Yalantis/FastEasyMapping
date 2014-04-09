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

+ (NSDictionary *)_serializeObject:(id)object usingMapping:(EMKMapping *)mapping {
	NSMutableDictionary *representation = [NSMutableDictionary dictionary];

	for (EMKAttributeMapping *fieldMapping in mapping.attributeMappings) {
		[self setValueOnRepresentation:representation fromObject:object withFieldMapping:fieldMapping];
	}

	for (EMKRelationshipMapping *relationshipMapping in mapping.relationshipMappings) {
		[self setRelationshipObjectOn:representation usingMapping:relationshipMapping fromObject:object];
	}

	return representation;
}

+ (NSDictionary *)serializeObject:(id)object usingMapping:(EMKMapping *)mapping {
	NSDictionary *representation = [self _serializeObject:object usingMapping:mapping];

	return mapping.rootPath.length > 0 ? @{mapping.rootPath : representation} : representation;
}

+ (id)_serializeCollection:(NSArray *)collection usingMapping:(EMKMapping *)mapping {
	NSMutableArray *representation = [NSMutableArray new];

	for (id object in collection) {
		NSDictionary *objectRepresentation = [self _serializeObject:object usingMapping:mapping];
		[representation addObject:objectRepresentation];
	}

	return representation;
}

+ (id)serializeCollection:(NSArray *)collection usingMapping:(EMKMapping *)mapping {
	NSArray *representation = [self _serializeCollection:collection usingMapping:mapping];

	return mapping.rootPath.length > 0 ? @{mapping.rootPath: representation} : representation;
}

+ (void)setValueOnRepresentation:(NSMutableDictionary *)representation fromObject:(id)object withFieldMapping:(EMKAttributeMapping *)fieldMapping {
	id returnedValue = [object valueForKey:fieldMapping.property];

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
	id value = [object valueForKey:relationshipMapping.property];
	if (value) {
		id relationshipRepresentation = nil;
		if (relationshipMapping.isToMany) {
			relationshipRepresentation = [self _serializeCollection:value usingMapping:relationshipMapping.objectMapping];
		} else {
			relationshipRepresentation = [self _serializeObject:value usingMapping:relationshipMapping.objectMapping];
		}

		if (relationshipMapping.keyPath.length > 0) {
			[representation setObject:relationshipRepresentation forKey:relationshipMapping.keyPath];
		} else {
			NSParameterAssert([relationshipRepresentation isKindOfClass:NSDictionary.class]);
			[representation addEntriesFromDictionary:relationshipRepresentation];
		}
	}
}

@end