// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMMapping.h"

@implementation FEMMapping

#pragma mark - Init

- (id)init {
	self = [super init];
	if (self) {
		_attributeMap = [NSMutableDictionary new];
		_relationshipMap = [NSMutableDictionary new];
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

- (void)addPropertyMapping:(id<FEMProperty>)propertyMapping toMap:(NSMutableDictionary *)map {
	NSParameterAssert(propertyMapping);
	NSAssert(
		propertyMapping.property.length > 0,
		@"It's illegal to add objectMapping without specified property:%@",
		propertyMapping
	);

#ifdef DEBUG
	FEMAttribute *existingMapping = map[propertyMapping.property];
	if (existingMapping) {
		NSLog(@"%@ replacing %@ with %@", NSStringFromClass(self.class), existingMapping, propertyMapping);
	}
#endif

	map[propertyMapping.property] = propertyMapping;
}

- (void)addAttribute:(FEMAttribute *)attribute {
    [self addPropertyMapping:attribute toMap:_attributeMap];
}

- (FEMAttribute *)attributeForProperty:(NSString *)property {
	return _attributeMap[property];
}

#pragma mark - Relationship Mapping

- (void)addRelationship:(FEMRelationship *)relationship {
    [self addPropertyMapping:relationship toMap:_relationshipMap];
}

- (FEMRelationship *)relationshipForProperty:(NSString *)property {
	return _relationshipMap[property];
}

#pragma mark - Properties

- (NSArray *)attributes {
	return [_attributeMap allValues];
}

- (NSArray *)relationships {
	return [_relationshipMap allValues];
}

#pragma mark - Description

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:
        @"<%@ %p>\n<%%@> {\nrootPath:%@\n",
        NSStringFromClass(self.class),
        (__bridge void *) self,
        self.rootPath
    ];

    [description appendString:@"attributes {\n"];
    for (FEMAttribute *mapping in self.attributes) {
        [description appendFormat:@"\t(%@),\n", [mapping description]];
    }
    [description appendString:@"}\n"];

    [description appendString:@"relationships {\n"];
    for (FEMRelationship *relationshipMapping in self.relationships) {
        [description appendFormat:@"\t(%@),", [relationshipMapping description]];
    }
    [description appendFormat:@"}\n"];

    return description;
}

@end

@implementation FEMMapping (Shortcut)

- (void)addAttributesFromDictionary:(NSDictionary *)attributesToKeyPath {
	[attributesToKeyPath enumerateKeysAndObjectsUsingBlock:^(id attribute, id keyPath, BOOL *stop) {
        [self addAttribute:[FEMAttribute mappingOfProperty:attribute toKeyPath:keyPath]];
	}];
}

- (void)addAttributesFromArray:(NSArray *)attributes {
	for (NSString *attribute in attributes) {
        [self addAttribute:[FEMAttribute mappingOfProperty:attribute toKeyPath:attribute]];
	}
}

- (void)addAttributeWithProperty:(NSString *)property keyPath:(NSString *)keyPath {
    [self addAttribute:[FEMAttribute mappingOfProperty:property toKeyPath:keyPath]];
}

- (void)addRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath {
	FEMRelationship *relationshipMapping = [FEMRelationship mappingOfProperty:property
                                                                    toKeyPath:keyPath
                                                                objectMapping:mapping];
    [self addRelationship:relationshipMapping];
}

- (void)addToManyRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath {
	FEMRelationship *relationshipMapping = [FEMRelationship mappingOfProperty:property
                                                                    toKeyPath:keyPath
                                                                objectMapping:mapping];
	[relationshipMapping setToMany:YES];
    [self addRelationship:relationshipMapping];
}

- (id)extractRootFromExternalRepresentation:(id)externalRepresentation {
	return self.rootPath ? [externalRepresentation valueForKeyPath:self.rootPath] : externalRepresentation;
}

@end

@implementation FEMMapping (Deprecated)

- (void)addAttributeMappingFromArray:(NSArray *)attributes {
    [self addAttributesFromArray:attributes];
}

- (void)addAttributeMappingDictionary:(NSDictionary *)attributesToKeyPath {
    [self addAttributesFromDictionary:attributesToKeyPath];
}

- (void)addAttributeMappingOfProperty:(NSString *)property atKeypath:(NSString *)keypath {
    [self addAttributeWithProperty:property keyPath:keypath];
}

- (NSArray *)attributeMappings {
    return self.attributes;
}

- (void)addAttributeMapping:(FEMAttributeMapping *)attributeMapping {
    [self addAttribute:attributeMapping];
}

- (FEMAttributeMapping *)attributeMappingForProperty:(NSString *)property {
    return [self attributeForProperty:property];
}

- (NSArray *)relationshipMappings {
    return self.relationships;
}

- (void)addRelationshipMapping:(FEMRelationshipMapping *)relationshipMapping {
    [self addRelationship:relationshipMapping];
}

- (FEMRelationshipMapping *)relationshipMappingForProperty:(NSString *)property {
    return [self relationshipForProperty:property];
}

@end