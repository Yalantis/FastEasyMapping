//
//  EMKPropertyHelper.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 26/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMKPropertyHelper : NSObject

+ (id)performSelector:(SEL)selector onObject:(id)object;
+ (id)performNativeSelector:(SEL)selector onObject:(id)object;
+ (BOOL)propertyNameIsNative:(NSString *)propertyName fromObject:(id)object;

@end
