//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

@import Foundation;

#import "FEMAssignmentContextPrivate.h"

@class NSManagedObjectContext;

@interface FEMDefaultAssignmentContext : NSObject <FEMAssignmentContextPrivate>

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end