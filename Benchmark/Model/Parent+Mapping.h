
#import <Foundation/Foundation.h>
#import "Parent+CoreDataClass.h"

@class FEMMapping;

@interface Parent (Mapping)

+ (FEMMapping *)defaultMapping;

@end
