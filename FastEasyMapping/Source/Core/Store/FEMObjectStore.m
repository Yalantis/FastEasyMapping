//
// Created by zen on 12/05/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "FEMObjectStore.h"
#import "FEMMapping.h"

@implementation FEMObjectStore

- (NSError *)performMappingTransaction:(NSArray *)representation mapping:(FEMMapping *)mapping transaction:(void (^)(void))transaction {
    transaction();
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