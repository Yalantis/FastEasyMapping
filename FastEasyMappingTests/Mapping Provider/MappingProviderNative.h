// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMObjectMapping;

@interface MappingProviderNative : NSObject

+ (FEMObjectMapping *)carMapping;
+ (FEMObjectMapping *)carWithRootKeyMapping;
+ (FEMObjectMapping *)carNestedAttributesMapping;
+ (FEMObjectMapping *)carWithDateMapping;
+ (FEMObjectMapping *)phoneMapping;
+ (FEMObjectMapping *)personMapping;
+ (FEMObjectMapping *)personWithCarMapping;
+ (FEMObjectMapping *)personWithPhonesMapping;
+ (FEMObjectMapping *)personWithOnlyValueBlockMapping;
+ (FEMObjectMapping *)addressMapping;
+ (FEMObjectMapping *)fingerMapping;
+ (FEMObjectMapping *)nativeMapping;
+ (FEMObjectMapping *)nativeMappingWithNullPropertie;
+ (FEMObjectMapping *)planeMapping;
+ (FEMObjectMapping *)alienMapping;
+ (FEMObjectMapping *)nativeChildMapping;

@end
