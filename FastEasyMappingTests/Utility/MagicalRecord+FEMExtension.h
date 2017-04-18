
#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>

@interface MagicalRecord (FEMExtension)

+ (void)fem_setupTestsSQLiteStore;
+ (void)fem_cleanUp;

@end
