
#import "Child+Mapping.h"

@import FastEasyMapping;

@implementation Child (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:[self entity].name];
    mapping.primaryKey = @"int32Value";
    [mapping addAttributesFromArray:[self entity].attributeKeys];
    
    return mapping;
}

@end
