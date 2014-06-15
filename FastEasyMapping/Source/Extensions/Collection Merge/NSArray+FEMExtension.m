//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "NSArray+FEMExtension.h"

@implementation NSArray (FEMExtension)

- (instancetype)fem_merge:(NSArray *)array {
    return [[self mutableCopy] fem_merge:array];
}

- (instancetype)fem_except:(NSArray *)array {
    return [[self mutableCopy] fem_except:array];
}

@end

@implementation NSMutableArray (FEMMerge)

- (id)fem_merge:(NSArray *)array {
    if (array.count == 0) return self;

    NSMutableSet *appendingObjectsSet = [[NSMutableSet alloc] initWithArray:array];
    [appendingObjectsSet minusSet:[NSSet setWithArray:self]];

    [self addObjectsFromArray:[appendingObjectsSet allObjects]];

    return self;
}

- (id)fem_except:(NSArray *)array {
    [self removeObjectsInArray:array];

    return self;
}

@end