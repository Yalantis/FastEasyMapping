//
// Created by zen on 03/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

@import Foundation;

#import <FastEasyMapping/FEMObjectCache.h>

@class RLMRealm;

NS_ASSUME_NONNULL_BEGIN

@interface FEMObjectCache (Realm)

- (instancetype)initWithMapping:(FEMMapping *)mapping representation:(id)representation realm:(RLMRealm *)realm;

@end

NS_ASSUME_NONNULL_END