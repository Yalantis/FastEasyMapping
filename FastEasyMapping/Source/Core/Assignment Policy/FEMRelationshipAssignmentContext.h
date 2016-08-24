// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMRelationship, FEMObjectStore, FEMRelationshipAssignmentContext;

NS_ASSUME_NONNULL_BEGIN

@protocol FEMRelationshipAssignmentContextDelegate <NSObject>
@required

- (void)assignmentContext:(FEMRelationshipAssignmentContext *)context deletedObject:(id)object;

@end


@interface FEMRelationshipAssignmentContext: NSObject

@property (nonatomic, unsafe_unretained, readonly) FEMObjectStore *store;
- (instancetype)initWithStore:(FEMObjectStore *)store;

@property (nonatomic, strong, readonly) id destinationObject;
@property (nonatomic, strong, readonly) FEMRelationship *relationship;

@property (nonatomic, strong, readonly) id sourceRelationshipValue;
@property (nonatomic, strong, readonly) id targetRelationshipValue;

- (void)deleteRelationshipObject:(id)object;

@end

NS_ASSUME_NONNULL_END