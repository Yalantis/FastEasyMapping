//
// Created by zen on 09/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "ChildRealmObject.h"
#import "FEMMapping.h"

@implementation ChildRealmObject
@end

@implementation ChildRealmObject (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:[self className]];
    [mapping addAttributesFromArray:@[@"identifier"]];
    return mapping;
}

@end