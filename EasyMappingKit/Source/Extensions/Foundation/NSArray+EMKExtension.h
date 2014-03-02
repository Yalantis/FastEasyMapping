//
//  NSArray+EMKExtension.h
//  EasyMappingCoreDataExample
//
//  Created by Lucas Medeiros on 2/24/14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSArray (EMKExtension)

- (id)ek_propertyRepresentation:(objc_property_t)property;

@end