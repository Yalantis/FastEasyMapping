//
// Created by zen on 19/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

@import Foundation;

#import <objc/runtime.h>

@protocol FEMAssignmentContext <NSObject>

@required
@property (nonatomic, readonly) id destinationObject;
@property (nonatomic, readonly) objc_property_t destinationProperty;

@property (nonatomic, readonly) id existingRelationshipValue;
@property (nonatomic, readonly) id targetRelationshipValue;

- (void)deleteRelationshipObject:(id)object;

@end