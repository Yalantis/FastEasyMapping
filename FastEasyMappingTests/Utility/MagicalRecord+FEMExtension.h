// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>

NS_ASSUME_NONNULL_BEGIN

@interface MagicalRecord (FEMExtension)

+ (void)fem_setupTestsSQLiteStore;
+ (void)fem_cleanUp;

@end

NS_ASSUME_NONNULL_END
