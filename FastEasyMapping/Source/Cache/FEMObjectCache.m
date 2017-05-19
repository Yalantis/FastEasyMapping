// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMObjectCache.h"

#import <CoreData/CoreData.h>

#import "FEMMapping.h"
#import "FEMRepresentationUtility.h"

FEMObjectCacheSource FEMObjectCacheSourceStub = ^id<NSFastEnumeration> (FEMMapping *mapping) {
    return @[];
};

@implementation FEMObjectCache {
	NSMutableDictionary<NSNumber *, NSMutableDictionary<id, id> *> *_lookupObjectsMap;
	FEMObjectCacheSource _source;
}

#pragma mark - Init

- (instancetype)initWithSource:(FEMObjectCacheSource)source {
	self = [super init];
	if (self) {
        _source = source ?: FEMObjectCacheSourceStub;
        _lookupObjectsMap = [[NSMutableDictionary alloc] init];
    }

	return self;
}

- (instancetype)init {
    return [self initWithSource:nil];
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
    NSMutableDictionary *entityObjectsMap = _lookupObjectsMap[mapping.uniqueIdentifier];
	if (!entityObjectsMap) {
		entityObjectsMap = [self fetchExistingObjectsForMapping:mapping];
        _lookupObjectsMap[mapping.uniqueIdentifier] = entityObjectsMap;
	}

	return entityObjectsMap;
}

- (id)objectForKey:(id)key mapping:(FEMMapping *)mapping {
    NSParameterAssert(mapping.primaryKey != nil);

    NSDictionary *entityObjectsMap = [self cachedObjectsForMapping:mapping];
	return entityObjectsMap[key];
}

- (void)setObject:(id)object forKey:(id)key mapping:(FEMMapping *)mapping {
	NSParameterAssert(mapping.primaryKey != nil);
	NSParameterAssert(object != nil);
    NSParameterAssert(key != nil);

	NSMutableDictionary *entityObjectsMap = [self cachedObjectsForMapping:mapping];
    entityObjectsMap[key] = object;
}

- (NSDictionary *)objectsForMapping:(FEMMapping *)mapping {
    return [[self cachedObjectsForMapping:mapping] copy];
}

@end

@implementation FEMObjectCache (CoreData)

- (instancetype)initWithContext:(NSManagedObjectContext *)context
           presentedPrimaryKeys:(nullable NSDictionary<NSNumber *, NSSet<id> *> *)presentedPrimaryKeys
{
    return [self initWithSource:^id<NSFastEnumeration> (FEMMapping *mapping) {
        NSSet *primaryKeys = presentedPrimaryKeys[mapping.uniqueIdentifier];
        if (primaryKeys.count > 0) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:mapping.entityName];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@", mapping.primaryKey, primaryKeys];
            [fetchRequest setPredicate:predicate];
            [fetchRequest setFetchLimit:primaryKeys.count];

            NSError *error = nil;
            NSArray *existingObjects = [context executeFetchRequest:fetchRequest error:&error];

            // TODO: Errors handling needed. This is a temprorary solution to at least indicate critical situation
            // rather than pollute database with duplicates
            if (error != nil) {
                @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[error debugDescription] userInfo:nil];
            }
            
            return existingObjects;
        }

        return @[];
    }];
}

@end
