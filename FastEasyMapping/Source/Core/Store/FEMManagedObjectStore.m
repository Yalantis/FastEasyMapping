//
// Created by zen on 19/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMManagedObjectStore.h"

@import CoreData;

#import "FEMManagedObjectMapping.h"
#import "FEMManagedObjectCache.h"
#import "FEMDefaultAssignmentContext.h"

@implementation FEMManagedObjectStore {
    FEMManagedObjectCache *_cache;

    NSManagedObjectContext *_managedObjectContext;
    FEMManagedObjectMapping *_mapping;
}

@synthesize mapping = _mapping;
@synthesize externalRepresentation = _externalRepresentation;

#pragma mark - Init

- (instancetype)initWithContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        _managedObjectContext = context;

        _cache = [[FEMManagedObjectCache alloc] initWithMapping:_mapping externalRepresentation:externalRepresentation context:_managedObjectContext];
    }

    return self;
}

#pragma mark - FEMDeserializerSource

- (id)newObjectForMapping:(FEMMapping *)mapping {
    NSString *entityName = [(FEMManagedObjectMapping *)mapping entityName];
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:_managedObjectContext];
}

- (id)registeredObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping {
    return [_cache existingObjectForRepresentation:representation mapping:mapping];
}

- (void)registerObject:(id)object forMapping:(FEMMapping *)mapping {
    return [_cache addExistingObject:object usingMapping:mapping];
}

- (NSDictionary *)registeredObjectsForMapping:(FEMMapping *)mapping {
    return [_cache existingObjectsForMapping:mapping];
}

- (BOOL)canRegisterObject:(id)object forMapping:(FEMMapping *)mapping {
    return mapping.primaryKey != nil && [object isInserted];
}

- (id<FEMAssignmentContextPrivate>)newAssignmentContext {
    return [[FEMDefaultAssignmentContext alloc] initWithManagedObjectContext:_managedObjectContext];
}

@end