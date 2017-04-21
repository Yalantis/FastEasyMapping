// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMObjectStore.h"
#import "FEMMapping.h"

@implementation FEMObjectStore

- (BOOL)requiresPrefetch {
    return NO;
}

//- (void)prepareTransactionForMapping:(nonnull FEMMapping *)mapping ofRepresentation:(nonnull NSArray *)representation {}

- (void)beginTransaction:(nullable NSMapTable<FEMMapping *, NSSet<id> *> *)presentedPrimaryKeys {}

- (NSError *)commitTransaction {
    return nil;
}

- (id)newObjectForMapping:(FEMMapping *)mapping {
    id object = [[mapping.objectClass alloc] init];
    return object;
}

- (FEMRelationshipAssignmentContext *)newAssignmentContext {
    FEMRelationshipAssignmentContext *context = [[FEMRelationshipAssignmentContext alloc] initWithStore:self];
    return context;
}

- (void)registerObject:(id)object forMapping:(FEMMapping *)mapping {
    // no-op
}

- (BOOL)canRegisterObject:(id)object forMapping:(FEMMapping *)mapping {
    return mapping.primaryKeyAttribute != nil;
}

- (NSDictionary *)registeredObjectsForMapping:(FEMMapping *)mapping {
    return nil;
}

- (id)registeredObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping {
    return nil;
}

#pragma mark - FEMRelationshipAssignmentContextDelegate

- (void)assignmentContext:(FEMRelationshipAssignmentContext *)context deletedObject:(id)object {
    // no-op
}

@end