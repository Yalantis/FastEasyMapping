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

#import "FEMMapping.h"

#import "FEMAttributeMapping.h"
#import "FEMRelationshipMapping.h"

@implementation FEMMapping

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

- (void)addPropertyMapping:(id<FEMPropertyMapping>)propertyMapping toMap:(NSMutableDictionary *)map {
	NSParameterAssert(propertyMapping);
	NSAssert(
		propertyMapping.property.length > 0,
		@"It's illegal to add objectMapping without specified property:%@",
		propertyMapping
	);

#ifdef DEBUG
	FEMAttributeMapping *existingMapping = map[propertyMapping.property];
	if (existingMapping) {
		NSLog(@"%@ replacing %@ with %@", NSStringFromClass(self.class), existingMapping, propertyMapping);
	}
#endif

	map[propertyMapping.property] = propertyMapping;
}

- (void)addAttributeMapping:(FEMAttributeMapping *)attributeMapping {
	[self addPropertyMapping:attributeMapping toMap:_attributesMap];
}

- (FEMAttributeMapping *)attributeMappingForProperty:(NSString *)property {
	return _attributesMap[property];
}

#pragma mark - Relationship Mapping

- (void)addRelationshipMapping:(FEMRelationshipMapping *)relationshipMapping {
	[self addPropertyMapping:relationshipMapping toMap:_relationshipsMap];
}

- (FEMRelationshipMapping *)relationshipMappingForProperty:(NSString *)property {
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

@implementation FEMMapping (Shortcut)

- (void)addAttributeMappingDictionary:(NSDictionary *)attributesToKeyPath {
	[attributesToKeyPath enumerateKeysAndObjectsUsingBlock:^(id attribute, id keyPath, BOOL *stop) {
		[self addAttributeMapping:[FEMAttributeMapping mappingOfProperty:attribute toKeyPath:keyPath]];
	}];
}

- (void)addAttributeMappingFromArray:(NSArray *)attributes {
	for (NSString *attribute in attributes) {
		[self addAttributeMapping:[FEMAttributeMapping mappingOfProperty:attribute toKeyPath:attribute]];
	}
}

- (void)addAttributeMappingOfProperty:(NSString *)property atKeypath:(NSString *)keypath {
	[self addAttributeMapping:[FEMAttributeMapping mappingOfProperty:property toKeyPath:keypath]];
}

- (void)addRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath {
	FEMRelationshipMapping *relationshipMapping = [FEMRelationshipMapping mappingOfProperty:property
                                                                                  toKeyPath:keyPath
                                                                              objectMapping:mapping];
	[self addRelationshipMapping:relationshipMapping];
}

- (void)addToManyRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath {
	FEMRelationshipMapping *relationshipMapping = [FEMRelationshipMapping mappingOfProperty:property
                                                                                  toKeyPath:keyPath
                                                                              objectMapping:mapping];
	[relationshipMapping setToMany:YES];
	[self addRelationshipMapping:relationshipMapping];
}

- (id)extractRootFromExternalRepresentation:(id)externalRepresentation {
	return self.rootPath ? [externalRepresentation valueForKeyPath:self.rootPath] : externalRepresentation;
}

@end