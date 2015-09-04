//
// Created by zen on 13/05/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

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