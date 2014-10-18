// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMObjectMapping.h"

@implementation FEMObjectMapping

#pragma mark - Init

- (id)initWithObjectClass:(Class)objectClass rootPath:(NSString *)rootPath {
	self = [self initWithRootPath:rootPath];
	if (self) {
		_objectClass = objectClass;
	}
	return self;
}

- (id)initWithObjectClass:(Class)objectClass {
	return [self initWithObjectClass:objectClass rootPath:nil];
}

+ (instancetype)mappingForClass:(Class)objectClass configuration:(void (^)(FEMObjectMapping *mapping))configuration {
	FEMObjectMapping *mapping = [[self alloc] initWithObjectClass:objectClass];
	configuration(mapping);
	return mapping;
}

+ (instancetype)mappingForClass:(Class)objectClass
                       rootPath:(NSString *)rootPath
		          configuration:(void (^)(FEMObjectMapping *mapping))configuration {
	FEMObjectMapping *mapping = [[self alloc] initWithObjectClass:objectClass rootPath:rootPath];
	configuration(mapping);
	return mapping;
}

#pragma mark - Description

- (NSString *)description {
    NSString *descriptionFormat = [super description];
    return [NSString stringWithFormat:descriptionFormat, @"Object Class:%@", NSStringFromClass(self.objectClass)];
}

@end