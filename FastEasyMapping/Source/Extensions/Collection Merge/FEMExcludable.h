//
// Created by zen on 19/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

@import Foundation;

@protocol FEMExcludable <NSObject>

- (id<NSFastEnumeration>)collectionByExcludingObjects:(id)objects;

@end

@interface NSArray (FEMExceptable) <FEMExcludable>
@end

@interface NSSet (FEMExceptable) <FEMExcludable>
@end

@interface NSOrderedSet (FEMExceptable) <FEMExcludable>
@end