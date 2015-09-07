//
// Created by zen on 03/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "FEMDeserializer+Realm.h"
#import "FEMRealmStore.h"

#import <Realm/RLMRealm.h>

@implementation FEMDeserializer (Realm)

- (nonnull instancetype)initWithRealm:(RLMRealm *)realm {
    NSParameterAssert(realm != nil);
    FEMRealmStore *store = [[FEMRealmStore alloc] initWithRealm:realm];
    return [self initWithStore:store];
}

@end