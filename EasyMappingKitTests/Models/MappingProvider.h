//
//  MappingProvider.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 23/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMKManagedObjectMapping;

@interface MappingProvider : NSObject

+ (EMKManagedObjectMapping *)carMapping;
+ (EMKManagedObjectMapping *)carWithRootKeyMapping;
+ (EMKManagedObjectMapping *)carNestedAttributesMapping;
+ (EMKManagedObjectMapping *)carWithDateMapping;
+ (EMKManagedObjectMapping *)phoneMapping;
+ (EMKManagedObjectMapping *)personMapping;
+ (EMKManagedObjectMapping *)personWithCarMapping;
+ (EMKManagedObjectMapping *)personWithPhonesMapping;
+ (EMKManagedObjectMapping *)personWithOnlyValueBlockMapping;

@end
