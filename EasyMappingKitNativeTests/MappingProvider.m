//
//  MappingProvider.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 23/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "MappingProvider.h"
#import "Car.h"
#import "Phone.h"
#import "Person.h"
#import "Address.h"
#import "Native.h"
#import "Plane.h"
#import "Alien.h"
#import "Finger.h"
#import "NativeChild.h"
#import "Cat.h"

#import "EMKObjectMapping.h"
#import "EMKAttributeMapping.h"

@implementation MappingProvider

+ (EMKObjectMapping *)carMapping
{
    return [EMKObjectMapping mappingForClass:[Car class] configuration:^(EMKObjectMapping *mapping) {
        [mapping addAttributeMappingFromArray:@[@"model", @"year"]];
    }];
}

+ (EMKObjectMapping *)carWithRootKeyMapping
{
    return [EMKObjectMapping mappingForClass:[Car class] rootPath:@"car" configuration:^(EMKObjectMapping *mapping) {
        [mapping addAttributeMappingFromArray:@[@"model", @"year"]];
    }];
}

+ (EMKObjectMapping *)carNestedAttributesMapping
{
    return [EMKObjectMapping mappingForClass:[Car class] configuration:^(EMKObjectMapping *mapping) {
        [mapping addAttributeMappingFromArray:@[@"model"]];
        [mapping addAttributeMappingDictionary:@{
            @"information.year" : @"year"
        }];
    }];
}

+ (EMKObjectMapping *)carWithDateMapping
{
    return [EMKObjectMapping mappingForClass:[Car class] configuration:^(EMKObjectMapping *mapping) {
        [mapping addAttributeMappingFromArray:@[@"model", @"year"]];
	    [mapping addAttributeMapping:[EMKAttributeMapping mappingOfProperty:@"createdAt" keyPath:@"created_at" dateFormat:@"yyyy-MM-dd"]];
    }];
}

+ (EMKObjectMapping *)phoneMapping
{
    return [EMKObjectMapping mappingForClass:[Phone class] configuration:^(EMKObjectMapping *mapping) {
        [mapping addAttributeMappingFromArray:@[@"number"]];
        [mapping addAttributeMappingDictionary:@{
            @"ddi" : @"DDI",
            @"ddd" : @"DDD"
         }];
    }];
}

+ (EMKObjectMapping *)personMapping
{
    return [EMKObjectMapping mappingForClass:[Person class] configuration:^(EMKObjectMapping *mapping) {
        NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
        [mapping addAttributeMappingFromArray:@[@"name", @"email"]];
	    [mapping addAttributeMapping:[EMKAttributeMapping mappingOfProperty:@"gender" keyPath:@"gender" map:^id(id value) {
		    return genders[value];
	    } reverseMap:^id(id value) {
		    return [genders allKeysForObject:value].lastObject;
	    }]];

	    [mapping addRelationshipMapping:[self carMapping] forProperty:@"car" keyPath:@"car"];
	    [mapping addToManyRelationshipMapping:[self phoneMapping] forProperty:@"phones" keyPath:@"phones"];
    }];
}

+ (EMKObjectMapping *)personWithCarMapping
{
    return [EMKObjectMapping mappingForClass:[Person class] configuration:^(EMKObjectMapping *mapping) {
        [mapping addAttributeMappingFromArray:@[@"name", @"email"]];
	    [mapping addRelationshipMapping:[self carMapping] forProperty:@"car" keyPath:@"car"];
    }];
}

+ (EMKObjectMapping *)personWithPhonesMapping
{
    return [EMKObjectMapping mappingForClass:[Person class] configuration:^(EMKObjectMapping *mapping) {
        [mapping addAttributeMappingFromArray:@[@"name", @"email"]];
	    [mapping addToManyRelationshipMapping:[self phoneMapping] forProperty:@"phones" keyPath:@"phones"];
    }];
}

+ (EMKObjectMapping *)personWithOnlyValueBlockMapping
{
    return [EMKObjectMapping mappingForClass:[Person class] configuration:^(EMKObjectMapping *mapping) {
        NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
        [mapping addAttributeMappingFromArray:@[@"name", @"email"]];
	    [mapping addAttributeMapping:[EMKAttributeMapping mappingOfProperty:@"gender" keyPath:@"gender" map:^id(id value) {
		    return genders[value];
	    } reverseMap:^id(id value) {
		    return [genders allKeysForObject:value].lastObject;
	    }]];
    }];
}

+ (EMKObjectMapping *)addressMapping
{
    return [EMKObjectMapping mappingForClass:[Address class] configuration:^(EMKObjectMapping *mapping) {
        [mapping addAttributeMappingFromArray:@[@"street"]];
	    [mapping addAttributeMapping:[EMKAttributeMapping mappingOfProperty:@"location" keyPath:@"location" map:^id(id value) {
		    CLLocationDegrees latitudeValue = [[value objectAtIndex:0] doubleValue];
		    CLLocationDegrees longitudeValue = [[value objectAtIndex:1] doubleValue];
		    return [[CLLocation alloc] initWithLatitude:latitudeValue longitude:longitudeValue];
	    } reverseMap:^id(CLLocation *value) {
		    return @[@(value.coordinate.latitude), @(value.coordinate.longitude) ];
	    }]];
    }];
}

+ (EMKObjectMapping *)nativeMapping
{
    return [EMKObjectMapping mappingForClass:[Native class] configuration:^(EMKObjectMapping *mapping) {
        [mapping addAttributeMappingFromArray:@[
         @"charProperty", @"unsignedCharProperty", @"shortProperty", @"unsignedShortProperty", @"intProperty", @"unsignedIntProperty",
         @"integerProperty", @"unsignedIntegerProperty", @"longProperty", @"unsignedLongProperty", @"longLongProperty",
         @"unsignedLongLongProperty", @"floatProperty", @"cgFloatProperty", @"doubleProperty", @"boolProperty"
        ]];
    }];
}

+ (EMKObjectMapping *)nativeMappingWithNullPropertie
{
    return [EMKObjectMapping mappingForClass:[Cat class] configuration:^(EMKObjectMapping *mapping) {
        [mapping addAttributeMappingFromArray:@[ @"age" ]];
    }];
}

+ (EMKObjectMapping *)planeMapping
{
    return [EMKObjectMapping mappingForClass:[Plane class] configuration:^(EMKObjectMapping *mapping) {
	    [mapping addAttributeMappingDictionary:@{@"flightNumber": @"flight_number"}];
	    [mapping addToManyRelationshipMapping:[self personMapping] forProperty:@"persons" keyPath:@"persons"];
    }];
}

+ (EMKObjectMapping *)alienMapping
{
    return [EMKObjectMapping mappingForClass:[Alien class] configuration:^(EMKObjectMapping *mapping) {
        [mapping addAttributeMappingFromArray:@[@"name"]];
	    [mapping addToManyRelationshipMapping:[self fingerMapping] forProperty:@"fingers" keyPath:@"fingers"];
    }];
}

+ (EMKObjectMapping *)fingerMapping
{
    return [EMKObjectMapping mappingForClass:[Finger class] configuration:^(EMKObjectMapping *mapping) {
        [mapping addAttributeMappingFromArray:@[@"name"]];
    }];
}

+ (EMKObjectMapping *)nativeChildMapping
{
    return [EMKObjectMapping mappingForClass:[NativeChild class] configuration:^(EMKObjectMapping *mapping) {
        [mapping addAttributeMappingFromArray:@[@"intProperty", @"boolProperty", @"childProperty"]];
    }];
}

@end
