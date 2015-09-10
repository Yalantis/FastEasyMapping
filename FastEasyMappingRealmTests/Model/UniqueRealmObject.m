//
// Created by zen on 10/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "UniqueRealmObject.h"

#import <FastEasyMapping/FastEasyMapping.h>

@implementation UniqueRealmObject

+ (NSString *)primaryKey {
    return @"primaryKeyProperty";
}

@end

@implementation UniqueRealmObject (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:[self className]];
    mapping.primaryKey = [self primaryKey];
    [mapping addAttributesFromArray:@[@"primaryKeyProperty"]];

    return mapping;
}

@end