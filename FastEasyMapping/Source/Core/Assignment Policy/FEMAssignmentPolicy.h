//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

@import Foundation;

@class FEMAssignmentPolicyMetadata;

typedef id (^FEMAssignmentPolicy)(FEMAssignmentPolicyMetadata *metadata);

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyAssign;

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyMerge;

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyReplace;