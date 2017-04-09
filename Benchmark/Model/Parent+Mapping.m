
#import "Parent+Mapping.h"

@import FastEasyMapping;

@implementation Parent (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:[self entity].name];
    mapping.primaryKey = @"int32Value";
    [mapping addAttributesFromArray:[self entity].attributeKeys];

    return mapping;
}

@end
