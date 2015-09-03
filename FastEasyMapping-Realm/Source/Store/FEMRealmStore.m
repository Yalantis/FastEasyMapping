//
// Created by zen on 01/09/15.
// Copyright (c) 2015 Zen. All rights reserved.
//

#import "FEMRealmStore.h"
#import <Realm/RLMRealm_Dynamic.h>

#import <FastEasyMapping/FastEasyMapping.h>

@implementation FEMRealmStore {
    RLMRealm *_realm;

    NSDictionary *_lookupKeysMap;
    NSMutableDictionary *_lookupObjectsMap;
    NSMutableSet *_standaloneObjects;
}

- (instancetype)initWithRealm:(RLMRealm *)realm {
    self = [super init];
    if (self) {
        _realm = realm;
    }

    return self;
}

+ (instancetype)storeWithRealm:(RLMRealm *)realm {
    return [[self alloc] initWithRealm:realm];
}

#pragma mark - Cache

- (NSMutableDictionary *)fetchExistingObjectsForMapping:(FEMMapping *)mapping {
    NSSet *lookupValues = _lookupKeysMap[mapping.entityName];
    if (lookupValues.count == 0) return [NSMutableDictionary dictionary];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@", mapping.primaryKey, lookupValues];
    RLMResults *results = [self.realm objects:mapping.entityName withPredicate:predicate];
    NSMutableDictionary *output = [NSMutableDictionary new];
    for (RLMObject *object in results) {
        output[[object valueForKey:mapping.primaryKey]] = object;
    }

    return output;
}

- (NSMutableDictionary *)cachedObjectsForMapping:(FEMMapping *)mapping {
    NSMutableDictionary *entityObjectsMap = _lookupObjectsMap[mapping.entityName];
    if (!entityObjectsMap) {
        entityObjectsMap = [self fetchExistingObjectsForMapping:mapping];
        _lookupObjectsMap[mapping.entityName] = entityObjectsMap;
    }

    return entityObjectsMap;
}

- (id)existingObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping {
    NSDictionary *entityObjectsMap = [self cachedObjectsForMapping:mapping];

    id primaryKeyValue = FEMRepresentationValueForAttribute(representation, mapping.primaryKeyAttribute);
    if (primaryKeyValue == nil || primaryKeyValue == NSNull.null) return nil;

    return entityObjectsMap[primaryKeyValue];
}

- (id)existingObjectForPrimaryKey:(id)primaryKey mapping:(FEMMapping *)mapping {
    NSDictionary *entityObjectsMap = [self cachedObjectsForMapping:mapping];

    return entityObjectsMap[primaryKey];
}

- (void)addExistingObject:(id)object mapping:(FEMMapping *)mapping {
    NSParameterAssert(mapping.primaryKey);
    NSParameterAssert(object);

    id primaryKeyValue = [object valueForKey:mapping.primaryKey];
    NSAssert(primaryKeyValue, @"No value for key (%@) on object (%@) found", mapping.primaryKey, object);

    NSMutableDictionary *entityObjectsMap = [self cachedObjectsForMapping:mapping];
    entityObjectsMap[primaryKeyValue] = object;
}

- (NSDictionary *)existingObjectsForMapping:(FEMMapping *)mapping {
    return [[self cachedObjectsForMapping:mapping] copy];
}

#pragma mark - Transaction

- (void)prepareTransactionForMapping:(nonnull FEMMapping *)mapping ofRepresentation:(nonnull NSArray *)representation {
    _lookupKeysMap = FEMRepresentationCollectPresentedPrimaryKeys(representation, mapping);
    _lookupObjectsMap = [NSMutableDictionary new];
    _standaloneObjects = [NSMutableSet new];
}

- (void)beginTransaction {
    [self.realm beginWriteTransaction];
}

- (NSError *)commitTransaction {
    _lookupKeysMap = nil;
    _lookupObjectsMap = nil;

    [self.realm addObjects:_standaloneObjects];
    _standaloneObjects = nil;

    [self.realm commitWriteTransaction];

    return nil;
}

- (id)newObjectForMapping:(FEMMapping *)mapping {
    NSString *entityName = [mapping entityName];
    Class realmObjectClass = NSClassFromString(entityName);
    RLMObject *object = [(RLMObject *)[realmObjectClass alloc] init];

    [_standaloneObjects addObject:object];

    return object;
}

- (id)registeredObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping {
    return [self existingObjectForRepresentation:representation mapping:mapping];
}

- (void)registerObject:(id)object forMapping:(FEMMapping *)mapping {
    [self addExistingObject:object mapping:mapping];
}

- (NSDictionary *)registeredObjectsForMapping:(FEMMapping *)mapping {
    return [self existingObjectsForMapping:mapping];
}

- (BOOL)canRegisterObject:(id)object forMapping:(FEMMapping *)mapping {
    return mapping.primaryKey != nil && [(RLMObject *)object realm] == nil;
}

#pragma mark - FEMRelationshipAssignmentContextDelegate

- (void)assignmentContext:(FEMRelationshipAssignmentContext *)context deletedObject:(id)object {
    RLMObject *rlmObject = object;
    if ([_standaloneObjects containsObject:rlmObject]) {
        [_standaloneObjects removeObject:rlmObject];
    } else {
        [self.realm deleteObject:object];
    }
}

@end