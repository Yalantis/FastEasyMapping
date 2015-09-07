//
// Created by zen on 03/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

@import Foundation;

#import <FastEasyMapping/FEMDeserializer.h>

@class RLMRealm;

NS_ASSUME_NONNULL_BEGIN

@interface FEMDeserializer (Realm)

- (instancetype)initWithRealm:(RLMRealm *)realm;

@end

NS_ASSUME_NONNULL_END