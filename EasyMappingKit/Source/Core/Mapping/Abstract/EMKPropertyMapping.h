//
// EMKPropertyMapping.h 
// EasyMappingKit
//
// Created by dmitriy on 3/2/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import <Foundation/Foundation.h>

@protocol EMKPropertyMapping <NSObject>

@property (nonatomic, copy, readonly) NSString *property;
@property (nonatomic, copy) NSString *keyPath;

@end