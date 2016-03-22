// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMMapping;

@interface MappingProviderNative : NSObject

+ (FEMMapping *)carMapping;
+ (FEMMapping *)carWithRootKeyMapping;
+ (FEMMapping *)carNestedAttributesMapping;
+ (FEMMapping *)carWithDateMapping;
+ (FEMMapping *)phoneMapping;
+ (FEMMapping *)personMapping;
+ (FEMMapping *)personWithCarMapping;
+ (FEMMapping *)personWithCarPKMapping;

+ (FEMMapping *)personWithPhonesMapping;
+ (FEMMapping *)personWithOnlyValueBlockMapping;
+ (FEMMapping *)addressMapping;
+ (FEMMapping *)fingerMapping;
+ (FEMMapping *)nativeMapping;
+ (FEMMapping *)nativeMappingWithNullPropertie;
+ (FEMMapping *)planeMapping;
+ (FEMMapping *)alienMapping;
+ (FEMMapping *)nativeChildMapping;
+ (FEMMapping *)personWithRecursiveFriendsMapping;
+ (FEMMapping *)personWithRecursivePartnerMapping;

@end
