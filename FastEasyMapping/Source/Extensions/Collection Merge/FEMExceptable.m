//
// Created by zen on 19/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMExcludable.h"


@implementation NSArray (FEMExceptable)

- (id<NSFastEnumeration>)collectionByExcludingObjects:(id)array {
    return [[self mutableCopy] collectionByExcludingObjects:array];
}

@end

@implementation NSMutableArray (FEMExceptable)

- (instancetype)collectionByExcludingObjects:(NSArray *)objects {
    [self removeObjectsInArray:objects];

    return self;
}

@end

@implementation NSSet (FEMExceptable)

- (id<NSFastEnumeration>)collectionByExcludingObjects:(id)set {
    return [[self mutableCopy] collectionByExcludingObjects:set];
}

@end

@implementation NSMutableSet (FEMExceptable)

- (id<NSFastEnumeration>)collectionByExcludingObjects:(NSSet *)set {
    [self minusSet:set];

    return self;
}

@end

@implementation NSOrderedSet (FEMExceptable)

- (id<NSFastEnumeration>)collectionByExcludingObjects:(id)orderedSet {
    return [[self mutableCopy] collectionByExcludingObjects:orderedSet];
}

@end

@implementation NSMutableOrderedSet (FEMExceptable)

- (id<NSFastEnumeration>)collectionByExcludingObjects:(NSOrderedSet *)orderedSet {
    [self minusOrderedSet:orderedSet];

    return self;
}

@end