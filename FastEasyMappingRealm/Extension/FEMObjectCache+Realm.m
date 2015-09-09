//
// Created by zen on 03/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "FEMObjectCache+Realm.h"
#import <FastEasyMapping/FEMMapping.h>

#import <Realm/RLMRealm.h>
#import <Realm/RLMRealm_Dynamic.h>
#import <Realm/RLMResults.h>

@implementation FEMObjectCache (Realm)

- (instancetype)initWithMapping:(FEMMapping *)mapping representation:(id)representation realm:(RLMRealm *)realm {
    return [self initWithMapping:mapping representation:representation source:^id<NSFastEnumeration> (FEMMapping *objectMapping, NSSet *primaryKeys) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@", objectMapping.primaryKey, primaryKeys];
        RLMResults *results = [realm objects:objectMapping.entityName withPredicate:predicate];
        return results;
    }];
}

- (instancetype)initWithRealm:(RLMRealm *)realm {
    return [self initWithSource:^id <NSFastEnumeration>(FEMMapping *objectMapping, NSSet *primaryKeys) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@", objectMapping.primaryKey, primaryKeys];
        RLMResults *results = [realm objects:objectMapping.entityName withPredicate:predicate];
        return results;
    }];
}

@end