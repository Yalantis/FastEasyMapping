//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMAssignmentPolicy.h"

#import "FEMAssignmentContext.h"
#import "FEMExcludableCollection.h"
#import "FEMMergeableCollection.h"

FEMAssignmentPolicy FEMAssignmentPolicyAssign = ^id (id<FEMAssignmentContext> context) {
    return context.targetRelationshipValue;
};

FEMAssignmentPolicy FEMAssignmentPolicyObjectMerge = ^id (id<FEMAssignmentContext> context) {
    return context.targetRelationshipValue ?: context.sourceRelationshipValue;
};

FEMAssignmentPolicy FEMAssignmentPolicyCollectionMerge = ^id (id<FEMAssignmentContext> context) {
    if (!context.targetRelationshipValue) return context.sourceRelationshipValue;

    NSCAssert(
        [context.targetRelationshipValue conformsToProtocol:@protocol(FEMMergeableCollection)],
        @"Collection %@ should support protocol %@",
        NSStringFromClass([context.targetRelationshipValue class]),
        NSStringFromProtocol(@protocol(FEMMergeableCollection))
    );

    return [context.targetRelationshipValue collectionByMergingObjects:context.sourceRelationshipValue];
};

FEMAssignmentPolicy FEMAssignmentPolicyObjectReplace = ^id (id<FEMAssignmentContext> context) {
    if (context.sourceRelationshipValue && ![context.sourceRelationshipValue isEqual:context.targetRelationshipValue]) {
        [context deleteRelationshipObject:context.sourceRelationshipValue];
    }

    return context.targetRelationshipValue;
};

FEMAssignmentPolicy FEMAssignmentPolicyCollectionReplace = ^id (id<FEMAssignmentContext> context) {
    if (!context.sourceRelationshipValue) return context.targetRelationshipValue;

    if (context.targetRelationshipValue) {
        NSCAssert(
            [context.sourceRelationshipValue conformsToProtocol:@ protocol(FEMExcludableCollection)],
            @"Collection %@ should support protocol %@",
            NSStringFromClass([context.targetRelationshipValue class]),
            NSStringFromProtocol(@protocol(FEMExcludableCollection))
        );

        id objectsToDelete = [(id<FEMExcludableCollection>)context.sourceRelationshipValue collectionByExcludingObjects:context.targetRelationshipValue];
        for (id object in objectsToDelete) {
            [context deleteRelationshipObject:object];
        }
    } else {
        for (id object in context.sourceRelationshipValue) {
            [context deleteRelationshipObject:object];
        }
    }

    return context.targetRelationshipValue;
};