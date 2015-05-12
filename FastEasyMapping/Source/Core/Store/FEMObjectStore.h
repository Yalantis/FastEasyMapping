//
// Created by zen on 12/05/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

@import Foundation.h;

@class FEMMapping;

@protocol FEMAssignmentContextPrivate;

@interface FEMObjectStore : NSObject

- (id)newObjectForMapping:(FEMMapping *)mapping;

- (id)registeredObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping;
- (void)registerObject:(id)object forMapping:(FEMMapping *)mapping;
- (NSDictionary *)registeredObjectsForMapping:(FEMMapping *)mapping;

- (BOOL)canRegisterObject:(id)object forMapping:(FEMMapping *)mapping;

- (id<FEMAssignmentContextPrivate>)newAssignmentContext;

@end