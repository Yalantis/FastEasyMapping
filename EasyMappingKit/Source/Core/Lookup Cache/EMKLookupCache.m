//
// EMKLookupCache.m 
// EasyMappingKit
//
// Created by dmitriy on 3/3/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import "EMKLookupCache.h"
#import "EMKManagedObjectMapping.h"
#import "EMKRelationshipMapping.h"
#import "EMKAttributeMapping.h"
#import "EMKAttributeMapping+Extension.h"

#import <CoreData/CoreData.h>

@class EMKLookupCache;

NSString *const EMKLookupCacheCurrentKey = @"com.yalantis.EasyMappingKit.lookup-cache";

EMKLookupCache *EMKLookupCacheGetCurrent() {
	return [[[NSThread currentThread] threadDictionary] objectForKey:EMKLookupCacheCurrentKey];
}

void EMKLookupCacheSetCurrent(EMKLookupCache *cache) {
	NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
	NSCParameterAssert(cache);
	NSCParameterAssert(![threadDictionary objectForKey:EMKLookupCacheCurrentKey]);

	[threadDictionary setObject:cache forKey:EMKLookupCacheCurrentKey];
}

void EMKLookupCacheRemoveCurrent() {
	NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
	NSCParameterAssert([threadDictionary objectForKey:EMKLookupCacheCurrentKey]);
	[threadDictionary removeObjectForKey:EMKLookupCacheCurrentKey];
}

@implementation EMKLookupCache {
	NSManagedObjectContext *_context;

	NSMutableDictionary *_lookupKeysMap;
	NSMutableDictionary *_lookupObjectsMap;
}

#pragma mark - Init


- (instancetype)initWithMapping:(EMKManagedObjectMapping *)mapping
         externalRepresentation:(id)externalRepresentation
					    context:(NSManagedObjectContext *)context {
	NSParameterAssert(mapping);
	NSParameterAssert(externalRepresentation);
	NSParameterAssert(context);

	self = [self init];
	if (self) {
		_context = context;

		_lookupKeysMap = [NSMutableDictionary new];
		_lookupObjectsMap = [NSMutableDictionary new];

		[self prepareMappingLookupStructure:nil ];
		[self inspectExternalRepresentation:externalRepresentation usingMapping:mapping];
	}

	return self;
}

#pragma mark - Inspection

- (void)inspectObjectRepresentation:(id)objectRepresentation usingMapping:(EMKManagedObjectMapping *)mapping {
	if (mapping.primaryKey) {
		EMKAttributeMapping *primaryKeyMapping = mapping.primaryKeyMapping;
		NSParameterAssert(primaryKeyMapping);

		id primaryKeyValue = [primaryKeyMapping mappedValueFromRepresentation:objectRepresentation];
		if (primaryKeyValue) {
			[_lookupKeysMap[mapping.entityName] addObject:primaryKeyValue];
		}
	}

	for (EMKRelationshipMapping *relationshipMapping in mapping.relationshipMappings) {
		[self inspectExternalRepresentation:objectRepresentation usingMapping:relationshipMapping.objectMapping];
	}
}

- (void)inspectExternalRepresentation:(id)externalRepresentation usingMapping:(EMKManagedObjectMapping *)mapping {
	id representation = [mapping mappedExternalRepresentation:externalRepresentation];

	if ([representation isKindOfClass:NSArray.class]) {
		for (id objectRepresentation in representation) {
			[self inspectObjectRepresentation:objectRepresentation usingMapping:mapping];
		}
	} else if ([representation isKindOfClass:NSDictionary.class]) {
		[self inspectObjectRepresentation:representation usingMapping:mapping];
	} else {
		assert(false);
	}
}

- (void)collectEntityNames:(NSMutableSet *)namesCollection usingMapping:(EMKManagedObjectMapping *)mapping {
	[namesCollection addObject:mapping.entityName];

	for (EMKRelationshipMapping *relationshipMapping in mapping.relationshipMappings) {
		[self collectEntityNames:namesCollection usingMapping:(EMKManagedObjectMapping *)relationshipMapping.objectMapping];
	}
}

- (void)prepareMappingLookupStructure:(EMKManagedObjectMapping *)mapping {
	NSMutableSet *entityNames = [NSMutableSet new];
	[self collectEntityNames:entityNames usingMapping:mapping];

	for (NSString *entityName in entityNames) {
		_lookupKeysMap[entityName] = [NSMutableSet new];
	}
}

- (NSMutableDictionary *)fetchExistingObjectsForMapping:(EMKManagedObjectMapping *)mapping {
	NSSet *lookupValues = _lookupKeysMap[mapping.entityName];
	if (lookupValues.count == 0) return [NSMutableDictionary dictionary];

	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:mapping.entityName];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@", mapping.primaryKey, lookupValues];
	[fetchRequest setPredicate:predicate];
	[fetchRequest setFetchLimit:lookupValues.count];

	NSMutableDictionary *output = [NSMutableDictionary new];
	NSArray *existingObjects = [_context executeFetchRequest:fetchRequest error:NULL];
	for (NSManagedObject *object in existingObjects) {
		output[[object valueForKey:mapping.primaryKey]] = object;
	}

	return output;
}

- (NSMutableDictionary *)cachedObjectsForMapping:(EMKManagedObjectMapping *)mapping {
	NSMutableDictionary *entityObjectsMap = _lookupObjectsMap[mapping.entityName];
	if (!entityObjectsMap) {
		entityObjectsMap = [self fetchExistingObjectsForMapping:mapping];
		_lookupObjectsMap[mapping.entityName] = entityObjectsMap;
	}

	return entityObjectsMap;
}

- (id)existingObjectForRepresentation:(id)representation mapping:(EMKManagedObjectMapping *)mapping {
	NSDictionary *entityObjectsMap = [self cachedObjectsForMapping:mapping];

	id primaryKeyValue = [mapping.primaryKeyMapping mappedValueFromRepresentation:representation];
	if (primaryKeyValue == nil || primaryKeyValue == NSNull.null) return nil;

	return entityObjectsMap[primaryKeyValue];
}

- (void)addExistingObject:(id)object usingMapping:(EMKManagedObjectMapping *)mapping {
	NSParameterAssert(mapping.primaryKey);
	NSParameterAssert(object);

	id primaryKeyValue = [object valueForKey:mapping.primaryKey];
	NSAssert(primaryKeyValue, @"No value for key (%@) on object (%@) found", mapping.primaryKey, object);

	NSMutableDictionary *entityObjectsMap = [self cachedObjectsForMapping:mapping];
	[entityObjectsMap setObject:object forKey:primaryKeyValue];
}

@end