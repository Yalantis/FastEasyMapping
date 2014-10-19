//
// Created by zen on 19/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

@import Foundation;

#import <objc/runtime.h>

@protocol FEMAssignmentPolicyContext <NSObject>
@required
- (id)destinationObject;
- (objc_property_t)destinationProperty;

- (id)existingValue;
- (id)targetValue;

@end