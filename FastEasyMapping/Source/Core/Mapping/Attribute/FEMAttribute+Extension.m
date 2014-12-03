// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMAttribute+Extension.h"
#import "FEMTypeIntrospection.h"
#import "NSObject+FEMKVCExtension.h"

@implementation FEMAttribute (Extension)

- (id)mappedValueFromRepresentation:(id)representation {
	id value = self.keyPath ? [representation valueForKeyPath:self.keyPath] : representation;
    
	return [self mapValue:value];
}

- (void)setMappedValueToObject:(id)object fromRepresentation:(id)representation {
	id value = [self mappedValueFromRepresentation:representation];
	if (value == NSNull.null) {
		if (!FEMObjectPropertyTypeIsScalar(object, self.property)) {
			[object setValue:nil forKey:self.property];
		}
	} else if (value) {
        [object fem_setValueIfDifferent:value forKey:self.property];
	}
}

@end