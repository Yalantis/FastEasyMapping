// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMMapping.h"

#import "FEMAttributeMapping.h"
#import "FEMRelationshipMapping.h"
#import "FEMDeserializer.h"
#import "FEMManagedObjectDeserializerSource.h"
#import "FEMAssignmentContextPrivate.h"

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

- (instancetype)initWithObjectClass:(Class)objectClass {
    self = [self init];
    if (self) {
        _objectClass = objectClass;
    }

    return self;
}

- (instancetype)initWithEntityName:(NSString *)entityName {
    self = [self init];
    if (self) {
        _entityName = [entityName copy];
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

#pragma mark -

- (FEMAttribute *)primaryKeyAttribute {
    return _attributeMap[self.primaryKey];
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

- (void)addAttributesDictionary:(NSDictionary *)attributesToKeyPath {
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

- (id)representationFromExternalRepresentation:(id)externalRepresentation {
	return self.rootPath ? [externalRepresentation valueForKeyPath:self.rootPath] : externalRepresentation;
}

@end

@implementation FEMMapping (Obsolete)

- (id)initWithRootPath:(NSString *)rootPath __attribute__((obsoleted)) {
    @throw @"Obsolete";
    return nil;
}

@end