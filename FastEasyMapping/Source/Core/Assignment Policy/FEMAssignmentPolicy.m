//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMAssignmentPolicy.h"

#import "FEMAssignmentPolicyMetadata.h"
#import "NSObject+FEMExtension.h"
#import "FEMExcludable.h"

@import CoreData;

FEMAssignmentPolicy FEMAssignmentPolicyAssign = ^id (FEMAssignmentPolicyMetadata *metadata) {
    return metadata.targetValue;
};

FEMAssignmentPolicy FEMAssignmentPolicyMerge = ^id (FEMAssignmentPolicyMetadata *metadata) {
    if (!metadata.targetValue) return metadata.existingValue;

    return [metadata.targetValue fem_merge:metadata.existingValue];
};

FEMAssignmentPolicy FEMAssignmentPolicyReplace = ^id (FEMAssignmentPolicyMetadata *metadata) {
    if (!metadata.existingValue) return metadata.targetValue;

    if ([metadata.existingValue isKindOfClass:NSManagedObject.class]) {
        [metadata.context deleteObject:metadata.existingValue];
    } else if (metadata.targetValue) {
        NSCAssert(
            [metadata.targetValue conformsToProtocol:@protocol(FEMExcludable)],
            @"Collection %@ should support protocol %@",
            NSStringFromClass([metadata.targetValue class]),
            NSStringFromProtocol(@protocol(FEMExcludable))
        );

        for (id object in [(id<FEMExcludable>)metadata.existingValue collectionByExcludingObjects:metadata.targetValue]) {
            [metadata.context deleteObject:object];
        }
    }

    return metadata.targetValue;
};