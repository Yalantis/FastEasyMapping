//
// Created by zen on 01/09/15.
// Copyright (c) 2015 Zen. All rights reserved.
//

@import Foundation;

#import <FastEasyMapping/FEMObjectStore.h>

@class RLMRealm;

NS_ASSUME_NONNULL_BEGIN

@interface FEMRealmStore : FEMObjectStore

@property (nonatomic, strong, readonly) RLMRealm *realm;

- (instancetype)initWithRealm:(RLMRealm *)realm;

@end

NS_ASSUME_NONNULL_END