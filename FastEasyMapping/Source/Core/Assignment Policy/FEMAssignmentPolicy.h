//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FEMRelationshipAssignmentContext;

typedef id (^FEMAssignmentPolicy)(FEMRelationshipAssignmentContext *context);

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyAssign;

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyObjectMerge;
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyCollectionMerge;

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyObjectReplace;
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyCollectionReplace;