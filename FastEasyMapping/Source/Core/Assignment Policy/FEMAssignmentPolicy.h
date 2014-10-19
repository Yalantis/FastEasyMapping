//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

@import Foundation;

@protocol FEMAssignmentContext;

typedef id (^FEMAssignmentPolicy)(id<FEMAssignmentContext> context);

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyAssign;

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyObjectMerge;
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyCollectionMerge;

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyObjectReplace;
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyCollectionReplace;