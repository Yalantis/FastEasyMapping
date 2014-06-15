//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "NSOrderedSet+FEMExtension.h"

@implementation NSOrderedSet (FEMExtension)

- (instancetype)fem_merge:(NSOrderedSet *)orderedSet {
    return [[self mutableCopy] fem_merge:orderedSet];
}

- (instancetype)fem_except:(NSOrderedSet *)orderedSet {
    return [[self mutableCopy] fem_except:orderedSet];
}

@end

@implementation NSMutableOrderedSet (FEMMerge)

- (instancetype)fem_merge:(NSOrderedSet *)orderedSet {
    [self unionOrderedSet:orderedSet];

    return self;
}

- (id)fem_except:(NSOrderedSet *)orderedSet {
    [self minusOrderedSet:orderedSet];

    return self;
}

@end