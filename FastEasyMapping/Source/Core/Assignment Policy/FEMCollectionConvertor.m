//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMCollectionConvertor.h"

#pragma mark - NSArray

@implementation NSObject (FEMCollectionConvertor)

- (id)fem_convertToClass:(Class)expectedClass {
    NSString *reason = [[NSString alloc] initWithFormat:@"Unsupported class:%@", NSStringFromClass(expectedClass)];
    @throw [NSException exceptionWithName:@"FEMCollectionConvertor" reason:reason userInfo:nil];
}

@end

@implementation NSArray (FEMCollectionConvertor)

- (id)fem_convertToClass:(Class)expectedClass {
    if (expectedClass == self.class) return self;
    if (expectedClass == NSMutableArray.class) return [self mutableCopy];
    if (expectedClass == NSSet.class) return [NSSet setWithArray:self];
    if (expectedClass == NSMutableSet.class) return [NSMutableSet setWithArray:self];
    if (expectedClass == NSOrderedSet.class) return [NSOrderedSet orderedSetWithArray:self];
    if (expectedClass == NSMutableOrderedSet.class) return [NSMutableOrderedSet orderedSetWithArray:self];

    return [super fem_convertToClass:expectedClass];
}

@end

@implementation NSMutableArray (FEMCollectionConvertor)

- (id)fem_convertToClass:(Class)expectedClass {
    if (expectedClass == self.class) return self;
    if (expectedClass == NSArray.class) return [self copy];
    if (expectedClass == NSSet.class) return [NSSet setWithArray:self];
    if (expectedClass == NSMutableSet.class) return [NSMutableSet setWithArray:self];
    if (expectedClass == NSOrderedSet.class) return [NSOrderedSet orderedSetWithArray:self];
    if (expectedClass == NSMutableOrderedSet.class) return [NSMutableOrderedSet orderedSetWithArray:self];

    return [super fem_convertToClass:expectedClass];
}

@end

#pragma mark - NSSet

@implementation NSSet (FEMCollectionConvertor)

- (id)fem_convertToClass:(Class)expectedClass {
    if (expectedClass == self.class) return self;
    if (expectedClass == NSMutableSet.class) return [self mutableCopy];
    if (expectedClass == NSArray.class) return [self allObjects];
    if (expectedClass == NSMutableArray.class) return [[self allObjects] mutableCopy];
    if (expectedClass == NSOrderedSet.class) return [NSOrderedSet orderedSetWithSet:self];
    if (expectedClass == NSMutableOrderedSet.class) return [NSMutableOrderedSet orderedSetWithSet:self];

    return [super fem_convertToClass:expectedClass];
}

@end

@implementation NSMutableSet (FEMCollectionConvertor)

- (id)fem_convertToClass:(Class)expectedClass {
    if (expectedClass == self.class) return self;
    if (expectedClass == NSSet.class) return [self copy];
    if (expectedClass == NSArray.class) return [self allObjects];
    if (expectedClass == NSMutableArray.class) return [[self allObjects] mutableCopy];
    if (expectedClass == NSOrderedSet.class) return [NSOrderedSet orderedSetWithSet:self];
    if (expectedClass == NSMutableOrderedSet.class) return [NSMutableOrderedSet orderedSetWithSet:self];

    return [super fem_convertToClass:expectedClass];
}

@end

#pragma mark - NSOrderedSet

@implementation NSOrderedSet (FEMCollectionConvertor)

- (id)fem_convertToClass:(Class)expectedClass {
    if (expectedClass == self.class) return self;
    if (expectedClass == NSMutableOrderedSet.class) return [self mutableCopy];
    if (expectedClass == NSArray.class) return [self array];
    if (expectedClass == NSMutableArray.class) return [[self array] mutableCopy];
    if (expectedClass == NSSet.class) return [self set];
    if (expectedClass == NSMutableSet.class) return [[self set] mutableCopy];

    return [super fem_convertToClass:expectedClass];
}

@end


@implementation NSMutableOrderedSet (FEMCollectionConvertor)

- (id)fem_convertToClass:(Class)expectedClass {
    if (expectedClass == self.class) return self;
    if (expectedClass == NSOrderedSet.class) return [self copy];
    if (expectedClass == NSArray.class) return [self array];
    if (expectedClass == NSMutableArray.class) return [[self array] mutableCopy];
    if (expectedClass == NSSet.class) return [self set];
    if (expectedClass == NSMutableSet.class) return [[self set] mutableCopy];

    return [super fem_convertToClass:expectedClass];
}

@end