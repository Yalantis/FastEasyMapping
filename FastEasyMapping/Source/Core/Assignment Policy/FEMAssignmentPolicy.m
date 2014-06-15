//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMAssignmentPolicy.h"
#import "FEMAssignmentPolicyMetadata.h"

@import CoreData;

FEMAssignmentPolicy FEMAssignmentPolicyAssign = ^id (FEMAssignmentPolicyMetadata *metadata) {
    return metadata.newValue;
};

FEMAssignmentPolicy FEMAssignmentPolicyMerge = ^id (FEMAssignmentPolicyMetadata *metadata) {



    return nil;
};

FEMAssignmentPolicy FEMAssignmentPolicyReplace = ^id (FEMAssignmentPolicyMetadata *metadata) {
    NSCParameterAssert([context isKindOfClass:NSManagedObjectContext.class]);

};