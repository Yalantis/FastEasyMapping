//
//  EMKTransformer.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 25/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMKAttributeMapping.h"

extern NSString * const EKRailsDefaultDatetimeFormat;
extern NSString * const EKBrazilianDefaultDateFormat;

@interface EMKTransformer : NSObject

+ (NSDate *)transformString:(NSString *)stringToBeTransformed withDateFormat:(NSString *)dateFormat;
+ (NSString *)transformDate:(NSDate *)dateToBeTransformed withDateFormat:(NSString *)dateFormat;

@end
