//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

@import Foundation;

@class NSManagedObjectContext;

@interface FEMAssignmentPolicyMetadata : NSObject

@property (nonatomic, strong) id existingValue;
@property (nonatomic, strong) id targetValue;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end