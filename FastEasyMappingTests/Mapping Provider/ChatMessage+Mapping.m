// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "ChatMessage+Mapping.h"

@import FastEasyMapping;

@implementation ChatMessage (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:NSStringFromClass(self)];
    mapping.primaryKey = @"primaryKey";
    [mapping addAttributesFromArray:@[@"primaryKey"]];
    return mapping;
}

@end
