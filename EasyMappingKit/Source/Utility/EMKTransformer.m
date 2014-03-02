//
//  EMKTransformer.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 25/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "EMKTransformer.h"

NSString * const EKRailsDefaultDatetimeFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
NSString * const EKBrazilianDefaultDateFormat = @"dd/MM/yyyy";

NSString * const kDateFormatterKey = @"SCDateFormatter";

@implementation EMKTransformer

+ (NSDate *)transformString:(NSString *)stringToBeTransformed withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *format = [self dateFormatter];
    format.dateFormat = dateFormat;
    return [format dateFromString:stringToBeTransformed];
}

+ (NSString *)transformDate:(NSDate *)dateToBeTransformed withDateFormat:(NSString *)dateFormat {
    NSDateFormatter *format = [self dateFormatter];
    format.dateFormat = dateFormat;
    return [format stringFromDate:dateToBeTransformed];
}

+ (NSDateFormatter *)dateFormatter
{
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:kDateFormatterKey];
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [dictionary setObject:dateFormatter forKey:kDateFormatterKey];
    }
    return dateFormatter;
}

@end
