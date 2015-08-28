//
// Created by zen on 14/05/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

@import Foundation;

@class FEMMapping;
@class FEMAttribute;

FOUNDATION_EXTERN void FEMMappingApply(FEMMapping *mapping, void (^apply)(FEMMapping *object));
FOUNDATION_EXTERN NSSet * FEMMappingCollectUsedEntityNames(FEMMapping *mapping);

FOUNDATION_EXTERN id FEMAttributeMappedValueFromRepresentation(FEMAttribute *attribute, id representation);