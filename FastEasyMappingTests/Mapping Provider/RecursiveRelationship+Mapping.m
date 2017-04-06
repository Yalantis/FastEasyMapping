
#import "RecursiveRelationship+Mapping.h"
#import "FEMMapping.h"

@implementation RecursiveRelationship (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:NSStringFromClass(self)];
    mapping.primaryKey = @"primaryKey";
    [mapping addAttributesFromArray:@[@"primaryKey"]];

    [mapping addRecursiveRelationshipMappingForProperty:@"child" keypath:@"child"];

    return mapping;
}

@end