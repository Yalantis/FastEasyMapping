//
// Created by zen on 19/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMExcludable.h"


@implementation NSArray (FEMExcludable)

- (id<NSFastEnumeration>)collectionByExcludingObjects:(id)array {
    return [[self mutableCopy] collectionByExcludingObjects:array];
}

@end

@implementation NSMutableArray (FEMExcludable)

- (instancetype)collectionByExcludingObjects:(NSArray *)objects {
    [self removeObjectsInArray:objects];

    return self;
}

@end

@implementation NSSet (FEMExcludable)

- (id<NSFastEnumeration>)collectionByExcludingObjects:(id)set {
    return [[self mutableCopy] collectionByExcludingObjects:set];
}

@end

@implementation NSMutableSet (FEMExcludable)

- (id<NSFastEnumeration>)collectionByExcludingObjects:(NSSet *)set {
    [self minusSet:set];

    return self;
}

@end

@implementation NSOrderedSet (FEMExcludable)

- (id<NSFastEnumeration>)collectionByExcludingObjects:(id)orderedSet {
    return [[self mutableCopy] collectionByExcludingObjects:orderedSet];
}

@end

@implementation NSMutableOrderedSet (FEMExcludable)

- (id<NSFastEnumeration>)collectionByExcludingObjects:(NSOrderedSet *)orderedSet {
    [self minusOrderedSet:orderedSet];

    return self;
}

@end