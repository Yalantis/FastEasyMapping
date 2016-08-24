// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "MappingProviderNative.h"
#import "CarNative.h"
#import "PhoneNative.h"
#import "PersonNative.h"
#import "AddressNative.h"
#import "Native.h"
#import "PlaneNative.h"
#import "AlienNative.h"
#import "FingerNative.h"
#import "NativeChild.h"
#import "CatNative.h"

#import "FEMMapping.h"
#import "FEMAttribute.h"
#import "FEMObjectMapping.h"

@implementation MappingProviderNative

+ (FEMMapping *)carMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[CarNative class]];
    [mapping addAttributesFromArray:@[@"model", @"year"]];

    return mapping;
}

+ (FEMMapping *)carWithRootKeyMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[CarNative class] rootPath:@"car"];
    [mapping addAttributesFromArray:@[@"model", @"year"]];

    return mapping;
}

+ (FEMMapping *)carNestedAttributesMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[CarNative class]];
    [mapping addAttributesFromArray:@[@"model"]];
    [mapping addAttributesFromDictionary:@{@"year" : @"information.year"}];

    return mapping;
}

+ (FEMMapping *)carWithDateMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[CarNative class]];
    [mapping addAttributesFromArray:@[@"model", @"year"]];
    FEMAttribute *createdAtAttribute = [FEMAttribute mappingOfProperty:@"createdAt" toKeyPath:@"created_at" dateFormat:@"yyyy-MM-dd"];
    [mapping addAttribute:createdAtAttribute];

    return mapping;
}

+ (FEMMapping *)phoneMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[PhoneNative class]];
    [mapping addAttributesFromArray:@[@"number"]];
    [mapping addAttributesFromDictionary:@{@"DDI" : @"ddi", @"DDD" : @"ddd"}];

    return mapping;
}

+ (FEMMapping *)personMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[PersonNative class]];
    [mapping addAttributesFromArray:@[@"name", @"email"]];

    NSDictionary *genders = @{@"male" : @(GenderMale), @"female" : @(GenderFemale)};
    FEMAttribute *genderAttribute = [[FEMAttribute alloc] initWithProperty:@"gender" keyPath:@"gender" map:^id(id value) {
        return genders[value];
    } reverseMap:^id(id value) {
        return [genders allKeysForObject:value].lastObject;
    }];
    [mapping addAttribute:genderAttribute];

    [mapping addRelationshipMapping:[self carMapping] forProperty:@"car" keyPath:@"car"];
    [mapping addToManyRelationshipMapping:[self phoneMapping] forProperty:@"phones" keyPath:@"phones"];

    return mapping;
}

+ (FEMMapping *)personWithCarMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[PersonNative class]];
    [mapping addAttributesFromArray:@[@"name", @"email"]];
    [mapping addRelationshipMapping:[self carMapping] forProperty:@"car" keyPath:@"car"];

    return mapping;
}

+ (FEMMapping *)personWithCarPKMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[PersonNative class]];
    [mapping addAttributesFromArray:@[@"name"]];
    
    FEMMapping *carMapping = [[FEMMapping alloc] initWithObjectClass:[CarNative class]];
    carMapping.primaryKey = @"model";
    [carMapping addAttributeWithProperty:@"model" keyPath:nil];

    [mapping addRelationshipMapping:carMapping forProperty:@"car" keyPath:@"car"];
    
    return mapping;
}

+ (FEMMapping *)personWithPhonesMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[PersonNative class]];
    [mapping addAttributesFromArray:@[@"name", @"email"]];
    [mapping addToManyRelationshipMapping:[self phoneMapping] forProperty:@"phones" keyPath:@"phones"];

    return mapping;
}

+ (FEMMapping *)personWithOnlyValueBlockMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[PersonNative class]];
    [mapping addAttributesFromArray:@[@"name", @"email"]];

    NSDictionary *genders = @{@"male" : @(GenderMale), @"female" : @(GenderFemale)};
    FEMAttribute *genderAttribute = [[FEMAttribute alloc] initWithProperty:@"gender" keyPath:@"gender" map:^id(id value) {
        return genders[value];
    } reverseMap:^id(id value) {
        return [genders allKeysForObject:value].lastObject;
    }];
    [mapping addAttribute:genderAttribute];

    return mapping;
}

+ (FEMMapping *)personWithRecursiveFriendsMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[PersonNative class]];
    [mapping addAttributesFromArray:@[@"name", @"email"]];
    [mapping addRecursiveToManyRelationshipForProperty:@"friends" keypath:@"friends"];
    
    return mapping;
}

+ (FEMMapping *)personWithRecursivePartnerMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[PersonNative class]];
    [mapping addAttributesFromArray:@[@"name", @"email"]];
    [mapping addRecursiveRelationshipMappingForProperty:@"partner" keypath:@"partner"];
    
    return mapping;
}

+ (FEMMapping *)addressMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[AddressNative class]];
    [mapping addAttributesFromArray:@[@"street"]];

    FEMAttribute *locationAttribute = [[FEMAttribute alloc] initWithProperty:@"location" keyPath:@"location" map:^id(id value) {
        CLLocationDegrees latitudeValue = [[value objectAtIndex:0] doubleValue];
        CLLocationDegrees longitudeValue = [[value objectAtIndex:1] doubleValue];
        return [[CLLocation alloc] initWithLatitude:latitudeValue longitude:longitudeValue];
    } reverseMap:^id(CLLocation *value) {
        return @[@(value.coordinate.latitude), @(value.coordinate.longitude)];
    }];
    [mapping addAttribute:locationAttribute];

    return mapping;
}

+ (FEMMapping *)nativeMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[Native class]];
    [mapping addAttributesFromArray:@[
        @"charProperty",
        @"unsignedCharProperty",
        @"shortProperty",
        @"unsignedShortProperty",
        @"intProperty",
        @"unsignedIntProperty",
        @"integerProperty",
        @"unsignedIntegerProperty",
        @"longProperty",
        @"unsignedLongProperty",
        @"longLongProperty",
        @"unsignedLongLongProperty",
        @"floatProperty",
        @"cgFloatProperty",
        @"doubleProperty",
        @"boolProperty"
    ]];

    return mapping;
}

+ (FEMMapping *)nativeMappingWithNullPropertie {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[CatNative class]];
    [mapping addAttributesFromArray:@[@"age"]];

    return mapping;
}

+ (FEMMapping *)planeMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[PlaneNative class]];
    [mapping addAttributesFromDictionary:@{@"flightNumber" : @"flight_number"}];
    [mapping addToManyRelationshipMapping:[self personMapping] forProperty:@"persons" keyPath:@"persons"];

    return mapping;
}

+ (FEMMapping *)alienMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[AlienNative class]];
    [mapping addAttributesFromArray:@[@"name"]];
    [mapping addToManyRelationshipMapping:[self fingerMapping] forProperty:@"fingers" keyPath:@"fingers"];

    return mapping;
}

+ (FEMMapping *)fingerMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[FingerNative class]];
    [mapping addAttributesFromArray:@[@"name"]];

    return mapping;
}

+ (FEMMapping *)nativeChildMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[NativeChild class]];
    [mapping addAttributesFromArray:@[@"intProperty", @"boolProperty", @"childProperty"]];

    return mapping;
}

@end
