//
// NSObject+EMKKVC.h 
// EasyMappingKit
//
// Created by dmitriy on 3/4/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import <Foundation/Foundation.h>

@interface NSObject (EMKKVC)

- (void)emk_setValueIfDifferent:(id)value forKey:(NSString *)key;

@end