//
// Created by zen on 12/05/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN id FEMRepresentationRootForKeyPath(id representation, NSString *keyPath);

@class FEMMapping;

FOUNDATION_EXTERN NSDictionary *FEMRepresentationCollectPresentedPrimaryKeys(id representation, FEMMapping *mapping);