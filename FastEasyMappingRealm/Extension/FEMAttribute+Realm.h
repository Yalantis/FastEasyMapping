//
// Created by zen on 09/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

@import Foundation;

#import <FastEasyMapping/FEMAttribute.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEMAttribute (Realm)

+ (instancetype)rlm_mappingOfStringProperty:(NSString *)property toKeyPath:(nullable NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END