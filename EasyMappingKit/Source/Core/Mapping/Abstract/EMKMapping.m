//
//  EMKMapping.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 21/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

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

#pragma mark - Relationship Mapping

- (void)addRelationshipMapping:(EMKRelationshipMapping *)relationshipMapping {
	[self addPropertyMapping:relationshipMapping toMap:_relationshipsMap];
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

- (id)mappedExternalRepresentation:(id)externalRepresentation {
	return self.rootPath ? [externalRepresentation valueForKeyPath:self.rootPath] : externalRepresentation;
}

@end