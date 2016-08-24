// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (FEMKVCExtension)

- (void)fem_setValueIfDifferent:(nullable id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END