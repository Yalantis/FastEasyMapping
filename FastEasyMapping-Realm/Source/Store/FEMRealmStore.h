//
// Created by zen on 01/09/15.
// Copyright (c) 2015 Zen. All rights reserved.
//

@import Foundation;

#import <Realm/Realm.h>
#import <FastEasyMapping/FEMObjectStore.h>

@interface FEMRealmStore : FEMObjectStore

@property (nonatomic, strong, readonly) RLMRealm *realm;

- (instancetype)initWithRealm:(RLMRealm *)realm;

+ (instancetype)storeWithRealm:(RLMRealm *)realm;


@end