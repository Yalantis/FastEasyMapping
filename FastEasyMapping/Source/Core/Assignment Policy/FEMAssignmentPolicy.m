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
    return metadata.targetValue ?: metadata.sourceValue;
};

FEMAssignmentPolicy FEMAssignmentPolicyCollectionMerge = ^id (FEMAssignmentPolicyMetadata *metadata) {
    if (!metadata.targetValue) return metadata.sourceValue;

    NSCAssert(
        [metadata.targetValue conformsToProtocol:@protocol(FEMMergeableCollection)],
        @"Collection %@ should support protocol %@",
        NSStringFromClass([metadata.targetValue class]),
        NSStringFromProtocol(@protocol(FEMMergeableCollection))
    );

    return [metadata.targetValue collectionByMergingObjects:metadata.sourceValue];
};

FEMAssignmentPolicy FEMAssignmentPolicyObjectReplace = ^id (FEMAssignmentPolicyMetadata *metadata) {
    if (metadata.sourceValue && ![metadata.sourceValue isEqual:metadata.targetValue]) {
        [metadata.context deleteObject:metadata.sourceValue];
    }

    return metadata.targetValue;
};

FEMAssignmentPolicy FEMAssignmentPolicyCollectionReplace = ^id (FEMAssignmentPolicyMetadata *metadata) {
    if (!metadata.sourceValue) return metadata.targetValue;

    if (metadata.targetValue) {
        NSCAssert(
            [metadata.sourceValue conformsToProtocol:@ protocol(FEMExcludableCollection)],
            @"Collection %@ should support protocol %@",
            NSStringFromClass([metadata.targetValue class]),
            NSStringFromProtocol(@protocol(FEMExcludableCollection))
        );

        for (id object in [(id<FEMExcludableCollection>)metadata.sourceValue collectionByExcludingObjects:metadata.targetValue]) {
            [metadata.context deleteObject:object];
        }
    } else {
        for (id object in metadata.sourceValue) {
            [metadata.context deleteObject:object];
        }
    }

    return metadata.targetValue;
};

#pragma mark - Deprecated

FEMAssignmentPolicy FEMAssignmentPolicyMerge = ^id (FEMAssignmentPolicyMetadata *metadata) {
    if (!metadata.targetValue) return metadata.sourceValue;

    if ([metadata.targetValue isKindOfClass:NSManagedObject.class]) return metadata.targetValue;

    NSCAssert(
        [metadata.targetValue conformsToProtocol:@protocol(FEMMergeableCollection)],
        @"Collection %@ should support protocol %@",
        NSStringFromClass([metadata.targetValue class]),
        NSStringFromProtocol(@protocol(FEMMergeableCollection))
    );

    return [metadata.targetValue collectionByMergingObjects:metadata.sourceValue];
};

FEMAssignmentPolicy FEMAssignmentPolicyReplace = ^id (FEMAssignmentPolicyMetadata *metadata) {
    if (!metadata.sourceValue) return metadata.targetValue;

    if ([metadata.sourceValue isKindOfClass:NSManagedObject.class]) {
        [metadata.context deleteObject:metadata.sourceValue];
    } else if (metadata.targetValue) {
        NSCAssert(
            [metadata.targetValue conformsToProtocol:@protocol(FEMExcludableCollection)],
            @"Collection %@ should support protocol %@",
            NSStringFromClass([metadata.targetValue class]),
            NSStringFromProtocol(@protocol(FEMExcludableCollection))
        );

        for (id object in [(id<FEMExcludableCollection>)metadata.sourceValue collectionByExcludingObjects:metadata.targetValue]) {
            [metadata.context deleteObject:object];
        }
    }

    return metadata.targetValue;
};