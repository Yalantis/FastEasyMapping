// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMManagedObjectMapping;

@interface MappingProvider : NSObject

+ (FEMManagedObjectMapping *)carMappingWithPrimaryKey;
+ (FEMManagedObjectMapping *)carMapping;
+ (FEMManagedObjectMapping *)carWithRootKeyMapping;
+ (FEMManagedObjectMapping *)carNestedAttributesMapping;
+ (FEMManagedObjectMapping *)carWithDateMapping;
+ (FEMManagedObjectMapping *)phoneMapping;
+ (FEMManagedObjectMapping *)personMapping;

+ (FEMManagedObjectMapping *)personWithPhoneMapping;
+ (FEMManagedObjectMapping *)personWithCarMapping;

@end
