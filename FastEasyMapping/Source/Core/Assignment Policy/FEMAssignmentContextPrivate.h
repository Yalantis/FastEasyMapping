//
// Created by zen on 19/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMAssignmentContext.h"

@protocol FEMAssignmentContextPrivate <FEMAssignmentContext>

@required
@property (nonatomic, strong, readwrite) id destinationObject;
@property (nonatomic, readwrite) FEMRelationshipMapping *relationshipMapping;

@property (nonatomic, strong, readwrite) id sourceRelationshipValue;
@property (nonatomic, strong, readwrite) id targetRelationshipValue;

@end