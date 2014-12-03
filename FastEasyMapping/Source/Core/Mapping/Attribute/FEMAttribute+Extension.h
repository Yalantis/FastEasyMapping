// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>
#import "FEMAttribute.h"

@interface FEMAttribute (Extension)

- (id)mappedValueFromRepresentation:(id)representation;
- (void)setMappedValueToObject:(id)object fromRepresentation:(id)representation;

@end