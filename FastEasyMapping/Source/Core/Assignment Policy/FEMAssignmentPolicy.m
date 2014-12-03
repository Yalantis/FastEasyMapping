//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMAssignmentPolicy.h"

#import "FEMAssignmentPolicyMetadata.h"
#import "FEMExcludableCollection.h"
#import "FEMMergeableCollection.h"

@import CoreData;

FEMAssignmentPolicy FEMAssignmentPolicyAssign = ^id (FEMAssignmentPolicyMetadata *metadata) {
    return metadata.targetValue;
};

FEMAssignmentPolicy FEMAssignmentPolicyObjectMerge = ^id (FEMAssignmentPolicyMetadata *metadata) {
    return metadata.targetValue ?: metadata.existingValue;
};

FEMAssignmentPolicy FEMAssignmentPolicyCollectionMerge = ^id (FEMAssignmentPolicyMetadata *metadata) {
    if (!metadata.targetValue) return metadata.existingValue;

    NSCAssert(
        [metadata.targetValue conformsToProtocol:@protocol(FEMMergeableCollection)],
        @"Collection %@ should support protocol %@",
        NSStringFromClass([metadata.targetValue class]),
        NSStringFromProtocol(@protocol(FEMMergeableCollection))
    );

    return [metadata.targetValue collectionByMergingObjects:metadata.existingValue];
};

FEMAssignmentPolicy FEMAssignmentPolicyObjectReplace = ^id (FEMAssignmentPolicyMetadata *metadata) {
    if (metadata.existingValue && ![metadata.existingValue isEqual:metadata.targetValue]) {
        [metadata.context deleteObject:metadata.existingValue];
    }

    return metadata.targetValue;
};

FEMAssignmentPolicy FEMAssignmentPolicyCollectionReplace = ^id (FEMAssignmentPolicyMetadata *metadata) {
    if (!metadata.existingValue) return metadata.targetValue;

    if (metadata.targetValue) {
        NSCAssert(
            [metadata.existingValue conformsToProtocol:@protocol(FEMExcludableCollection)],
            @"Collection %@ should support protocol %@",
            NSStringFromClass([metadata.targetValue class]),
            NSStringFromProtocol(@protocol(FEMExcludableCollection))
        );

        for (id object in [(id<FEMExcludableCollection>)metadata.existingValue collectionByExcludingObjects:metadata.targetValue]) {
            [metadata.context deleteObject:object];
        }
    } else {
        for (id object in metadata.existingValue) {
            [metadata.context deleteObject:object];
        }
    }

    return metadata.targetValue;
};