// Copyright (c) 2014 Lucas Medeiros.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "FEMCache.h"
#import "FEMManagedObjectMapping.h"
#import "FEMRelationshipMapping.h"
#import "FEMAttributeMapping.h"
#import "FEMAttributeMapping+Extension.h"

#import <CoreData/CoreData.h>

@class FEMCache;

NSString *const EMKLookupCacheCurrentKey = @"com.yalantis.FastEasyMapping.cache";

FEMCache *FEMCacheGetCurrent() {
	return [[[NSThread currentThread] threadDictionary] objectForKey:EMKLookupCacheCurrentKey];
}

void FEMCacheSetCurrent(FEMCache *cache) {
	NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
	NSCParameterAssert(cache);
	NSCParameterAssert(![threadDictionary objectForKey:EMKLookupCacheCurrentKey]);

	[threadDictionary setObject:cache forKey:EMKLookupCacheCurrentKey];
}

void FEMCacheRemoveCurrent() {
	NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
	NSCParameterAssert([threadDictionary objectForKey:EMKLookupCacheCurrentKey]);
	[threadDictionary removeObjectForKey:EMKLookupCacheCurrentKey];
}

@implementation FEMCache {
	NSManagedObjectContext *_context;

	NSMutableDictionary *_lookupKeysMap;
	NSMutableDictionary *_lookupObjectsMap;
}

#pragma mark - Init


- (instancetype)initWithMapping:(FEMManagedObjectMapping *)mapping
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

		[self prepareMappingLookupStructure:mapping];
		[self inspectExternalRepresentation:externalRepresentation usingMapping:mapping];
	}

	return self;
}

#pragma mark - Inspection

- (void)inspectObjectRepresentation:(id)objectRepresentation usingMapping:(FEMManagedObjectMapping *)mapping {
	if (mapping.primaryKey) {
		FEMAttributeMapping *primaryKeyMapping = mapping.primaryKeyMapping;
		NSParameterAssert(primaryKeyMapping);

		id primaryKeyValue = [primaryKeyMapping mappedValueFromRepresentation:objectRepresentation];
		if (primaryKeyValue) {
			[_lookupKeysMap[mapping.entityName] addObject:primaryKeyValue];
		}
	}

	for (FEMRelationshipMapping *relationshipMapping in mapping.relationshipMappings) {
		id relationshipRepresentation = [relationshipMapping extractRootFromExternalRepresentation:objectRepresentation];
        if (relationshipRepresentation) {
            [self inspectRepresentation:relationshipRepresentation
                           usingMapping:(FEMManagedObjectMapping *)relationshipMapping.objectMapping];
        }
	}
}

- (void)inspectRepresentation:(id)representation usingMapping:(FEMManagedObjectMapping *)mapping {
	if ([representation isKindOfClass:NSArray.class]) {
		for (id objectRepresentation in representation) {
			[self inspectObjectRepresentation:objectRepresentation usingMapping:mapping];
		}
	} else if ([representation isKindOfClass:NSDictionary.class]) {
		[self inspectObjectRepresentation:representation usingMapping:mapping];
	} else {
		NSAssert(
			NO,
			@"Expected container classes: NSArray, NSDictionary. Got:%@",
			NSStringFromClass([representation class])
		);
	}
}

- (void)inspectExternalRepresentation:(id)externalRepresentation usingMapping:(FEMManagedObjectMapping *)mapping {
	id representation = [mapping extractRootFromExternalRepresentation:externalRepresentation];

	[self inspectRepresentation:representation usingMapping:mapping];
}

- (void)collectEntityNames:(NSMutableSet *)namesCollection usingMapping:(FEMManagedObjectMapping *)mapping {
	[namesCollection addObject:mapping.entityName];

	for (FEMRelationshipMapping *relationshipMapping in mapping.relationshipMappings) {
		[self collectEntityNames:namesCollection usingMapping:(FEMManagedObjectMapping *)relationshipMapping.objectMapping];
	}
}

- (void)prepareMappingLookupStructure:(FEMManagedObjectMapping *)mapping {
	NSMutableSet *entityNames = [NSMutableSet new];
	[self collectEntityNames:entityNames usingMapping:mapping];

	for (NSString *entityName in entityNames) {
		_lookupKeysMap[entityName] = [NSMutableSet new];
	}
}

- (NSMutableDictionary *)fetchExistingObjectsForMapping:(FEMManagedObjectMapping *)mapping {
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

- (NSMutableDictionary *)cachedObjectsForMapping:(FEMManagedObjectMapping *)mapping {
	NSMutableDictionary *entityObjectsMap = _lookupObjectsMap[mapping.entityName];
	if (!entityObjectsMap) {
		entityObjectsMap = [self fetchExistingObjectsForMapping:mapping];
		_lookupObjectsMap[mapping.entityName] = entityObjectsMap;
	}

	return entityObjectsMap;
}

- (id)existingObjectForRepresentation:(id)representation mapping:(FEMManagedObjectMapping *)mapping {
	NSDictionary *entityObjectsMap = [self cachedObjectsForMapping:mapping];

	id primaryKeyValue = [mapping.primaryKeyMapping mappedValueFromRepresentation:representation];
	if (primaryKeyValue == nil || primaryKeyValue == NSNull.null) return nil;

	return entityObjectsMap[primaryKeyValue];
}

- (void)addExistingObject:(id)object usingMapping:(FEMManagedObjectMapping *)mapping {
	NSParameterAssert(mapping.primaryKey);
	NSParameterAssert(object);

	id primaryKeyValue = [object valueForKey:mapping.primaryKey];
	NSAssert(primaryKeyValue, @"No value for key (%@) on object (%@) found", mapping.primaryKey, object);

	NSMutableDictionary *entityObjectsMap = [self cachedObjectsForMapping:mapping];
	[entityObjectsMap setObject:object forKey:primaryKeyValue];
}

@end