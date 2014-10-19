//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMAssignmentPolicy.h"

#import "FEMDefaultAssignmentContext.h"
#import "FEMExcludableCollection.h"
#import "FEMMergeableCollection.h"

@import CoreData;

FEMAssignmentPolicy FEMAssignmentPolicyAssign = ^id (FEMDefaultAssignmentContext *metadata) {
    return metadata.targetRelationshipValue;
};

FEMAssignmentPolicy FEMAssignmentPolicyObjectMerge = ^id (FEMDefaultAssignmentContext *metadata) {
    return metadata.targetRelationshipValue ?: metadata.sourceValue;
};

FEMAssignmentPolicy FEMAssignmentPolicyCollectionMerge = ^id (FEMDefaultAssignmentContext *metadata) {
    if (!metadata.targetRelationshipValue) return metadata.sourceValue;

    NSCAssert(
        [metadata.targetRelationshipValue conformsToProtocol:@ protocol(FEMMergeableCollection)],
        @"Collection %@ should support protocol %@",
        NSStringFromClass([metadata.targetRelationshipValue class]),
        NSStringFromProtocol(@protocol(FEMMergeableCollection))
    );

    return [metadata.targetRelationshipValue collectionByMergingObjects:metadata.sourceValue];
};

FEMAssignmentPolicy FEMAssignmentPolicyObjectReplace = ^id (FEMDefaultAssignmentContext *metadata) {
    if (metadata.sourceValue && ![metadata.sourceValue isEqual:metadata.targetRelationshipValue]) {
        [metadata.context deleteObject:metadata.sourceValue];
    }

    return metadata.targetRelationshipValue;
};

FEMAssignmentPolicy FEMAssignmentPolicyCollectionReplace = ^id (FEMDefaultAssignmentContext *metadata) {
    if (!metadata.sourceValue) return metadata.targetRelationshipValue;

    if (metadata.targetRelationshipValue) {
        NSCAssert(
            [metadata.sourceValue conformsToProtocol:@ protocol(FEMExcludableCollection)],
            @"Collection %@ should support protocol %@",
            NSStringFromClass([metadata.targetRelationshipValue class]),
            NSStringFromProtocol(@protocol(FEMExcludableCollection))
        );

        for (id object in [(id <FEMExcludableCollection>) metadata.sourceValue collectionByExcludingObjects:metadata.targetRelationshipValue]) {
            [metadata.context deleteObject:object];
        }
    } else {
        for (id object in metadata.sourceValue) {
            [metadata.context deleteObject:object];
        }
    }

    return metadata.targetRelationshipValue;
};

#pragma mark - Deprecated

FEMAssignmentPolicy FEMAssignmentPolicyMerge = ^id (FEMDefaultAssignmentContext *metadata) {
    if (!metadata.targetRelationshipValue) return metadata.sourceValue;

    if ([metadata.targetRelationshipValue isKindOfClass:NSManagedObject.class]) return metadata.targetRelationshipValue;

    NSCAssert(
        [metadata.targetRelationshipValue conformsToProtocol:@ protocol(FEMMergeableCollection)],
        @"Collection %@ should support protocol %@",
        NSStringFromClass([metadata.targetRelationshipValue class]),
        NSStringFromProtocol(@protocol(FEMMergeableCollection))
    );

    return [metadata.targetRelationshipValue collectionByMergingObjects:metadata.sourceValue];
};

FEMAssignmentPolicy FEMAssignmentPolicyReplace = ^id (FEMDefaultAssignmentContext *metadata) {
    if (!metadata.sourceValue) return metadata.targetRelationshipValue;

    if ([metadata.sourceValue isKindOfClass:NSManagedObject.class]) {
        [metadata.context deleteObject:metadata.sourceValue];
    } else if (metadata.targetRelationshipValue) {
        NSCAssert(
            [metadata.targetRelationshipValue conformsToProtocol:@ protocol(FEMExcludableCollection)],
            @"Collection %@ should support protocol %@",
            NSStringFromClass([metadata.targetRelationshipValue class]),
            NSStringFromProtocol(@protocol(FEMExcludableCollection))
        );

        for (id object in [(id <FEMExcludableCollection>) metadata.sourceValue collectionByExcludingObjects:metadata.targetRelationshipValue]) {
            [metadata.context deleteObject:object];
        }
    }

    return metadata.targetRelationshipValue;
};