//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

@import Foundation;

@interface NSArray (FEMCollectionConvertor)

- (id)fem_convertToClass:(Class)expectedClass;

@end

@interface NSSet (FEMCollectionConvertor)

- (id)fem_convertToClass:(Class)expectedClass;

@end

@interface NSOrderedSet (FEMCollectionConvertor)

- (id)fem_convertToClass:(Class)expectedClass;

@end