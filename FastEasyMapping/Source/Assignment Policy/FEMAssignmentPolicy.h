// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMRelationshipAssignmentContext;

NS_ASSUME_NONNULL_BEGIN

typedef __nullable id (^FEMAssignmentPolicy)(FEMRelationshipAssignmentContext * context);

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyAssign;

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyObjectMerge;
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyCollectionMerge;

OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyObjectReplace;
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyCollectionReplace;

NS_ASSUME_NONNULL_END