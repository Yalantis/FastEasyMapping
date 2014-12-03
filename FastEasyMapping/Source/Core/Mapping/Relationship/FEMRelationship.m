// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMRelationship.h"
#import "FEMMapping.h"

@implementation FEMRelationship

@synthesize property = _property;
@synthesize keyPath = _keyPath;

#pragma mark - Init

- (instancetype)initWithProperty:(NSString *)property
                         keyPath:(NSString *)keyPath
                assignmentPolicy:(FEMAssignmentPolicy)policy
                   objectMapping:(FEMMapping *)objectMapping {
	NSParameterAssert(property.length > 0);

	self = [super init];
	if (self) {
		_property = [property copy];
        _keyPath = [keyPath copy];
        _assignmentPolicy = (FEMAssignmentPolicy)[policy copy] ?: FEMAssignmentPolicyAssign;
        _objectMapping = objectMapping;
	}

	return self;
}

+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath configuration:(void (^)(FEMRelationship *mapping))configuration {
	NSParameterAssert(configuration);

	FEMRelationship *mapping = [[self alloc] initWithProperty:property
                                                             keyPath:keyPath
                                                    assignmentPolicy:NULL
                                                       objectMapping:nil];
	configuration(mapping);
	return mapping;
}

+ (instancetype)mappingOfProperty:(NSString *)property configuration:(void (^)(FEMRelationship *mapping))configuration {
	return [self mappingOfProperty:property toKeyPath:nil configuration:configuration];
}

+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath objectMapping:(FEMMapping *)objectMapping {
	return [[self alloc] initWithProperty:property keyPath:keyPath assignmentPolicy:NULL objectMapping:objectMapping];
}

+ (instancetype)mappingOfProperty:(NSString *)property objectMapping:(FEMMapping *)objectMapping {
    return [self mappingOfProperty:property toKeyPath:nil objectMapping:objectMapping];
}

#pragma mark - Property objectMapping

- (void)setObjectMapping:(FEMMapping *)objectMapping forKeyPath:(NSString *)keyPath {
    _objectMapping = objectMapping;

	[self setKeyPath:keyPath];
}

- (void)setObjectMapping:(FEMMapping *)objectMapping {
    [self setObjectMapping:objectMapping forKeyPath:nil];
}

#pragma mark - Description

- (NSString *)description {
    return [NSString stringWithFormat:
        @"<%@ %p>\n {\nproperty:%@ keyPath:%@ toMany:%@\nobjectMapping:(%@)}\n",
        NSStringFromClass(self.class),
        (__bridge void *) self,
        self.property,
        self.keyPath,
        @(self.toMany),
        [self.objectMapping description]
    ];
}

@end

@implementation FEMRelationship (Deprecated)

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath configuration:(void (^)(FEMRelationship *mapping))configuration {
    return [self mappingOfProperty:property toKeyPath:keyPath configuration:configuration];
}

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath objectMapping:(FEMMapping *)objectMapping {
    return [self mappingOfProperty:property toKeyPath:keyPath objectMapping:objectMapping];
}

@end

@implementation FEMRelationship (Extension)

- (id)extractRootFromExternalRepresentation:(id)externalRepresentation {
	if (self.keyPath) return [externalRepresentation valueForKeyPath:self.keyPath];

	return externalRepresentation;
}

@end