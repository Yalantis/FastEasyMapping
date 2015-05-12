//
// Created by zen on 19/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMDeserializerSource.h"

@class FEMManagedObjectMapping, NSManagedObjectContext;

@interface FEMManagedObjectStore : NSObject <FEMDeserializerSource>

- (instancetype)initWithMapping:(FEMManagedObjectMapping *)mapping
         externalRepresentation:(id)externalRepresentation
           managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end