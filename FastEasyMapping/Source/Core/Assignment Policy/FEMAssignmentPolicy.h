//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

@import Foundation;

@class FEMDefaultAssignmentContext;

typedef id (^FEMAssignmentPolicy)(FEMDefaultAssignmentContext *metadata);

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyAssign;

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyMerge __attribute__((deprecated("will become obsolete in 0.5.0; use FEMAssignmentPolicyObjectMerge or FEMAssignmentPolicyCollectionMerge instead")));
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyObjectMerge;
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyCollectionMerge;

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyReplace __attribute__((deprecated("will become obsolete in 0.5.0; use FEMAssignmentPolicyObjectReplace or FEMAssignmentPolicyCollectionReplace instead")));
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyObjectReplace;
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyCollectionReplace;