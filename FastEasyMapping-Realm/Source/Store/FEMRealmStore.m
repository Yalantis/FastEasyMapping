//
// Created by zen on 01/09/15.
// Copyright (c) 2015 Zen. All rights reserved.
//

#import "FEMRealmStore.h"
#import "FEMObjectCache+Realm.h"

#import <Realm/RLMRealm_Dynamic.h>
#import <Realm/RLMObject.h>
#import <FastEasyMapping/FastEasyMapping.h>

@implementation FEMRealmStore {
    FEMObjectCache *_cache;
    NSMutableSet *_newObjects;
}

- (instancetype)initWithRealm:(RLMRealm *)realm {
    NSParameterAssert(realm != nil);

    self = [super init];
    if (self) {
        _realm = realm;
    }

    return self;
}

#pragma mark - Transaction

- (void)prepareTransactionForMapping:(nonnull FEMMapping *)mapping ofRepresentation:(nonnull NSArray *)representation {
    _cache = [[FEMObjectCache alloc] initWithMapping:mapping representation:representation realm:self.realm];
    _newObjects = [[NSMutableSet alloc] init];
}

- (void)beginTransaction {
    [self.realm beginWriteTransaction];
}

- (NSError *)commitTransaction {
    [self.realm addObjects:_newObjects];
    _newObjects = nil;

    [self.realm commitWriteTransaction];

    return nil;
}

- (id)newObjectForMapping:(FEMMapping *)mapping {
    NSString *entityName = [mapping entityName];
    Class realmObjectClass = NSClassFromString(entityName);
    RLMObject *object = [(RLMObject *)[realmObjectClass alloc] init];

    [_newObjects addObject:object];

    return object;
}

- (id)registeredObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping {
    return [_cache existingObjectForRepresentation:representation mapping:mapping];
}

- (void)registerObject:(id)object forMapping:(FEMMapping *)mapping {
    [_cache addExistingObject:object mapping:mapping];
    [_newObjects addObject:object];
}

- (NSDictionary *)registeredObjectsForMapping:(FEMMapping *)mapping {
    return [_cache existingObjectsForMapping:mapping];
}

- (BOOL)canRegisterObject:(id)object forMapping:(FEMMapping *)mapping {
    return mapping.primaryKey != nil && [(RLMObject *)object realm] == nil;
}

#pragma mark - FEMRelationshipAssignmentContextDelegate

- (void)assignmentContext:(FEMRelationshipAssignmentContext *)context deletedObject:(id)object {
    RLMObject *rlmObject = object;
    if (rlmObject.realm == nil) {
        [_newObjects removeObject:rlmObject];
    } else {
        [self.realm deleteObject:object];
    }
}

@end