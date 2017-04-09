
#import <Foundation/Foundation.h>
#import "Parent+CoreDataClass.h"

@import FastEasyMapping;

@interface Parent (Mapping)

+ (FEMMapping *)defaultMapping;
+ (FEMMapping *)childrenMappingWithPolicy:(FEMAssignmentPolicy)policy;


@end
