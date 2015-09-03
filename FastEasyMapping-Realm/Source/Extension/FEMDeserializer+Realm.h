//
// Created by zen on 03/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

@import Foundation;

#import <FastEasyMapping/FEMDeserializer.h>

@class RLMRealm;

@interface FEMDeserializer (Realm)

- (nonnull instancetype)initWithRealm:(RLMRealm *)realm;

@end