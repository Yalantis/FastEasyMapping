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

#import "FEMRelationshipMapping.h"
#import "FEMMapping.h"

@implementation FEMRelationshipMapping

@synthesize property = _property;
@synthesize keyPath = _keyPath;

#pragma mark - Init

- (id)initWithProperty:(NSString *)property keyPath:(NSString *)keyPath objectMapping:(FEMMapping *)objectMapping {
	NSParameterAssert(property.length > 0);

	self = [super init];
	if (self) {
		_property = [property copy];
        _keyPath = [keyPath copy];
		[self setObjectMapping:objectMapping];
	}

	return self;
}

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath configuration:(void (^)(
	FEMRelationshipMapping *mapping))configuration {
	NSParameterAssert(configuration);

	FEMRelationshipMapping *mapping = [[self alloc] initWithProperty:property keyPath:keyPath objectMapping:nil];
	configuration(mapping);
	return mapping;
}

+ (instancetype)mappingOfProperty:(NSString *)property configuration:(void (^)(FEMRelationshipMapping *mapping))configuration {
	return [self mappingOfProperty:property keyPath:nil configuration:configuration];
}

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath objectMapping:(FEMMapping *)objectMapping {
	return [[self alloc] initWithProperty:property keyPath:keyPath objectMapping:objectMapping];
}

#pragma mark - Property objectMapping

- (void)setObjectMapping:(FEMMapping *)objectMapping forKeyPath:(NSString *)keyPath {
	[self setObjectMapping:objectMapping];
	[self setKeyPath:keyPath];
}

@end

@implementation FEMRelationshipMapping (Extension)

- (id)extractRootFromExternalRepresentation:(id)externalRepresentation {
	if (self.keyPath) return [externalRepresentation valueForKeyPath:self.keyPath];

	return externalRepresentation;
}

@end