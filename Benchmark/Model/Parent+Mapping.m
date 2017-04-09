
#import "Parent+Mapping.h"
#import "Child+Mapping.h"

@import FastEasyMapping;

@implementation Parent (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:NSStringFromClass(self)];
    mapping.primaryKey = @"int32Value";
    [mapping addAttributesFromArray:[self entity].attributeKeys];

    return mapping;
}

+ (FEMMapping *)childrenMappingWithPolicy:(FEMAssignmentPolicy)policy {
    FEMMapping *mapping = [self defaultMapping];
    
    FEMRelationship *children = [[FEMRelationship alloc] initWithProperty:@"children" keyPath:@"children" mapping:[Child defaultMapping]];
    children.toMany = YES;
    children.assignmentPolicy = policy;
    [mapping addRelationship:children];
    
    return mapping;
}

@end
