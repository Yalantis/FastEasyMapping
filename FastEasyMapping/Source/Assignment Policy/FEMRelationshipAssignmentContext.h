// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMRelationship, FEMObjectStore, FEMRelationshipAssignmentContext;

NS_ASSUME_NONNULL_BEGIN

@protocol FEMRelationshipAssignmentContextDelegate <NSObject>
@required

- (void)assignmentContext:(FEMRelationshipAssignmentContext *)context deletedObject:(id)object;

@end

/**
 @brief Context used during assignment of relationship values.
 
 @discussion Context acts as a intermediate object between assignment policy and a deserialization process.
 */
@interface FEMRelationshipAssignmentContext: NSObject

- (instancetype)initWithStore:(FEMObjectStore *)store;

/**
 @brief Store that is being used during deserialization.
 
 @discussion It may be used in order to construct new objects by calling `-[FEMObjectStore newObjectForMapping:]`.
 */
@property (nonatomic, unsafe_unretained, readonly) FEMObjectStore *store;

/**
 @brief Object to which returned by assignment policy value will be applied. 
 
 @discussion Imagine you're deserializing User and its Comments that are described by a `relationship`. 
 `destinationObject` is going to be an instance of the `User` class.
 */
@property (nonatomic, strong, readonly) id destinationObject;

/// FEMRelationship describing connection between "Parent" object and it's "Child".
@property (nonatomic, strong, readonly) FEMRelationship *relationship;

/**
 @discussion Initial value of the relationship.
 */
@property (nonatomic, strong, readonly) id sourceRelationshipValue;

/**
 @discussion Target (deserialized) value of the relationship that is going to be applied. However you may want to customize 
 this behaviour by implementing custom FEMAssignmentPolicy.
 */
@property (nonatomic, strong, readonly) id targetRelationshipValue;

/**
 @discussion During assignment it may appear that some of the objects needs to be removed (replacement, for example). 
 In this case `deleteRelationshipObject:` has to be invoked. Result of removal of the `destinationObject` is undefined.
 */
- (void)deleteRelationshipObject:(id)object;

@end

NS_ASSUME_NONNULL_END
