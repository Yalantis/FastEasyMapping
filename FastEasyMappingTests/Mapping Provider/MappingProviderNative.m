// Copyright (c) 2014 Yalantis.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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

#import "EMKObjectMapping.h"
#import "EMKAttributeMapping.h"

@implementation MappingProviderNative

+ (EMKObjectMapping *)carMapping {
	return [EMKObjectMapping mappingForClass:[CarNative class] configuration:^(EMKObjectMapping *mapping) {
		[mapping addAttributeMappingFromArray:@[@"model", @"year"]];
	}];
}

+ (EMKObjectMapping *)carWithRootKeyMapping {
	return [EMKObjectMapping mappingForClass:[CarNative class] rootPath:@"car" configuration:^(EMKObjectMapping *mapping) {
		[mapping addAttributeMappingFromArray:@[@"model", @"year"]];
	}];
}

+ (EMKObjectMapping *)carNestedAttributesMapping {
	return [EMKObjectMapping mappingForClass:[CarNative class] configuration:^(EMKObjectMapping *mapping) {
		[mapping addAttributeMappingFromArray:@[@"model"]];
		[mapping addAttributeMappingDictionary:@{
			@"year": @"information.year"
		}];
	}];
}

+ (EMKObjectMapping *)carWithDateMapping {
	return [EMKObjectMapping mappingForClass:[CarNative class] configuration:^(EMKObjectMapping *mapping) {
		[mapping addAttributeMappingFromArray:@[@"model", @"year"]];
		[mapping addAttributeMapping:[EMKAttributeMapping mappingOfProperty:@"createdAt"
		                                                            keyPath:@"created_at"
			                                                     dateFormat:@"yyyy-MM-dd"]];
	}];
}

+ (EMKObjectMapping *)phoneMapping {
	return [EMKObjectMapping mappingForClass:[PhoneNative class] configuration:^(EMKObjectMapping *mapping) {
		[mapping addAttributeMappingFromArray:@[@"number"]];
		[mapping addAttributeMappingDictionary:@{
			@"DDI": @"ddi",
			@"DDD": @"ddd",
		}];
	}];
}

+ (EMKObjectMapping *)personMapping {
	return [EMKObjectMapping mappingForClass:[PersonNative class] configuration:^(EMKObjectMapping *mapping) {
		NSDictionary *genders = @{@"male" : @(GenderMale), @"female" : @(GenderFemale)};
		[mapping addAttributeMappingFromArray:@[@"name", @"email"]];
		[mapping addAttributeMapping:[EMKAttributeMapping mappingOfProperty:@"gender"
		                                                            keyPath:@"gender"
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

+ (EMKObjectMapping *)personWithCarMapping {
	return [EMKObjectMapping mappingForClass:[PersonNative class] configuration:^(EMKObjectMapping *mapping) {
		[mapping addAttributeMappingFromArray:@[@"name", @"email"]];
		[mapping addRelationshipMapping:[self carMapping] forProperty:@"car" keyPath:@"car"];
	}];
}

+ (EMKObjectMapping *)personWithPhonesMapping {
	return [EMKObjectMapping mappingForClass:[PersonNative class] configuration:^(EMKObjectMapping *mapping) {
		[mapping addAttributeMappingFromArray:@[@"name", @"email"]];
		[mapping addToManyRelationshipMapping:[self phoneMapping] forProperty:@"phones" keyPath:@"phones"];
	}];
}

+ (EMKObjectMapping *)personWithOnlyValueBlockMapping {
	return [EMKObjectMapping mappingForClass:[PersonNative class] configuration:^(EMKObjectMapping *mapping) {
		NSDictionary *genders = @{@"male" : @(GenderMale), @"female" : @(GenderFemale)};
		[mapping addAttributeMappingFromArray:@[@"name", @"email"]];
		[mapping addAttributeMapping:[EMKAttributeMapping mappingOfProperty:@"gender"
		                                                            keyPath:@"gender"
			                                                            map:^id(id value) {
				                                                            return genders[value];
			                                                            }
				                                                 reverseMap:^id(id value) {
					                                                 return [genders allKeysForObject:value].lastObject;
				                                                 }]];
	}];
}

+ (EMKObjectMapping *)addressMapping {
	return [EMKObjectMapping mappingForClass:[AddressNative class] configuration:^(EMKObjectMapping *mapping) {
		[mapping addAttributeMappingFromArray:@[@"street"]];
		[mapping addAttributeMapping:[EMKAttributeMapping mappingOfProperty:@"location"
		                                                            keyPath:@"location"
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

+ (EMKObjectMapping *)nativeMapping {
	return [EMKObjectMapping mappingForClass:[Native class] configuration:^(EMKObjectMapping *mapping) {
		[mapping addAttributeMappingFromArray:@[
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

+ (EMKObjectMapping *)nativeMappingWithNullPropertie {
	return [EMKObjectMapping mappingForClass:[CatNative class] configuration:^(EMKObjectMapping *mapping) {
		[mapping addAttributeMappingFromArray:@[@"age"]];
	}];
}

+ (EMKObjectMapping *)planeMapping {
	return [EMKObjectMapping mappingForClass:[PlaneNative class] configuration:^(EMKObjectMapping *mapping) {
		[mapping addAttributeMappingDictionary:@{@"flightNumber" : @"flight_number"}];
		[mapping addToManyRelationshipMapping:[self personMapping] forProperty:@"persons" keyPath:@"persons"];
	}];
}

+ (EMKObjectMapping *)alienMapping {
	return [EMKObjectMapping mappingForClass:[AlienNative class] configuration:^(EMKObjectMapping *mapping) {
		[mapping addAttributeMappingFromArray:@[@"name"]];
		[mapping addToManyRelationshipMapping:[self fingerMapping] forProperty:@"fingers" keyPath:@"fingers"];
	}];
}

+ (EMKObjectMapping *)fingerMapping {
	return [EMKObjectMapping mappingForClass:[FingerNative class] configuration:^(EMKObjectMapping *mapping) {
		[mapping addAttributeMappingFromArray:@[@"name"]];
	}];
}

+ (EMKObjectMapping *)nativeChildMapping {
	return [EMKObjectMapping mappingForClass:[NativeChild class] configuration:^(EMKObjectMapping *mapping) {
		[mapping addAttributeMappingFromArray:@[@"intProperty", @"boolProperty", @"childProperty"]];
	}];
}

@end
