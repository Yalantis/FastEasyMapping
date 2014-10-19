//
// Created by zen on 19/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

@import Foundation;

@class FEMRelationshipMapping;

@protocol FEMAssignmentContext <NSObject>

@required
@property (nonatomic, readonly) id destinationObject;
@property (nonatomic, readonly) FEMRelationshipMapping *relationshipMapping;

@property (nonatomic, readonly) id sourceRelationshipValue;
@property (nonatomic, readonly) id targetRelationshipValue;

- (void)deleteRelationshipObject:(id)object;

@end