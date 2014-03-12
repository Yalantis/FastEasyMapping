//
//  EMKTransformer.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 25/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMKAttributeMapping.h"

extern NSString * const EMKRailsDefaultDatetimeFormat;
extern NSString * const EMKBrazilianDefaultDateFormat;

@interface EMKTransformer : NSObject

+ (NSDate *)transformString:(NSString *)stringToBeTransformed withDateFormat:(NSString *)dateFormat;
+ (NSString *)transformDate:(NSDate *)dateToBeTransformed withDateFormat:(NSString *)dateFormat;

@end
