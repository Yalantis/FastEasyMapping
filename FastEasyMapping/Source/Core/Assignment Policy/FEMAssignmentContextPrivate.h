//
// Created by zen on 19/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMAssignmentContext.h"

@protocol FEMAssignmentContextPrivate <FEMAssignmentContext>

@required
@property (nonatomic, strong, readwrite) id destinationObject;
@property (nonatomic, readwrite) objc_property_t destinationProperty;

@property (nonatomic, strong, readwrite) id existingRelationshipValue;
@property (nonatomic, strong, readwrite) id targetRelationshipValue;

@end