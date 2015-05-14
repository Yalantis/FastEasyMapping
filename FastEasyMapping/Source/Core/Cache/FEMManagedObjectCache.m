// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMManagedObjectCache.h"

#import <CoreData/CoreData.h>

#import "FEMMapping.h"
#import "FEMAttribute+Extension.h"
#import "FEMRepresentationUtility.h"
#import "FEMRelationship.h"
#import "FEMMappingUtility.h"
#import "KWExample.h"

@implementation FEMManagedObjectCache {
	NSManagedObjectContext *_context;

	NSMutableDictionary *_lookupKeysMap;
	NSMutableDictionary *_lookupObjectsMap;
}

#pragma mark - Init


- (instancetype)initWithMapping:(FEMMapping *)mapping representation:(id)representation context:(NSManagedObjectContext *)context {
	NSParameterAssert(mapping);
    NSParameterAssert(representation);
	NSParameterAssert(context);

	self = [self init];
	if (self) {
		_context = context;

		_lookupKeysMap = [NSMutableDictionary new];
		_lookupObjectsMap = [NSMutableDictionary new];

        for (NSString *name in FEMMappingCollectUsedEntityNames(mapping)) {
            _lookupKeysMap[name] = [[NSMutableSet alloc] init];
        }

        [self inspectExternalRepresentation:representation mapping:mapping];
	}

	return self;
}

#pragma mark - Inspection

- (void)inspectObjectRepresentation:(id)objectRepresentation mapping:(FEMMapping *)mapping {
	if (mapping.primaryKey) {
		FEMAttribute *primaryKeyMapping = mapping.primaryKeyAttribute;
		NSParameterAssert(primaryKeyMapping);

		id primaryKeyValue = [primaryKeyMapping mappedValueFromRepresentation:objectRepresentation];
		if (primaryKeyValue && primaryKeyValue != NSNull.null) {
			[_lookupKeysMap[mapping.entityName] addObject:primaryKeyValue];
		}
	}

	for (FEMRelationship *relationshipMapping in mapping.relationships) {
		id relationshipRepresentation = FEMRepresentationRootForKeyPath(objectRepresentation, relationshipMapping.keyPath);
        if (relationshipRepresentation && relationshipRepresentation != NSNull.null) {
            [self inspectRepresentation:relationshipRepresentation mapping:relationshipMapping.objectMapping];
        }
	}
}

- (void)inspectRepresentation:(id)representation mapping:(FEMMapping *)mapping {
	if ([representation isKindOfClass:NSArray.class]) {
		for (id objectRepresentation in representation) {
            [self inspectObjectRepresentation:objectRepresentation mapping:mapping];
		}
	} else if ([representation isKindOfClass:NSDictionary.class]) {
        [self inspectObjectRepresentation:representation mapping:mapping];
	} else {
		NSAssert(
			NO,
			@"Expected container classes: NSArray, NSDictionary. Got:%@",
			NSStringFromClass([representation class])
		);
	}
}

- (void)inspectExternalRepresentation:(id)externalRepresentation mapping:(FEMMapping *)mapping {
    id representation = FEMRepresentationRootForKeyPath(externalRepresentation, mapping.rootPath);
    [self inspectRepresentation:representation mapping:mapping];
}

- (void)collectEntityNames:(NSMutableSet *)namesCollection mapping:(FEMMapping *)mapping {
	[namesCollection addObject:mapping.entityName];

	for (FEMRelationship *relationshipMapping in mapping.relationships) {
        [self collectEntityNames:namesCollection mapping:relationshipMapping.objectMapping];
	}
}

- (NSMutableDictionary *)fetchExistingObjectsForMapping:(FEMMapping *)mapping {
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

- (NSMutableDictionary *)cachedObjectsForMapping:(FEMMapping *)mapping {
	NSMutableDictionary *entityObjectsMap = _lookupObjectsMap[mapping.entityName];
	if (!entityObjectsMap) {
		entityObjectsMap = [self fetchExistingObjectsForMapping:mapping];
		_lookupObjectsMap[mapping.entityName] = entityObjectsMap;
	}

	return entityObjectsMap;
}

- (id)existingObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping {
	NSDictionary *entityObjectsMap = [self cachedObjectsForMapping:mapping];

	id primaryKeyValue = [mapping.primaryKeyAttribute mappedValueFromRepresentation:representation];
	if (primaryKeyValue == nil || primaryKeyValue == NSNull.null) return nil;

	return entityObjectsMap[primaryKeyValue];
}

- (id)existingObjectForPrimaryKey:(id)primaryKey mapping:(FEMMapping *)mapping {
    NSDictionary *entityObjectsMap = [self cachedObjectsForMapping:mapping];

    return entityObjectsMap[primaryKey];
}

- (void)addExistingObject:(id)object mapping:(FEMMapping *)mapping {
	NSParameterAssert(mapping.primaryKey);
	NSParameterAssert(object);

	id primaryKeyValue = [object valueForKey:mapping.primaryKey];
	NSAssert(primaryKeyValue, @"No value for key (%@) on object (%@) found", mapping.primaryKey, object);

	NSMutableDictionary *entityObjectsMap = [self cachedObjectsForMapping:mapping];
    entityObjectsMap[primaryKeyValue] = object;
}

- (NSDictionary *)existingObjectsForMapping:(FEMMapping *)mapping {
    return [[self cachedObjectsForMapping:mapping] copy];
}

@end