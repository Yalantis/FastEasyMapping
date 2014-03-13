//
//  EMKAttributeMapping.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 22/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "EMKAttributeMapping.h"

@implementation EMKAttributeMapping {
	EMKMapBlock _map;
	EMKMapBlock _reverseMap;
}

@synthesize property = _property;
@synthesize keyPath = _keyPath;

#pragma mark - Init

- (id)initWithProperty:(NSString *)property keyPath:(NSString *)keyPath map:(EMKMapBlock)map reverseMap:(EMKMapBlock)reverseMap {
	NSParameterAssert(property.length > 0);

	self = [super init];
	if (self) {
		_property = [property copy];
		[self setKeyPath:keyPath];

		EMKMapBlock passthroughMap = ^(id value) {
			return value;
		};

		_map = map ?: passthroughMap;
		_reverseMap = reverseMap ?: passthroughMap;
	}

	return self;
}

+ (instancetype)mappingOfProperty:(NSString *)field keyPath:(NSString *)keyPath map:(EMKMapBlock)map reverseMap:(EMKMapBlock)reverseMap {
	return [[self alloc] initWithProperty:field keyPath:keyPath map:map reverseMap:reverseMap];
}

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath map:(EMKMapBlock)map {
	return [self mappingOfProperty:property keyPath:keyPath map:map reverseMap:NULL];
}

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath {
	return [self mappingOfProperty:property keyPath:keyPath map:NULL reverseMap:NULL];
}

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath dateFormat:(NSString *)dateFormat {
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/London"]];
	[formatter setDateFormat:dateFormat];

	return [self mappingOfProperty:property keyPath:keyPath map:^id(id value) {
		return [value isKindOfClass:[NSString class]] ? [formatter dateFromString:value] : nil;
	} reverseMap:^id(id value) {
		return [value isKindOfClass:[NSDate class]] ? [formatter stringFromDate:value] : nil;
	}];
}

#pragma mark - Description

- (NSString *)description {
	return [NSString stringWithFormat:
		@"<%@ %p> keypath:%@ property:%@",
		NSStringFromClass(self.class),
		(__bridge void *)self,
		self.keyPath,
		self.property
	];
}

#pragma mark - Mapping

- (id)mapValue:(id)value {
	return _map(value);
}

- (id)reverseMapValue:(id)value {
	return _reverseMap(value);
}

@end
