//
// Created by zen on 19/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMManagedObjectDeserializerSource.h"

#import "FEMManagedObjectMapping.h"
#import "FEMCache.h"

@implementation FEMManagedObjectDeserializerSource {
    FEMCache *_cache;

    NSManagedObjectContext *_managedObjectContext;
    FEMManagedObjectMapping *_mapping;
}

#pragma mark - Init

- (instancetype)initWithMapping:(FEMManagedObjectMapping *)mapping managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super init];
    if (self) {
        _managedObjectContext = managedObjectContext;
        _mapping = mapping;
    }

    return self;
}

#pragma mark - FEMDeserializerSource

- (void)prepareForDeserializationOfExternalRepresentation:(id)externalRepresentation deserializer:(FEMDeserializer *)deserializer {
    _cache = [[FEMCache alloc] initWithMapping:_mapping externalRepresentation:externalRepresentation context:_managedObjectContext];
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

@end