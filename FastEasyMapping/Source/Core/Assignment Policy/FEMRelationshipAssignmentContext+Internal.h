// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMRelationshipAssignmentContext.h"

@interface FEMRelationshipAssignmentContext (Internal)

@property (nonatomic, strong) id destinationObject;
@property (nonatomic, strong) FEMRelationship *relationship;

@property (nonatomic, strong) id sourceRelationshipValue;
@property (nonatomic, strong) id targetRelationshipValue;

@end