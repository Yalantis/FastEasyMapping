// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMObjectCache.h"

#import <CoreData/CoreData.h>

#import "FEMMapping.h"
#import "FEMRepresentationUtility.h"

@implementation FEMObjectCache {
	NSMutableDictionary *_lookupObjectsMap;
	FEMObjectCacheSource _source;
}

#pragma mark - Init

- (instancetype)initWithSource:(FEMObjectCacheSource)source {
	NSParameterAssert(source != NULL);
	self = [super init];
	if (self) {
		_source = [source copy];
		_lookupObjectsMap = [NSMutableDictionary new];
	}

	return self;
}

#pragma mark - Inspection

- (NSMutableDictionary *)fetchExistingObjectsForMapping:(FEMMapping *)mapping {
	NSMutableDictionary *output = [NSMutableDictionary new];
	id<NSFastEnumeration> objects = _source(mapping);
	for (NSObject *object in objects) {
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

- (id)objectForKey:(id)key mapping:(FEMMapping *)mapping {
	NSDictionary *entityObjectsMap = [self cachedObjectsForMapping:mapping];
	return entityObjectsMap[key];
}

- (void)setObject:(id)object forKey:(id)key mapping:(FEMMapping *)mapping {
	NSParameterAssert(mapping.primaryKey);
	NSParameterAssert(object);

	NSMutableDictionary *entityObjectsMap = [self cachedObjectsForMapping:mapping];
    entityObjectsMap[key] = object;
}

- (NSDictionary *)objectsForMapping:(FEMMapping *)mapping {
    return [[self cachedObjectsForMapping:mapping] copy];
}

@end

@implementation FEMObjectCache (CoreData)

- (instancetype)initWithContext:(NSManagedObjectContext *)context
           presentedPrimaryKeys:(nullable NSMapTable<FEMMapping *, NSSet<id> *> *)presentedPrimaryKeys
{
    return [self initWithSource:^id <NSFastEnumeration>(FEMMapping *mapping) {
        NSSet *primaryKeys = [presentedPrimaryKeys objectForKey:mapping];
        if (primaryKeys.count > 0) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:mapping.entityName];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@", mapping.primaryKey, primaryKeys];
            [fetchRequest setPredicate:predicate];
            [fetchRequest setFetchLimit:primaryKeys.count];

            NSArray *existingObjects = [context executeFetchRequest:fetchRequest error:NULL];
            return existingObjects;
        }

        return @[];
    }];
}

@end
