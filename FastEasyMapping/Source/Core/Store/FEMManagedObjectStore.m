//
// Created by zen on 19/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMManagedObjectStore.h"

@import CoreData;

#import "FEMManagedObjectMapping.h"
#import "FEMManagedObjectCache.h"

__attribute__((always_inline)) void validateMapping(FEMMapping *mapping) {
    NSCAssert(mapping.entityName != nil, @"Entity name can't be nil. Please, use -[FEMMapping initWithEntityName:]");
}

@implementation FEMManagedObjectStore {
    FEMManagedObjectCache *_cache;

    NSManagedObjectContext *_managedObjectContext;
    FEMManagedObjectMapping *_mapping;
}

@synthesize mapping = _mapping;
@synthesize externalRepresentation = _externalRepresentation;

#pragma mark - Init

- (instancetype)initWithContext:(NSManagedObjectContext *)context {
    NSParameterAssert(context != nil);
    self = [super init];
    if (self) {
        _context = context;
    }

    return self;
}

#pragma mark - FEMDeserializerSource

- (id)newObjectForMapping:(FEMMapping *)mapping {
    validateMapping(mapping);

    NSString *entityName = [mapping entityName];
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:_managedObjectContext];
}

- (id)registeredObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping {
    validateMapping(mapping);

    return [_cache existingObjectForRepresentation:representation mapping:mapping];
}

- (void)registerObject:(id)object forMapping:(FEMMapping *)mapping {
    validateMapping(mapping);

    [_cache addExistingObject:object mapping:mapping];
}

- (NSDictionary *)registeredObjectsForMapping:(FEMMapping *)mapping {
    validateMapping(mapping);

    return [_cache existingObjectsForMapping:mapping];
}

- (BOOL)canRegisterObject:(id)object forMapping:(FEMMapping *)mapping {
    validateMapping(mapping);

    return mapping.primaryKey != nil && [object isInserted];
}

#pragma mark - FEMRelationshipAssignmentContextDelegate

- (void)assignmentContext:(FEMRelationshipAssignmentContext *)context deletedObject:(id)object {
    NSAssert([object isKindOfClass:NSManagedObject.class], @"Wrong class");
    [self.context deleteObject:object];
}

@end