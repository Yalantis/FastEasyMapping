// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "NSObject+FEMKVCExtension.h"

@implementation NSObject (FEMKVCExtension)

- (void)fem_setValueIfDifferent:(id)value forKey:(NSString *)key {
	id _value = [self valueForKey:key];

	if (_value != value && ![_value isEqual:value]) {
        [self fem_willChangeFromValue:_value toValue:value forKey:key];
		[self setValue:value forKey:key];
	}
}

- (void)fem_willChangeFromValue:(id)fromValue toValue:(id)value forKey:(NSString *)key {
}

@end