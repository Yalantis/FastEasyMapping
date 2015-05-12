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

#import "FEMObjectMapping.h"
#import "FEMAttribute.h"

@implementation MappingProviderNative

+ (FEMObjectMapping *)carMapping {
	return [FEMObjectMapping mappingForClass:[CarNative class] configuration:^(FEMObjectMapping *mapping) {
        [mapping addAttributesFromArray:@[@"model", @"year"]];
	}];
}

+ (FEMObjectMapping *)carWithRootKeyMapping {
	return [FEMObjectMapping mappingForClass:[CarNative class]
	                                rootPath:@"car"
			                   configuration:^(FEMObjectMapping *mapping) {
                                   [mapping addAttributesFromArray:@[@"model", @"year"]];
			                   }];
}

+ (FEMObjectMapping *)carNestedAttributesMapping {
	return [FEMObjectMapping mappingForClass:[CarNative class] configuration:^(FEMObjectMapping *mapping) {
        [mapping addAttributesFromArray:@[@"model"]];
        [mapping addAttributesDictionary:@{
            @"year" : @"information.year"
        }];
	}];
}

+ (FEMObjectMapping *)carWithDateMapping {
	return [FEMObjectMapping mappingForClass:[CarNative class] configuration:^(FEMObjectMapping *mapping) {
        [mapping addAttributesFromArray:@[@"model", @"year"]];
        [mapping addAttribute:[FEMAttribute mappingOfProperty:@"createdAt"
                                                    toKeyPath:@"created_at"
                                                   dateFormat:@"yyyy-MM-dd"]];
	}];
}

+ (FEMObjectMapping *)phoneMapping {
	return [FEMObjectMapping mappingForClass:[PhoneNative class] configuration:^(FEMObjectMapping *mapping) {
        [mapping addAttributesFromArray:@[@"number"]];
        [mapping addAttributesDictionary:@{
            @"DDI" : @"ddi",
            @"DDD" : @"ddd",
        }];
	}];
}

+ (FEMObjectMapping *)personMapping {
	return [FEMObjectMapping mappingForClass:[PersonNative class] configuration:^(FEMObjectMapping *mapping) {
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

+ (FEMObjectMapping *)personWithCarMapping {
	return [FEMObjectMapping mappingForClass:[PersonNative class] configuration:^(FEMObjectMapping *mapping) {
        [mapping addAttributesFromArray:@[@"name", @"email"]];
		[mapping addRelationshipMapping:[self carMapping] forProperty:@"car" keyPath:@"car"];
	}];
}

+ (FEMObjectMapping *)personWithPhonesMapping {
	return [FEMObjectMapping mappingForClass:[PersonNative class] configuration:^(FEMObjectMapping *mapping) {
        [mapping addAttributesFromArray:@[@"name", @"email"]];
		[mapping addToManyRelationshipMapping:[self phoneMapping] forProperty:@"phones" keyPath:@"phones"];
	}];
}

+ (FEMObjectMapping *)personWithOnlyValueBlockMapping {
	return [FEMObjectMapping mappingForClass:[PersonNative class] configuration:^(FEMObjectMapping *mapping) {
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

+ (FEMObjectMapping *)addressMapping {
	return [FEMObjectMapping mappingForClass:[AddressNative class] configuration:^(FEMObjectMapping *mapping) {
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

+ (FEMObjectMapping *)nativeMapping {
	return [FEMObjectMapping mappingForClass:[Native class] configuration:^(FEMObjectMapping *mapping) {
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

+ (FEMObjectMapping *)nativeMappingWithNullPropertie {
	return [FEMObjectMapping mappingForClass:[CatNative class] configuration:^(FEMObjectMapping *mapping) {
        [mapping addAttributesFromArray:@[@"age"]];
	}];
}

+ (FEMObjectMapping *)planeMapping {
	return [FEMObjectMapping mappingForClass:[PlaneNative class] configuration:^(FEMObjectMapping *mapping) {
        [mapping addAttributesDictionary:@{@"flightNumber" : @"flight_number"}];
		[mapping addToManyRelationshipMapping:[self personMapping] forProperty:@"persons" keyPath:@"persons"];
	}];
}

+ (FEMObjectMapping *)alienMapping {
	return [FEMObjectMapping mappingForClass:[AlienNative class] configuration:^(FEMObjectMapping *mapping) {
        [mapping addAttributesFromArray:@[@"name"]];
		[mapping addToManyRelationshipMapping:[self fingerMapping] forProperty:@"fingers" keyPath:@"fingers"];
	}];
}

+ (FEMObjectMapping *)fingerMapping {
	return [FEMObjectMapping mappingForClass:[FingerNative class] configuration:^(FEMObjectMapping *mapping) {
        [mapping addAttributesFromArray:@[@"name"]];
	}];
}

+ (FEMObjectMapping *)nativeChildMapping {
	return [FEMObjectMapping mappingForClass:[NativeChild class] configuration:^(FEMObjectMapping *mapping) {
        [mapping addAttributesFromArray:@[@"intProperty", @"boolProperty", @"childProperty"]];
	}];
}

@end
