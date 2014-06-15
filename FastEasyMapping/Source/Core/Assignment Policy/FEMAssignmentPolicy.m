//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMAssignmentPolicy.h"

#import "FEMAssignmentPolicyMetadata.h"
#import "NSObject+FEMExtension.h"

@import CoreData;

FEMAssignmentPolicy FEMAssignmentPolicyAssign = ^id (FEMAssignmentPolicyMetadata *metadata) {
    return metadata.targetValue;
};

FEMAssignmentPolicy FEMAssignmentPolicyMerge = ^id (FEMAssignmentPolicyMetadata *metadata) {
    return [metadata.targetValue fem_merge:metadata.existingValue];
};

FEMAssignmentPolicy FEMAssignmentPolicyReplace = ^id (FEMAssignmentPolicyMetadata *metadata) {
    if (!metadata.existingValue) return metadata.targetValue;

    if ([metadata.existingValue conformsToProtocol:@protocol(NSFastEnumeration)]) {
        id<NSFastEnumeration> collection = (id<NSFastEnumeration>)[metadata.existingValue fem_except:metadata.targetValue];
        for (id object in collection) {
            [metadata.context deleteObject:object];
        }
    } else {
        [metadata.context deleteObject:metadata.existingValue];
    }

    return metadata.targetValue;
};