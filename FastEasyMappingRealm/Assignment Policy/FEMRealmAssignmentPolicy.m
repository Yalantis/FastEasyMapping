//
// Created by zen on 07/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "FEMRealmAssignmentPolicy.h"
#import "FEMRelationshipAssignmentContext+Internal.h"

#import <FastEasyMapping/FEMRelationshipAssignmentContext.h>
#import <Realm/RLMObjectBase.h>
#import <Realm/RLMArray.h>

FEMAssignmentPolicy FEMRealmAssignmentPolicyCollectionMerge = ^id(FEMRelationshipAssignmentContext *context) {
    if (context.targetRelationshipValue == nil || [(NSArray *)context.targetRelationshipValue count] == 0) {
        // Realm <= 0.95.0 drops relationship data is we're using the same RLMArray
        NSMutableArray *copiedSourceValue = [[NSMutableArray alloc] initWithCapacity:[(RLMArray *)context.sourceRelationshipValue count]];
        for (id object in context.sourceRelationshipValue) {
            [copiedSourceValue addObject:object];
        }

        return copiedSourceValue;
    }

    if (context.sourceRelationshipValue == nil) {
        return  context.targetRelationshipValue;
    }

    // Realm <= 0.95.0 drops relationship data is we're using the same RLMArray
    RLMArray *sourceObjects = context.sourceRelationshipValue;
    NSMutableArray *targetObjects = [[NSMutableArray alloc] initWithCapacity:sourceObjects.count];
    NSMutableSet *sourceSet = [[NSMutableSet alloc] initWithCapacity:sourceObjects.count];

    for (RLMObjectBase *sourceObject in sourceObjects) {
        [sourceSet addObject:sourceObject];
        [targetObjects addObject:sourceObject];
    }

    for (RLMObjectBase *targetObject in (id<NSFastEnumeration>)context.targetRelationshipValue) {
        if (![sourceSet containsObject:targetObject]) {
            [targetObjects addObject:targetObject];
        }
    }

    return targetObjects;
};

FEMAssignmentPolicy FEMRealmAssignmentPolicyCollectionReplace = ^id(FEMRelationshipAssignmentContext *context) {
    if (context.sourceRelationshipValue == nil) {
        return context.targetRelationshipValue;
    }

    if (context.targetRelationshipValue == nil) {
        for (RLMObjectBase *object in (id<NSFastEnumeration>)context.sourceRelationshipValue) {
            [context deleteRelationshipObject:object];
        }

        return nil;
    }

    NSMutableSet *targetObjectsSet = [[NSMutableSet alloc] initWithArray:context.targetRelationshipValue];
    for (RLMObjectBase *sourceObject in (id<NSFastEnumeration>)context.sourceRelationshipValue) {
        if (![targetObjectsSet containsObject:sourceObject]) {
            [context deleteRelationshipObject:sourceObject];
        }
    }

    return context.targetRelationshipValue;
};