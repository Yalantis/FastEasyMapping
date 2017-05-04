// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMRelationship.h"
#import "FEMMapping.h"
#import "FEMObjectRef.h"

@interface FEMRelationship ()

@property (nonatomic) FEMObjectRef<FEMMapping *> *mappingRef;

@end

@implementation FEMRelationship

@synthesize property = _property;
@synthesize keyPath = _keyPath;

#pragma mark - Init

- (instancetype)initWithProperty:(NSString *)property mapping:(FEMMapping *)mapping {
    return [self initWithProperty:property keyPath:nil mapping:mapping];
}

- (instancetype)initWithProperty:(NSString *)property keyPath:(NSString *)keyPath mapping:(FEMMapping *)mapping {
    self = [super init];
    if (self) {
        self.property = property;
        self.keyPath = keyPath;
        self.mapping = mapping;
        self.assignmentPolicy = FEMAssignmentPolicyAssign;
    }

    return self;
}

- (instancetype)initWithProperty:(NSString *)property keyPath:(NSString *)keyPath mapping:(FEMMapping *)mapping assignmentPolicy:(FEMAssignmentPolicy)assignmentPolicy {
    self = [self initWithProperty:property keyPath:keyPath mapping:mapping];
    if (self) {
        self.assignmentPolicy = assignmentPolicy;
    }
    return self;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    FEMRelationship *relationship = [[FEMRelationship allocWithZone:zone] initWithProperty:self.property keyPath:self.keyPath mapping:[self.mapping copy]];
    relationship.assignmentPolicy = self.assignmentPolicy;
    relationship.toMany = self.toMany;
    relationship.weak = self.weak;
    return relationship;
}

#pragma mark - Shortcut

- (void)setMapping:(nonnull FEMMapping *)mapping forKeyPath:(nullable NSString *)keyPath {
    self.mapping = mapping;
    self.keyPath = keyPath;
}

#pragma mark - Description

- (NSString *)description {
    return [NSString stringWithFormat:
        @"<%@ %p>\n {\nproperty:%@ keyPath:%@ toMany:%@\nmapping:(%@)}\n",
        NSStringFromClass(self.class),
        (__bridge void *) self,
        self.property,
        self.keyPath,
        @(self.toMany),
        [self.mapping description]
    ];
}

#pragma mark - Recursive Relationships Support

- (BOOL)isRecursive {
    return self.owner == self.mapping;
}

- (void)setMapping:(FEMMapping *)mapping {
    if (mapping != nil) {
        self.mappingRef = [[FEMObjectRef alloc] initWithValue:mapping];
        self.mappingRef.useWeakOwnership = mapping == self.owner;
    } else {
        self.mappingRef = nil;
    }
}

- (FEMMapping *)mapping {
    return self.mappingRef.value;
}

- (void)setOwner:(FEMMapping *)owner {
    _owner = owner;
    
    self.mappingRef.useWeakOwnership = self.mapping == owner;
}

@end

@implementation FEMRelationship (Deprecated)

@dynamic objectMapping;

- (FEMMapping *)objectMapping {
    return self.mapping;
}

- (void)setObjectMapping:(FEMMapping *)objectMapping {
    self.mapping = objectMapping;
}

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath objectMapping:(FEMMapping *)objectMapping {
    return [[self alloc] initWithProperty:property keyPath:keyPath mapping:objectMapping];
}

#pragma mark - Init

- (instancetype)initWithProperty:(NSString *)property
                         keyPath:(NSString *)keyPath
                assignmentPolicy:(FEMAssignmentPolicy)policy
                   objectMapping:(FEMMapping *)objectMapping {
    return [self initWithProperty:property keyPath:keyPath mapping:objectMapping assignmentPolicy:policy];
}

+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath objectMapping:(FEMMapping *)objectMapping {
    return [[self alloc] initWithProperty:property keyPath:keyPath mapping:objectMapping];
}

+ (instancetype)mappingOfProperty:(NSString *)property objectMapping:(FEMMapping *)objectMapping {
    return [[self alloc] initWithProperty:property mapping:objectMapping];
}

#pragma mark - Property objectMapping

- (void)setObjectMapping:(FEMMapping *)objectMapping forKeyPath:(NSString *)keyPath {
    [self setMapping:objectMapping forKeyPath:keyPath];
}

@end
