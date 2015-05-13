//
// Created by zen on 12/05/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FEMProperty <NSObject>

@property (nonatomic, copy) NSString *property;
@property (nonatomic, copy) NSString *keyPath;

@end