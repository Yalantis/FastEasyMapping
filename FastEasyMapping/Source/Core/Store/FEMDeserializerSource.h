//
// Created by zen on 19/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

@import Foundation.h;

@protocol FEMAssignmentContextPrivate;

@class FEMMapping, FEMDeserializer;

@protocol FEMDeserializerSource <NSObject>

@required

@property (nonatomic, strong, readonly) FEMMapping *mapping;
@property (nonatomic, strong, readonly) id externalRepresentation;

- (id)newObjectForMapping:(FEMMapping *)mapping;

- (id)registeredObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping;
- (void)registerObject:(id)object forMapping:(FEMMapping *)mapping;
- (NSDictionary *)registeredObjectsForMapping:(FEMMapping *)mapping;

- (BOOL)shouldRegisterObject:(id)object forMapping:(FEMMapping *)mapping;

- (id<FEMAssignmentContextPrivate>)newAssignmentContext;

@end