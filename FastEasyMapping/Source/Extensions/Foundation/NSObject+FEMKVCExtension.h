// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@interface NSObject (FEMKVCExtension)

- (void)fem_setValueIfDifferent:(id)value forKey:(NSString *)key;

- (void)fem_willChangeFromValue:(id)fromValue toValue:(id)value forKey:(NSString *)key;

@end