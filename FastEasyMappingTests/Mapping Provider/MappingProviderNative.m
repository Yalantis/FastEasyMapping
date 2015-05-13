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
	return [FEMMapping mappingForClass:[CarNative class] configuration:^(FEMMapping *mapping) {
        [mapping addAttributesFromArray:@[@"model", @"year"]];
	}];
}

+ (FEMMapping *)carWithRootKeyMapping {
	return [FEMMapping mappingForClass:[CarNative class]
	                                rootPath:@"car"
			                   configuration:^(FEMMapping *mapping) {
                                   [mapping addAttributesFromArray:@[@"model", @"year"]];
			                   }];
}

+ (FEMMapping *)carNestedAttributesMapping {
	return [FEMMapping mappingForClass:[CarNative class] configuration:^(FEMMapping *mapping) {
        [mapping addAttributesFromArray:@[@"model"]];
        [mapping addAttributesFromDictionary:@{
            @"year" : @"information.year"
        }];
	}];
}

+ (FEMMapping *)carWithDateMapping {
	return [FEMMapping mappingForClass:[CarNative class] configuration:^(FEMMapping *mapping) {
        [mapping addAttributesFromArray:@[@"model", @"year"]];
        [mapping addAttribute:[FEMAttribute mappingOfProperty:@"createdAt"
                                                    toKeyPath:@"created_at"
                                                   dateFormat:@"yyyy-MM-dd"]];
	}];
}

+ (FEMMapping *)phoneMapping {
	return [FEMMapping mappingForClass:[PhoneNative class] configuration:^(FEMMapping *mapping) {
        [mapping addAttributesFromArray:@[@"number"]];
        [mapping addAttributesFromDictionary:@{
            @"DDI" : @"ddi",
            @"DDD" : @"ddd",
        }];
	}];
}

+ (FEMMapping *)personMapping {
	return [FEMMapping mappingForClass:[PersonNative class] configuration:^(FEMMapping *mapping) {
		NSDictionary *genders = @{@"male" : @(GenderMale), @"female" : @(GenderFemale)};
        [mapping addAttributesFromArray:@[@"name", @"email"]];
        [mapping addAttribute:[FEMAttribute mappingOfProperty:@"gender"
                                                    toKeyPath:@"gender"
                                                          map:^id(id value) {
                                                              return genders[value];
                                                          }
                                                   reverseMap:^id(id value) {
                                                       return [genders allKeysForObject:value].lastObject;
                                                   }]];

		[mapping addRelationshipMapping:[self carMapping] forProperty:@"car" keyPath:@"car"];
		[mapping addToManyRelationshipMapping:[self phoneMapping] forProperty:@"phones" keyPath:@"phones"];
	}];
}

+ (FEMMapping *)personWithCarMapping {
	return [FEMMapping mappingForClass:[PersonNative class] configuration:^(FEMMapping *mapping) {
        [mapping addAttributesFromArray:@[@"name", @"email"]];
		[mapping addRelationshipMapping:[self carMapping] forProperty:@"car" keyPath:@"car"];
	}];
}

+ (FEMMapping *)personWithPhonesMapping {
	return [FEMMapping mappingForClass:[PersonNative class] configuration:^(FEMMapping *mapping) {
        [mapping addAttributesFromArray:@[@"name", @"email"]];
		[mapping addToManyRelationshipMapping:[self phoneMapping] forProperty:@"phones" keyPath:@"phones"];
	}];
}

+ (FEMMapping *)personWithOnlyValueBlockMapping {
	return [FEMMapping mappingForClass:[PersonNative class] configuration:^(FEMMapping *mapping) {
		NSDictionary *genders = @{@"male" : @(GenderMale), @"female" : @(GenderFemale)};
        [mapping addAttributesFromArray:@[@"name", @"email"]];
        [mapping addAttribute:[FEMAttribute mappingOfProperty:@"gender"
                                                    toKeyPath:@"gender"
                                                          map:^id(id value) {
                                                              return genders[value];
                                                          }
                                                   reverseMap:^id(id value) {
                                                       return [genders allKeysForObject:value].lastObject;
                                                   }]];
	}];
}

+ (FEMMapping *)addressMapping {
	return [FEMMapping mappingForClass:[AddressNative class] configuration:^(FEMMapping *mapping) {
        [mapping addAttributesFromArray:@[@"street"]];
        [mapping addAttribute:[FEMAttribute mappingOfProperty:@"location"
                                                    toKeyPath:@"location"
                                                          map:^id(id value) {
                                                              CLLocationDegrees latitudeValue = [[value objectAtIndex:0] doubleValue];
                                                              CLLocationDegrees longitudeValue = [[value objectAtIndex:1] doubleValue];
                                                              return [[CLLocation alloc] initWithLatitude:latitudeValue
                                                                                                longitude:longitudeValue];
                                                          }
                                                   reverseMap:^id(CLLocation *value) {
                                                       return @[
                                                           @(value.coordinate.latitude),
                                                           @(value.coordinate.longitude)
                                                       ];
                                                   }]];
	}];
}

+ (FEMMapping *)nativeMapping {
	return [FEMMapping mappingForClass:[Native class] configuration:^(FEMMapping *mapping) {
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
	}];
}

+ (FEMMapping *)nativeMappingWithNullPropertie {
	return [FEMMapping mappingForClass:[CatNative class] configuration:^(FEMMapping *mapping) {
        [mapping addAttributesFromArray:@[@"age"]];
	}];
}

+ (FEMMapping *)planeMapping {
	return [FEMMapping mappingForClass:[PlaneNative class] configuration:^(FEMMapping *mapping) {
        [mapping addAttributesFromDictionary:@{@"flightNumber" : @"flight_number"}];
		[mapping addToManyRelationshipMapping:[self personMapping] forProperty:@"persons" keyPath:@"persons"];
	}];
}

+ (FEMMapping *)alienMapping {
	return [FEMMapping mappingForClass:[AlienNative class] configuration:^(FEMMapping *mapping) {
        [mapping addAttributesFromArray:@[@"name"]];
		[mapping addToManyRelationshipMapping:[self fingerMapping] forProperty:@"fingers" keyPath:@"fingers"];
	}];
}

+ (FEMMapping *)fingerMapping {
	return [FEMMapping mappingForClass:[FingerNative class] configuration:^(FEMMapping *mapping) {
        [mapping addAttributesFromArray:@[@"name"]];
	}];
}

+ (FEMMapping *)nativeChildMapping {
	return [FEMMapping mappingForClass:[NativeChild class] configuration:^(FEMMapping *mapping) {
        [mapping addAttributesFromArray:@[@"intProperty", @"boolProperty", @"childProperty"]];
	}];
}

@end
