// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMObjectStore.h"
#import "FEMMapping.h"

@implementation FEMObjectStore

- (void)beginTransaction:(nullable NSDictionary<NSNumber *, NSSet<id> *> *)presentedPrimaryKeys {
    // no-op
}

- (NSError *)commitTransaction {
    return nil;
}

+ (BOOL)requiresPrefetch {
    return NO;
}

- (id)newObjectForMapping:(FEMMapping *)mapping {
    id object = [[mapping.objectClass alloc] init];
    return object;
}

- (FEMRelationshipAssignmentContext *)newAssignmentContext {
    FEMRelationshipAssignmentContext *context = [[FEMRelationshipAssignmentContext alloc] initWithStore:self];
    return context;
}

- (void)addObject:(id)object forPrimaryKey:(nullable id)primaryKey mapping:(FEMMapping *)mapping {
    // no-op
}

- (NSDictionary *)objectsForMapping:(FEMMapping *)mapping {
    return @{};
}

- (id)objectForPrimaryKey:(id)primaryKey mapping:(FEMMapping *)mapping {
    return nil;
}

#pragma mark - FEMRelationshipAssignmentContextDelegate

- (void)assignmentContext:(FEMRelationshipAssignmentContext *)context deletedObject:(id)object {
    // no-op
}

@end
