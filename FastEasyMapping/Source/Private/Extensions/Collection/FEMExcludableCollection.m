// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMExcludableCollection.h"

@implementation NSArray (FEMExcludableCollection)

- (NSArray *)collectionByExcludingObjects:(NSArray *)array {
    return [[self mutableCopy] collectionByExcludingObjects:array];
}

@end

@implementation NSMutableArray (FEMExcludableCollection)

- (NSArray *)collectionByExcludingObjects:(NSArray *)objects {
    [self removeObjectsInArray:objects];

    return self;
}

@end

@implementation NSSet (FEMExcludableCollection)

- (NSSet *)collectionByExcludingObjects:(id)set {
    return [[self mutableCopy] collectionByExcludingObjects:set];
}

@end

@implementation NSMutableSet (FEMExcludableCollection)

- (NSSet *)collectionByExcludingObjects:(NSSet *)set {
    [self minusSet:set];

    return self;
}

@end

@implementation NSOrderedSet (FEMExcludableCollection)

- (NSOrderedSet *)collectionByExcludingObjects:(NSOrderedSet *)objects {
    return [[self mutableCopy] collectionByExcludingObjects:objects];
}

@end

@implementation NSMutableOrderedSet (FEMExcludableCollection)

- (NSOrderedSet *)collectionByExcludingObjects:(NSOrderedSet *)objects {
    [self minusOrderedSet:objects];

    return self;
}

@end