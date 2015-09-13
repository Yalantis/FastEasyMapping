//
// Created by zen on 07/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "FEMRealmAssignmentPolicy.h"
#import "FEMRelationshipAssignmentContext+Internal.h"

#import <FastEasyMapping/FEMRelationshipAssignmentContext.h>
#import <Realm/RLMObject.h>
#import <Realm/RLMArray.h>

FEMAssignmentPolicy FEMRealmAssignmentPolicyCollectionMerge = ^id(FEMRelationshipAssignmentContext *context) {
    if (context.targetRelationshipValue == nil || [(NSArray *)context.targetRelationshipValue count] == 0) {
        return context.sourceRelationshipValue;
    }

    if (context.sourceRelationshipValue == nil) {
        return  context.targetRelationshipValue;
    }

    RLMArray *sourceObjects = context.sourceRelationshipValue;
    NSMutableSet *sourceSet = [[NSMutableSet alloc] initWithCapacity:sourceObjects.count];
    NSMutableArray *targetObjects = [[NSMutableArray alloc] initWithCapacity:sourceObjects.count];
    for (RLMObject *sourceObject in sourceObjects) {
        [sourceSet addObject:sourceObject];
        [targetObjects addObject:sourceObject];
    }

    for (RLMObject *targetObject in (id<NSFastEnumeration>)context.targetRelationshipValue) {
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
        for (RLMObject *object in (id<NSFastEnumeration>)context.sourceRelationshipValue) {
            [context deleteRelationshipObject:object];
        }

        return nil;
    }

    NSMutableSet *targetObjectsSet = [[NSMutableSet alloc] initWithArray:context.targetRelationshipValue];
    for (RLMObject *sourceObject in (id<NSFastEnumeration>)context.sourceRelationshipValue) {
        if (![targetObjectsSet containsObject:sourceObject]) {
            [context deleteRelationshipObject:sourceObject];
        }
    }

    return context.targetRelationshipValue;
};