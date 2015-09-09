//
// Created by zen on 09/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "FEMAttribute+Realm.h"

@implementation FEMAttribute (Realm)

+ (instancetype)rlm_mappingOfStringProperty:(NSString *)property toKeyPath:(nullable NSString *)keyPath {
    return [[self alloc] initWithProperty:property keyPath:keyPath map:^id(id value) {
        if ([value isKindOfClass:[NSString class]] && [(NSString *)value length] > 0) {
            return value;
        }
        return @"";
    } reverseMap:^id(id value) {
        if ([(NSString *)value length] > 0) {
            return value;
        }

        return nil;
    }];
}

@end