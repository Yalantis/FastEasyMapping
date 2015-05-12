//
// Created by zen on 19/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMObjectStore.h"

@class NSManagedObjectContext;

@interface FEMManagedObjectStore : FEMObjectStore

- (instancetype)initWithContext:(NSManagedObjectContext *)context;

@end