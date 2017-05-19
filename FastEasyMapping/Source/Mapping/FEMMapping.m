// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMMapping.h"

@interface FEMMapping ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, FEMAttribute *> *attributeMap;
@property (nonatomic, strong) NSMutableDictionary<NSString *, FEMRelationship *> *relationshipMap;

@end

@implementation FEMMapping

#pragma mark - Init

- (instancetype)initWithObjectClass:(Class)objectClass {
    self = [super init];
    if (self) {
        _attributeMap = [NSMutableDictionary new];
        _relationshipMap = [NSMutableDictionary new];

        _objectClass = objectClass;
        _uniqueIdentifier = @((NSUInteger)objectClass);
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
        _uniqueIdentifier = @(entityName.hash);
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
        FEMRelationship *relationshipCopy = [relationship copy];
        
        if (relationship.recursive) {
            relationshipCopy.mapping = mapping;
        }
        
        [mapping addRelationship:relationshipCopy];
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
    [self addPropertyMapping:attribute toMap:self.attributeMap];
}

- (FEMAttribute *)attributeForProperty:(NSString *)property {
	return self.attributeMap[property];
}

#pragma mark - Relationship Mapping

- (void)addRelationship:(FEMRelationship *)relationship {
    relationship.owner = self;
    [self addPropertyMapping:relationship toMap:self.relationshipMap];
}

- (FEMRelationship *)relationshipForProperty:(NSString *)property {
	return self.relationshipMap[property];
}

#pragma mark - Properties

- (NSArray *)attributes {
	return [self.attributeMap allValues];
}

- (NSArray *)relationships {
	return [self.relationshipMap allValues];
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
    return self.attributeMap[self.primaryKey];
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

- (void)flattenInCollection:(NSMutableSet<FEMMapping *> *)collection {
    [collection addObject:self];

    for (FEMRelationship *relationship in self.relationships) {
        if (!relationship.recursive) {
            [relationship.mapping flattenInCollection:collection];
        }
    }
}

- (NSSet<FEMMapping *> *)flatten {
    NSMutableSet *set = [[NSMutableSet alloc] init];

    [self flattenInCollection:set];

    return [set copy];
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

- (void)addRecursiveToManyRelationshipForProperty:(nonnull NSString *)property keypath:(nullable NSString *)keyPath {
    FEMRelationship *relationship = [[FEMRelationship alloc] initWithProperty:property keyPath:keyPath mapping:self];
    relationship.toMany = YES;
    [self addRelationship:relationship];
}

@end
