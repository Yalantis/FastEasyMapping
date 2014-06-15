// Copyright (c) 2014 Lucas Medeiros.
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

#import "FEMAttributeMapping.h"

@implementation FEMAttributeMapping {
	FEMMapBlock _map;
	FEMMapBlock _reverseMap;
}

@synthesize property = _property;
@synthesize keyPath = _keyPath;

#pragma mark - Init

- (id)initWithProperty:(NSString *)property keyPath:(NSString *)keyPath map:(FEMMapBlock)map reverseMap:(FEMMapBlock)reverseMap {
	NSParameterAssert(property.length > 0);

	self = [super init];
	if (self) {
		_property = [property copy];
		[self setKeyPath:keyPath];

		FEMMapBlock passthroughMap = ^(id value) {
			return value;
		};

		_map = map ?: passthroughMap;
		_reverseMap = reverseMap ?: passthroughMap;
	}

	return self;
}

+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath map:(FEMMapBlock)map reverseMap:(FEMMapBlock)reverseMap {
	return [[self alloc] initWithProperty:property keyPath:keyPath map:map reverseMap:reverseMap];
}

+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath map:(FEMMapBlock)map {
	return [self mappingOfProperty:property toKeyPath:keyPath map:map reverseMap:NULL];
}

+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath {
	return [self mappingOfProperty:property toKeyPath:keyPath map:NULL];
}

+ (instancetype)mappingOfProperty:(NSString *)property {
    return [self mappingOfProperty:property toKeyPath:property];
}

+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath dateFormat:(NSString *)dateFormat {
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/London"]];
	[formatter setDateFormat:dateFormat];

	return [self mappingOfProperty:property toKeyPath:keyPath map:^id(id value) {
        return [value isKindOfClass:[NSString class]] ? [formatter dateFromString:value] : nil;
    }                   reverseMap:^id(id value) {
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

@implementation FEMAttributeMapping (Deprecated)

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath {
    return [self mappingOfProperty:property toKeyPath:keyPath];
}

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath map:(FEMMapBlock)map {
    return [self mappingOfProperty:property toKeyPath:keyPath map:map];
}

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath dateFormat:(NSString *)dateFormat {
    return [self mappingOfProperty:property toKeyPath:keyPath dateFormat:dateFormat];
}

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath map:(FEMMapBlock)map reverseMap:(FEMMapBlock)reverseMap {
    return [self mappingOfProperty:property toKeyPath:keyPath map:map reverseMap:reverseMap];
}

@end