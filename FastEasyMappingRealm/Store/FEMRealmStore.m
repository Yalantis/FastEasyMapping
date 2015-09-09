//
// Created by zen on 01/09/15.
// Copyright (c) 2015 Zen. All rights reserved.
//

#import "FEMRealmStore.h"
#import "FEMObjectCache+Realm.h"

#import <Realm/RLMRealm.h>
#import <Realm/RLMRealm_Dynamic.h>
#import <Realm/RLMObject.h>
#import <FastEasyMapping/FastEasyMapping.h>

@implementation FEMRealmStore {
    FEMObjectCache *_cache;
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
    _cache = [[FEMObjectCache alloc] initWithMapping:mapping representation:representation realm:_realm];
}

- (void)beginTransaction {
    [self.realm beginWriteTransaction];
}

- (NSError *)commitTransaction {
    [_realm commitWriteTransaction];

    return nil;
}

- (id)newObjectForMapping:(FEMMapping *)mapping {
    NSString *entityName = [mapping entityName];
    Class realmObjectClass = NSClassFromString(entityName);
    RLMObject *object = [(RLMObject *)[realmObjectClass alloc] init];

    [_realm addObject:object];

    return object;
}

- (id)registeredObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping {
    return [_cache existingObjectForRepresentation:representation mapping:mapping];
}

- (void)registerObject:(id)object forMapping:(FEMMapping *)mapping {
    NSParameterAssert([self canRegisterObject:object forMapping:mapping]);

    [_cache addExistingObject:object mapping:mapping];
}

- (NSDictionary *)registeredObjectsForMapping:(FEMMapping *)mapping {
    return [_cache existingObjectsForMapping:mapping];
}

- (BOOL)canRegisterObject:(id)object forMapping:(FEMMapping *)mapping {
    return mapping.primaryKey != nil;
}

#pragma mark - FEMRelationshipAssignmentContextDelegate

- (void)assignmentContext:(FEMRelationshipAssignmentContext *)context deletedObject:(id)object {
    RLMObject *rlmObject = object;
    if (rlmObject.realm == _realm) {
        [_realm deleteObject:rlmObject];
    }
}

@end