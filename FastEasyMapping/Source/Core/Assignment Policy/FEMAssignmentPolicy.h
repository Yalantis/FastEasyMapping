// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMRelationshipAssignmentContext;

NS_ASSUME_NONNULL_BEGIN

typedef __nullable id (^FEMAssignmentPolicy)(FEMRelationshipAssignmentContext *context);

/**
 @brief Assign new value. Previous value remains untouched. Suitable for both to-one and to-many relationship types.
 
 @discussion Given values: A (old), B (new). Result of assignment is B, A remains untouched (not removed from the database).
 */
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyAssign;

/**
 @brief Merge two values. Suitable for to-one relationship type.
 
 @discussion Given values: A (old), B (new). Result of assignment is either B or A in case B is nil.
 Previous value remains untouched (not removed from the database).
 
 IMPORTANT: Designed only for to-one relationship type.
 */
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyObjectMerge;

/**
 @brief Merge two collections. Suitable for to-many relationship type.
 
 @discussion Given two collections: [A, B, C, D] and [1, 2, 3, 4]. Result of assignment is a merged collection: [A, B, C, D, 1, 2, 3, 4].
 Values that are presented in both collections do no duplicated, therefore merge of two collections [A, B] and [B, C] will result into a [A, B, C, D].
 
 Supported collections are:
 - For ObjC (with or without generics): NSArray, NSMutableArray, NSSet, NSMutableSet, NSOrderedSet, NSMutableOrderedSet.
 - For Swift: only bridgeable collections such as Array, Set. However you can also use plain ObjC collections (like NSOrderedSet) if needed.
 
 IMPORTANT: Designed only for to-many relationship type.
 */
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyCollectionMerge;

/**
 @brief Replace old value by new. Suitable for to-one relationship type.
 
 @discussion Given values: A (old), B (new). Result of assignment is B. A removed from the database.
 
 IMPORTANT: Designed only for to-one relationship type.
 */
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyObjectReplace;

/**
 @brief Replace old values by new. Suitable for to-many relationship type.
 
 @discussion Given two collections: [A, B, C, D] and [1, 2, 3, 4]. Result of assignment is a collection: [1, 2, 3, 4].
 Note, that [A, B, C, D] removed from the database!
 
 In case value presented in both new and old collections it . Therefore result of replacement of [A, B, C] by [C, D] is [C, D].
 [A, B] removed from the database!
 
 Supported collections are:
 - For ObjC (with or without generics): NSArray, NSMutableArray, NSSet, NSMutableSet, NSOrderedSet, NSMutableOrderedSet.
 - For Swift: only bridgeable collections such as Array, Set. However you can also use plain ObjC collections (like NSOrderedSet) if needed.
 
 IMPORTANT: Designed only for to-many relationship type.
 */
OBJC_EXTERN FEMAssignmentPolicy FEMAssignmentPolicyCollectionReplace;

NS_ASSUME_NONNULL_END
