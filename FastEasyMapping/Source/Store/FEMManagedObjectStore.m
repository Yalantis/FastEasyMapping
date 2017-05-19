// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMManagedObjectStore.h"

#import <CoreData/CoreData.h>

#import "FEMMapping.h"
#import "FEMObjectCache.h"
#import "FEMRepresentationUtility.h"

__attribute__((always_inline)) void validateMapping(FEMMapping *mapping) {
    NSCAssert(mapping.entityName != nil, @"Entity name can't be nil. Please, use -[FEMMapping initWithEntityName:]");
}

@implementation FEMManagedObjectStore {
    FEMObjectCache *_cache;
}

#pragma mark - Init

- (instancetype)initWithContext:(NSManagedObjectContext *)context {
    NSParameterAssert(context != nil);
    self = [super init];
    if (self) {
        _context = context;
    }

    return self;
}

#pragma mark - Transaction

- (void)beginTransaction:(nullable NSDictionary<NSNumber *, NSSet<id> *> *)presentedPrimaryKeys {
    _cache = [[FEMObjectCache alloc] initWithContext:self.context presentedPrimaryKeys:presentedPrimaryKeys];
}

- (NSError *)commitTransaction {
    _cache = nil;

    NSError *error = nil;
    if (self.saveContextOnCommit && self.context.hasChanges && ![self.context save:&error]) {
        return error;
    }

    return nil;
}

+ (BOOL)requiresPrefetch {
    return YES;
}

- (id)newObjectForMapping:(FEMMapping *)mapping {
    validateMapping(mapping);

    NSString *entityName = [mapping entityName];
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.context];
}

- (id)objectForPrimaryKey:(id)primaryKey mapping:(FEMMapping *)mapping {
    validateMapping(mapping);
    return [_cache objectForKey:primaryKey mapping:mapping];
}

- (void)addObject:(id)object forPrimaryKey:(nullable id)primaryKey mapping:(FEMMapping *)mapping {
    validateMapping(mapping);

    if (primaryKey != nil && [object isInserted]) {
        [_cache setObject:object forKey:primaryKey mapping:mapping];
    }
}

- (NSDictionary *)objectsForMapping:(FEMMapping *)mapping {
    validateMapping(mapping);

    return [_cache objectsForMapping:mapping];
}

#pragma mark - FEMRelationshipAssignmentContextDelegate

- (void)assignmentContext:(FEMRelationshipAssignmentContext *)context deletedObject:(id)object {
    NSAssert([object isKindOfClass:NSManagedObject.class], @"Wrong class");
    [self.context deleteObject:object];
}

@end
