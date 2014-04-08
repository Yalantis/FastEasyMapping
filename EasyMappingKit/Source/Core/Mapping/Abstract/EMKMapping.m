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

#import "EMKMapping.h"

#import "EMKAttributeMapping.h"
#import "EMKRelationshipMapping.h"

@implementation EMKMapping

#pragma mark - Init

- (id)init {
	self = [super init];
	if (self) {
		_attributesMap = [NSMutableDictionary new];
		_relationshipsMap = [NSMutableDictionary new];
	}

	return self;
}

- (id)initWithRootPath:(NSString *)rootPath {
	self = [self init];
	if (self) {
		_rootPath = [rootPath copy];
	}

	return self;
}

#pragma mark - Attribute Mapping

- (void)addPropertyMapping:(id<EMKPropertyMapping>)propertyMapping toMap:(NSMutableDictionary *)map {
	NSParameterAssert(propertyMapping);
	NSAssert(
		propertyMapping.property.length > 0,
		@"It's illegal to add objectMapping without specified property:%@",
		propertyMapping
	);

#ifdef DEBUG
	EMKAttributeMapping *existingMapping = map[propertyMapping.property];
	if (existingMapping) {
		NSLog(@"%@ replacing %@ with %@", NSStringFromClass(self.class), existingMapping, propertyMapping);
	}
#endif

	map[propertyMapping.property] = propertyMapping;
}

- (void)addAttributeMapping:(EMKAttributeMapping *)attributeMapping {
	[self addPropertyMapping:attributeMapping toMap:_attributesMap];
}

- (EMKAttributeMapping *)attributeMappingForProperty:(NSString *)property {
	return _attributesMap[property];
}

#pragma mark - Relationship Mapping

- (void)addRelationshipMapping:(EMKRelationshipMapping *)relationshipMapping {
	[self addPropertyMapping:relationshipMapping toMap:_relationshipsMap];
}

- (EMKRelationshipMapping *)relationshipMappingForProperty:(NSString *)property {
	return _relationshipsMap[property];
}

#pragma mark - Properties

- (NSArray *)attributeMappings {
	return [_attributesMap allValues];
}

- (NSArray *)relationshipMappings {
	return [_relationshipsMap allValues];
}

@end

@implementation EMKMapping (Shortcut)

- (void)addAttributeMappingDictionary:(NSDictionary *)attributesToKeyPath {
	[attributesToKeyPath enumerateKeysAndObjectsUsingBlock:^(id attribute, id keyPath, BOOL *stop) {
		[self addAttributeMapping:[EMKAttributeMapping mappingOfProperty:attribute keyPath:keyPath]];
	}];
}

- (void)addAttributeMappingFromArray:(NSArray *)attributes {
	for (NSString *attribute in attributes) {
		[self addAttributeMapping:[EMKAttributeMapping mappingOfProperty:attribute keyPath:attribute]];
	}
}

- (void)addAttributeMappingOfProperty:(NSString *)property atKeypath:(NSString *)keypath {
	[self addAttributeMapping:[EMKAttributeMapping mappingOfProperty:property keyPath:keypath]];
}

- (void)addRelationshipMapping:(EMKMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath {
	EMKRelationshipMapping *relationshipMapping = [EMKRelationshipMapping mappingOfProperty:property
	                                                                                keyPath:keyPath
		                                                                      objectMapping:mapping];
	[self addRelationshipMapping:relationshipMapping];
}

- (void)addToManyRelationshipMapping:(EMKMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath {
	EMKRelationshipMapping *relationshipMapping = [EMKRelationshipMapping mappingOfProperty:property
	                                                                                keyPath:keyPath
		                                                                      objectMapping:mapping];
	[relationshipMapping setToMany:YES];
	[self addRelationshipMapping:relationshipMapping];
}

- (id)extractRootFromExternalRepresentation:(id)externalRepresentation {
	return self.rootPath ? [externalRepresentation valueForKeyPath:self.rootPath] : externalRepresentation;
}

@end