// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMMapping.h"
#import "FEMManagedObjectMapping.h"
#import "FEMObjectMapping.h"

@implementation FEMMapping  {
    NSMutableDictionary *_attributeMap;
    NSMutableDictionary *_relationshipMap;
}

#pragma mark - Init

- (instancetype)initWithObjectClass:(Class)objectClass {
    self = [super init];
    if (self) {
        _attributeMap = [NSMutableDictionary new];
        _relationshipMap = [NSMutableDictionary new];

        _objectClass = objectClass;
    }

    return self;
}

- (instancetype)initWithObjectClass:(Class)objectClass rootPath:(NSString *)rootPath {
    self = [self initWithObjectClass:objectClass];
    if (self) {
        self.rootPath = rootPath;
    }
    
    return self;
}

- (instancetype)initWithEntityName:(NSString *)entityName {
    self = [super init];
    if (self) {
        _attributeMap = [NSMutableDictionary new];
        _relationshipMap = [NSMutableDictionary new];

        _entityName = [entityName copy];
    }

    return self;
}

- (instancetype)initWithEntityName:(NSString *)entityName rootPath:(NSString *)rootPath {
    self = [self initWithEntityName:entityName];
    if (self) {
        self.rootPath = rootPath;
    }
    
    return self;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    FEMMapping *mapping = nil;
    if (self.objectClass) {
        mapping = [[self.class allocWithZone:zone] initWithObjectClass:self.objectClass];
    } else {
        mapping = [[self.class allocWithZone:zone] initWithEntityName:self.entityName];
    }
    
    mapping.rootPath = self.rootPath;
    mapping.primaryKey = self.primaryKey;
    
    for (FEMAttribute *attribute in self.attributes) {
        [mapping addAttribute:[attribute copy]];
    }
    
    for (FEMRelationship *relationship in self.relationships) {
        // recursive mapping copy will lead to infinite recursive copying
        if (relationship.mapping == self) {
            [mapping addRecursiveRelationshipMappingForProperty:relationship.property keypath:relationship.keyPath];
        } else {
            [mapping addRelationship:[relationship copy]];
        }
    }
    
    return mapping;
}

#pragma mark - Attribute Mapping

- (void)addPropertyMapping:(id<FEMProperty>)propertyMapping toMap:(NSMutableDictionary *)map {
	NSParameterAssert(propertyMapping);
	NSAssert(
		propertyMapping.property.length > 0,
		@"It's illegal to add mapping without specified property:%@",
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

- (void)setEntityName:(NSString *)entityName {
    _entityName = [entityName copy];
    if (_entityName) {
        _objectClass = nil;
    }
}

- (void)setObjectClass:(Class)objectClass {
    _objectClass = objectClass;
    if (_objectClass) {
        _entityName = nil;
    }
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
    FEMRelationship *relationship = [[FEMRelationship alloc] initWithProperty:property keyPath:keyPath mapping:mapping];
    [self addRelationship:relationship];
}

- (void)addRecursiveRelationshipMappingForProperty:(NSString *)property keypath:(NSString *)keyPath {
    FEMRelationship *relationship = [[FEMRelationship alloc] initWithProperty:property keyPath:keyPath mapping:self];
    [self addRelationship:relationship];
}

- (void)addToManyRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath {
    FEMRelationship *relationship = [[FEMRelationship alloc] initWithProperty:property keyPath:keyPath mapping:mapping];
    relationship.toMany = YES;
    [self addRelationship:relationship];
}

- (void)addRecursiveToManyRelationshipForProperty:(nonnull NSString *)property keypath:(nullable NSString *)keyPath
{
    FEMRelationship *relationship = [[FEMRelationship alloc] initWithProperty:property keyPath:keyPath mapping:self];
    relationship.toMany = YES;
    [self addRelationship:relationship];
}

@end

@implementation FEMMapping (Deprecated)

+ (FEMMapping *)mappingForEntityName:(NSString *)entityName {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:entityName];
    return mapping;
}

+ (FEMMapping *)mappingForEntityName:(NSString *)entityName
                       configuration:(void (^)(FEMManagedObjectMapping *sender))configuration {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:entityName];
    configuration(mapping);
    return mapping;
}

+ (FEMMapping *)mappingForEntityName:(NSString *)entityName
                            rootPath:(NSString *)rootPath
                       configuration:(void (^)(FEMManagedObjectMapping *sender))configuration {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:entityName rootPath:rootPath];
    configuration(mapping);
    return mapping;
}


+ (FEMMapping *)mappingForClass:(Class)objectClass configuration:(void (^)(FEMObjectMapping *mapping))configuration {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:objectClass];
    configuration(mapping);
    return mapping;
}

+ (FEMMapping *)mappingForClass:(Class)objectClass rootPath:(NSString *)rootPath configuration:(void (^)(FEMObjectMapping *mapping))configuration {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:objectClass rootPath:rootPath];
    configuration(mapping);
    return mapping;
}

@end
