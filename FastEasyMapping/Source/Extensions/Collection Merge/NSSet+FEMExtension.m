//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "NSSet+FEMExtension.h"

@implementation NSSet (FEMExtension)

- (instancetype)fem_merge:(NSSet *)set {
    return [[self mutableCopy] fem_merge:set];
}

@end

@implementation NSMutableSet (FEMMerge)

- (id)fem_merge:(NSSet *)set {
    [self unionSet:set];

    return self;
}

@end