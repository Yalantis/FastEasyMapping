//
// Created by zen on 19/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMAssignmentContext.h"

@protocol FEMAssignmentContextPrivate <FEMAssignmentContext>

@required
@property (nonatomic, strong) id destinationObject;
@property (nonatomic) FEMRelationship *relationship;

@property (nonatomic, strong) id sourceRelationshipValue;
@property (nonatomic, strong) id targetRelationshipValue;

@end