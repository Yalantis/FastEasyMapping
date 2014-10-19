//
// Created by zen on 19/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMDeserializerSource.h"

@class FEMManagedObjectMapping, NSManagedObjectContext;

@interface FEMManagedObjectDeserializerSource : NSObject <FEMDeserializerSource>

- (instancetype)initWithMapping:(FEMManagedObjectMapping *)mapping managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end