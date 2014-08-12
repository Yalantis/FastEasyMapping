//
// Created by zen on 19/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

@import Foundation;

@protocol FEMExcludable <NSObject>
@required 
- (id<NSFastEnumeration>)collectionByExcludingObjects:(id)objects;

@end

@interface NSArray (FEMExcludable) <FEMExcludable>
@end

@interface NSSet (FEMExcludable) <FEMExcludable>
@end

@interface NSOrderedSet (FEMExcludable) <FEMExcludable>
@end