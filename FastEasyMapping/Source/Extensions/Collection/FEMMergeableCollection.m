// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMMergeableCollection.h"

@implementation NSArray (FEMMergeableCollection)

- (NSArray *)collectionByMergingObjects:(NSArray *)array {
    return [[self mutableCopy] collectionByMergingObjects:array];
}

@end

@implementation NSMutableArray (FEMMergeableCollection)

- (NSArray *)collectionByMergingObjects:(NSArray *)array {
    if (array.count == 0) return self;

    NSMutableSet *appendingObjectsSet = [[NSMutableSet alloc] initWithArray:array];
    [appendingObjectsSet minusSet:[NSSet setWithArray:self]];

    [self addObjectsFromArray:[appendingObjectsSet allObjects]];

    return self;
}

@end

@implementation NSSet (FEMMergeableCollection)

- (NSSet *)collectionByMergingObjects:(NSSet *)set {
    return [[self mutableCopy] collectionByMergingObjects:set];
}

@end

@implementation NSMutableSet (FEMMergeableCollection)

- (NSSet *)collectionByMergingObjects:(NSSet *)set {
    [self unionSet:set];

    return self;
}

@end

@implementation NSOrderedSet (FEMMergeableCollection)

- (NSOrderedSet *)collectionByMergingObjects:(NSOrderedSet *)orderedSet {
    return [[self mutableCopy] collectionByMergingObjects:orderedSet];
}

@end

@implementation NSMutableOrderedSet (FEMMergeableCollection)

- (NSOrderedSet *)collectionByMergingObjects:(NSOrderedSet *)orderedSet {
    [self unionOrderedSet:orderedSet];

    return self;
}

@end