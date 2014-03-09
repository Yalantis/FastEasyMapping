//
//  MappingProvider.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 23/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyMapping.h"

@interface MappingProvider : NSObject

+ (EKObjectMapping *)carMapping;
+ (EKObjectMapping *)carWithRootKeyMapping;
+ (EKObjectMapping *)carNestedAttributesMapping;
+ (EKObjectMapping *)carWithDateMapping;
+ (EKObjectMapping *)phoneMapping;
+ (EKObjectMapping *)personMapping;
+ (EKObjectMapping *)personWithCarMapping;
+ (EKObjectMapping *)personWithPhonesMapping;
+ (EKObjectMapping *)personWithOnlyValueBlockMapping;
+ (EKObjectMapping *)addressMapping;
+ (EKObjectMapping *)fingerMapping;
+ (EKObjectMapping *)nativeMapping;
+ (EKObjectMapping *)nativeMappingWithNullPropertie;
+ (EKObjectMapping *)planeMapping;
+ (EKObjectMapping *)alienMapping;
+ (EKObjectMapping *)nativeChildMapping;

@end
