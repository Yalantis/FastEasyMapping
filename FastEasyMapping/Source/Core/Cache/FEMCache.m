// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMCache.h"
#import "FEMManagedObjectMapping.h"
#import "FEMRelationship.h"
#import "FEMAttribute.h"
#import "FEMAttribute+Extension.h"

#import <CoreData/CoreData.h>

@class FEMCache;

NSString *const EMKLookupCacheCurrentKey = @"com.yalantis.FastEasyMapping.cache";

FEMCache *FEMCacheGetCurrent() {
	return [[NSThread currentThread] threadDictionary][EMKLookupCacheCurrentKey];
}

void FEMCacheSetCurrent(FEMCache *cache) {
	NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
	NSCParameterAssert(cache);
	NSCParameterAssert(!threadDictionary[EMKLookupCacheCurrentKey]);

    threadDictionary[EMKLookupCacheCurrentKey] = cache;
}

void FEMCacheRemoveCurrent() {
	NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
	NSCParameterAssert(threadDictionary[EMKLookupCacheCurrentKey]);
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
		FEMAttribute *primaryKeyMapping = mapping.primaryKeyAttribute;
		NSParameterAssert(primaryKeyMapping);

		id primaryKeyValue = [primaryKeyMapping mappedValueFromRepresentation:objectRepresentation];
		if (primaryKeyValue && primaryKeyValue != NSNull.null) {
			[_lookupKeysMap[mapping.entityName] addObject:primaryKeyValue];
		}
	}

	for (FEMRelationship *relationshipMapping in mapping.relationships) {
		id relationshipRepresentation = [relationshipMapping extractRootFromExternalRepresentation:objectRepresentation];
        if (relationshipRepresentation && relationshipRepresentation != NSNull.null) {
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

	for (FEMRelationship *relationshipMapping in mapping.relationships) {
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

	id primaryKeyValue = [mapping.primaryKeyAttribute mappedValueFromRepresentation:representation];
	if (primaryKeyValue == nil || primaryKeyValue == NSNull.null) return nil;

	return entityObjectsMap[primaryKeyValue];
}

- (void)addExistingObject:(id)object usingMapping:(FEMManagedObjectMapping *)mapping {
	NSParameterAssert(mapping.primaryKey);
	NSParameterAssert(object);

	id primaryKeyValue = [object valueForKey:mapping.primaryKey];
	NSAssert(primaryKeyValue, @"No value for key (%@) on object (%@) found", mapping.primaryKey, object);

	NSMutableDictionary *entityObjectsMap = [self cachedObjectsForMapping:mapping];
    entityObjectsMap[primaryKeyValue] = object;
}

- (NSDictionary *)existingObjectsForMapping:(FEMManagedObjectMapping *)mapping {
    return [[self cachedObjectsForMapping:mapping] copy];
}

@end