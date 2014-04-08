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

#import "EMKManagedObjectMapping.h"
#import "EMKAttributeMapping.h"

@implementation EMKManagedObjectMapping

#pragma mark - Init

- (id)initWithEntityName:(NSString *)entityName rootPath:(NSString *)rootPath {
	self = [self initWithRootPath:rootPath];
	if (self) {
		_entityName = [entityName copy];
	}
	return self;
}

- (id)initWithEntityName:(NSString *)entityName {
	return [self initWithEntityName:entityName rootPath:nil];
}

+ (EMKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName configuration:(void (^)(EMKManagedObjectMapping *sender))configuration {
	EMKManagedObjectMapping *mapping = [[EMKManagedObjectMapping alloc] initWithEntityName:entityName];
	configuration(mapping);
	return mapping;
}

+ (EMKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName
                                         rootPath:(NSString *)rootPath
		                            configuration:(void (^)(EMKManagedObjectMapping *sender))configuration {
	EMKManagedObjectMapping *mapping = [[EMKManagedObjectMapping alloc] initWithEntityName:entityName
	                                                                              rootPath:rootPath];
	configuration(mapping);
	return mapping;
}

+ (EMKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName {
	return [[self alloc] initWithEntityName:entityName rootPath:nil];
}

#pragma mark - Properties

- (EMKAttributeMapping *)primaryKeyMapping {
	return [_attributesMap objectForKey:self.primaryKey];
}

@end
