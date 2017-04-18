// For License please refer to LICENSE file in the root of FastEasyMapping project

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
