//
// Created by zen on 12/05/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

@import Foundation;

#import "FEMRelationshipAssignmentContext.h"

@class FEMMapping;

@interface FEMObjectStore : NSObject <FEMRelationshipAssignmentContextDelegate>

- (NSArray *)performMappingTransaction:(NSArray *)representation mapping:(FEMMapping *)mapping transaction:(void (^)(void))transaction;

- (id)newObjectForMapping:(FEMMapping *)mapping;
- (FEMRelationshipAssignmentContext *)newAssignmentContext;

- (BOOL)registerObject:(id)object forMapping:(FEMMapping *)mapping;
- (BOOL)canRegisterObject:(id)object forMapping:(FEMMapping *)mapping;
- (BOOL)deleteRegisteredObject:(id)object forMapping:(FEMMapping *)mapping;

- (NSDictionary *)registeredObjectsForMapping:(FEMMapping *)mapping;
- (id)registeredObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping;

@end