//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMDefaultAssignmentContext.h"

@import CoreData;

@implementation FEMDefaultAssignmentContext {
    NSManagedObjectContext *_managedObjectContext;
}

@synthesize destinationObject = _destinationObject;
@synthesize destinationProperty = _destinationProperty;
@synthesize existingRelationshipValue = _existingRelationshipValue;
@synthesize targetRelationshipValue = _targetRelationshipValue;

#pragma mark - Init

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super init];
    if (self) {
        _managedObjectContext = managedObjectContext;
    }

    return self;
}

- (void)deleteRelationshipObject:(id)object {
    [_managedObjectContext deleteObject:object];
}
@end