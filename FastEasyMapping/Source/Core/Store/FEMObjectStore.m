//
// Created by zen on 12/05/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "FEMObjectStore.h"
#import "FEMMapping.h"
#import "FEMAssignmentContextPrivate.h"
#import "FEMRelationshipAssignmentContext.h"

@implementation FEMObjectStore

- (NSArray *)performMappingTransaction:(NSArray *)representation mapping:(FEMMapping *)mapping transaction:(void (^)(void))transaction {
    return nil;
}

- (id)newObjectForMapping:(FEMMapping *)mapping {
    return [[mapping.objectClass alloc] init];
}

- (id<FEMAssignmentContextPrivate>)newAssignmentContext {
    return
}

- (BOOL)registerObject:(id)object forMapping:(FEMMapping *)mapping {

}

- (BOOL)canRegisterObject:(id)object forMapping:(FEMMapping *)mapping {

}

- (BOOL)deleteRegisteredObject:(id)object forMapping:(FEMMapping *)mapping {

}

- (NSDictionary *)registeredObjectsForMapping:(FEMMapping *)mapping {

}

- (id)registeredObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping {

}

@end