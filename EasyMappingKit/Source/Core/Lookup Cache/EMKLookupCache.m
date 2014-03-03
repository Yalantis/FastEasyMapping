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
	id _representation;

	NSManagedObjectContext *_context;

	NSMutableDictionary *_lookupKeysMap;
	NSMutableDictionary *_lookupObjectsMap;
}

#pragma mark - Init


- (instancetype)initWithMapping:(EMKManagedObjectMapping *)mapping
                 representation:(id)representation
			            context:(NSManagedObjectContext *)context {
	NSParameterAssert(mapping);
	NSParameterAssert(representation);
	NSParameterAssert(context);

	self = [self init];
	if (self) {
		_mapping = mapping;
		_context = context;
		
		_lookupKeysMap = [NSMutableDictionary new];
		_lookupObjectsMap = [NSMutableDictionary new];
		[self fillUsingRepresentation:representation];
	}

	return self;
}

#pragma mark - Inspection

- (void)inspectObjectRepresentation:(id)objectRepresentation usingMapping:(EMKManagedObjectMapping *)mapping {
	id representation = mapping.rootPath ? [objectRepresentation valueForKeyPath:objectRepresentation] : objectRepresentation;

	EMKAttributeMapping *primaryKeyMapping = mapping.primaryKeyMapping;
	NSParameterAssert(primaryKeyMapping);

	id primaryKeyValue = [primaryKeyMapping mapValue:objectRepresentation];
	[_lookupKeysMap[mapping.entityName] addObject:primaryKeyValue];

	for (EMKRelationshipMapping *relationshipMapping in mapping.relationshipMappings) {
		id relationshipRepresentation = relationshipMapping.keyPath ? [objectRepresentation valueForKeyPath:relationshipMapping.keyPath] : objectRepresentation;
		[self inspectExternalRepresentation:relationshipRepresentation usingMapping:relationshipMapping.objectMapping];
	}
}

- (void)inspectExternalRepresentation:(id)externalRepresentation usingMapping:(EMKManagedObjectMapping *)mapping {
	id representation = mapping.rootPath ? [externalRepresentation valueForKeyPath:mapping.rootPath] : externalRepresentation;

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

- (void)prepareLookupMapsStructure {
	NSMutableSet *entityNames = [NSMutableSet new];
	[self collectEntityNames:entityNames usingMapping:self.mapping];

	for (NSString *entityName in entityNames) {
		_lookupKeysMap[entityName] = [NSMutableSet new];
	}
}

- (void)fillUsingRepresentation:(id)representation {
	// ie. drop previous results
	_representation = representation;

	[_lookupKeysMap removeAllObjects];
	[_lookupObjectsMap removeAllObjects];

	[self prepareLookupMapsStructure];
	[self inspectExternalRepresentation:_representation usingMapping:self.mapping];
}

- (NSDictionary *)existingObjectsMapOfClass:(Class)class {
	NSSet *lookupValues = _lookupKeysMap[class];
	if (lookupValues.count == 0) return @{};

	NSAttributeDescription *primaryKeyAttribute = [[class entityDescription] MR_primaryAttributeToRelateBy];
	NSParameterAssert(primaryKeyAttribute);
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@", primaryKeyAttribute.name, lookupValues];

	NSMutableDictionary *output = [NSMutableDictionary new];
	NSArray *existingObjects = [class MR_findAllWithPredicate:predicate inContext:_context];
	for (NSManagedObject *existingObject in existingObjects) {
		output[[existingObject valueForKey:primaryKeyAttribute.name]] = existingObject;
	}

	return output;
}

- (id)cachedObjectOfClass:(Class)class withPrimaryKeyValue:(id)value {
	NSDictionary *cachedObjects = _lookupObjectsMap[(id<NSCopying>)class];
	if (!cachedObjects) {
		cachedObjects = [self existingObjectsMapOfClass:class];
		_lookupObjectsMap[(id<NSCopying>)class] = cachedObjects;
	}

	return cachedObjects[value];
}


- (id)existingObjectForRepresentation:(id)representation mapping:(EMKManagedObjectMapping *)mapping {
	NSDictionary *entityObjectsMap = _lookupObjectsMap[mapping.entityName];
	if (!entityObjectsMap) {

	}


	return entityObjectsMap
}

- (void)addExistingObject:(id)object usingMapping:(EMKManagedObjectMapping *)mapping {

}


#pragma mark - Preparation

- (void)addPrimaryKeyValue:(id)value forObjectOfClass:(Class)class {
	NSMutableSet *primaryKeys = [_lookupKeysMap objectForKey:class];
	if (!primaryKeys) {
		primaryKeys = [NSMutableSet new];
		[_lookupKeysMap setObject:primaryKeys forKey:(id<NSCopying>) class];
	}

	[primaryKeys addObject:value];
}



@end