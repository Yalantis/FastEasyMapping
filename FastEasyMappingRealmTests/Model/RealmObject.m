//
// Created by zen on 08/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "RealmObject.h"
#import "FEMMapping.h"

@implementation RealmObject

+ (NSDictionary *)defaultPropertyValues {
    return @{
        @"stringProperty": @"",
        @"dateProperty": [NSDate dateWithTimeIntervalSince1970:0.0],
        @"dataProperty": [NSData data]
    };
}

@end

@implementation RealmObject (Mapping)

+ (FEMMapping *)supportedTypesMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:[self className]];
    [mapping addAttributesFromArray:@[
        @"boolProperty",
        @"booleanProperty",
        @"intProperty",
        @"integerProperty",
        @"longProperty",
        @"longLongProperty",
        @"floatProperty",
        @"doubleProperty",
        @"cgFloatProperty",
        @"stringProperty"
    ]];

    [mapping addAttribute:[FEMAttribute mappingOfProperty:@"dateProperty" toKeyPath:@"dateProperty" dateFormat:@"YYYY-mm-dd'T'HH:mm:ssZZZZ"]];
    [mapping addAttribute:[FEMAttribute mappingOfProperty:@"dataProperty" toKeyPath:@"dataProperty" map:^id(id value) {
        if ([value isKindOfClass:[NSString class]]) {
            return [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding];
        }
        return [NSData data];
    } reverseMap:^id(id value) {
        return [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
    }]];

    return mapping;
}

+ (FEMMapping *)supportedNullableTypesMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:[self className]];
    [mapping addAttributesFromArray:@[
        @"boolProperty",
        @"booleanProperty",
        @"intProperty",
        @"integerProperty",
        @"longProperty",
        @"longLongProperty",
        @"floatProperty",
        @"doubleProperty",
        @"cgFloatProperty",
    ]];

    return mapping;
}

@end