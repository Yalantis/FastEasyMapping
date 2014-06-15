//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMAssignmentPolicy.h"

#import "FEMAssignmentPolicyMetadata.h"
#import "NSObject+FEMMerge.h"

@import CoreData;

FEMAssignmentPolicy FEMAssignmentPolicyAssign = ^id (FEMAssignmentPolicyMetadata *metadata) {
    return metadata.targetValue;
};

FEMAssignmentPolicy FEMAssignmentPolicyMerge = ^id (FEMAssignmentPolicyMetadata *metadata) {
    return [metadata.targetValue fem_merge:metadata.existingValue];
};

FEMAssignmentPolicy FEMAssignmentPolicyReplace = ^id (FEMAssignmentPolicyMetadata *metadata) {
    return metadata.targetValue;
};