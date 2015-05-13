// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMRelationshipAssignmentContext;

typedef id (^FEMAssignmentPolicy)(FEMRelationshipAssignmentContext *context);

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyAssign;

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyObjectMerge;
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyCollectionMerge;

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyObjectReplace;
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyCollectionReplace;