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

#import "FEMObjectMapping.h"

@implementation FEMObjectMapping

#pragma mark - Init

- (id)initWithObjectClass:(Class)objectClass rootPath:(NSString *)rootPath {
	self = [self initWithRootPath:rootPath];
	if (self) {
		_objectClass = objectClass;
	}
	return self;
}

- (id)initWithObjectClass:(Class)objectClass {
	return [self initWithObjectClass:objectClass rootPath:nil];
}

+ (instancetype)mappingForClass:(Class)objectClass configuration:(void (^)(FEMObjectMapping *mapping))configuration {
	FEMObjectMapping *mapping = [[self alloc] initWithObjectClass:objectClass];
	configuration(mapping);
	return mapping;
}

+ (instancetype)mappingForClass:(Class)objectClass
                       rootPath:(NSString *)rootPath
		          configuration:(void (^)(FEMObjectMapping *mapping))configuration {
	FEMObjectMapping *mapping = [[self alloc] initWithObjectClass:objectClass rootPath:rootPath];
	configuration(mapping);
	return mapping;
}

@end