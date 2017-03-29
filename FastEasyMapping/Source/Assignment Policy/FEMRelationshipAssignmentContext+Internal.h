// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMRelationshipAssignmentContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface FEMRelationshipAssignmentContext (Internal)

@property (nonatomic, strong) id destinationObject;
@property (nonatomic, strong) FEMRelationship *relationship;

@property (nonatomic, strong, nullable) id sourceRelationshipValue;
@property (nonatomic, strong, nullable) id targetRelationshipValue;

@end

NS_ASSUME_NONNULL_END
