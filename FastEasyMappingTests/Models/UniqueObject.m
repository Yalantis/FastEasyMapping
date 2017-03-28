//
// Created by zen on 11/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "UniqueObject.h"
#import "FEMMapping.h"

@implementation UniqueObject {

}
@end

@implementation UniqueObject (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:self];
    [mapping addAttributesFromArray:@[@"integerPrimaryKey", @"stringPrimaryKey"]];
    return mapping;
}

@end