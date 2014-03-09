//
//  MappingProviderNative.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 23/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMKObjectMapping;

@interface MappingProviderNative : NSObject

+ (EMKObjectMapping *)carMapping;
+ (EMKObjectMapping *)carWithRootKeyMapping;
+ (EMKObjectMapping *)carNestedAttributesMapping;
+ (EMKObjectMapping *)carWithDateMapping;
+ (EMKObjectMapping *)phoneMapping;
+ (EMKObjectMapping *)personMapping;
+ (EMKObjectMapping *)personWithCarMapping;
+ (EMKObjectMapping *)personWithPhonesMapping;
+ (EMKObjectMapping *)personWithOnlyValueBlockMapping;
+ (EMKObjectMapping *)addressMapping;
+ (EMKObjectMapping *)fingerMapping;
+ (EMKObjectMapping *)nativeMapping;
+ (EMKObjectMapping *)nativeMappingWithNullPropertie;
+ (EMKObjectMapping *)planeMapping;
+ (EMKObjectMapping *)alienMapping;
+ (EMKObjectMapping *)nativeChildMapping;

@end
