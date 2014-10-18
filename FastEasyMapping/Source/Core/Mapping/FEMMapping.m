// For License please refer to LICENSE file in the root of FastEasyMapping project

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

#pragma mark - Description

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:
        @"<%@ %p>\n<%%@> {\nrootPath:%@\n",
        NSStringFromClass(self.class),
        (__bridge void *) self,
        self.rootPath
    ];

    [description appendString:@"attributes {\n"];
    for (FEMAttributeMapping *mapping in self.attributeMappings) {
        [description appendFormat:@"\t(%@),\n", [mapping description]];
    }
    [description appendString:@"}\n"];

    [description appendString:@"relationships {\n"];
    for (FEMRelationshipMapping *relationshipMapping in self.relationshipMappings) {
        [description appendFormat:@"\t(%@),", [relationshipMapping description]];
    }
    [description appendFormat:@"}\n"];

    return description;
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