// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMManagedObjectMapping.h"
#import "FEMAttribute.h"

@implementation FEMManagedObjectMapping

#pragma mark - Init

- (id)initWithEntityName:(NSString *)entityName rootPath:(NSString *)rootPath {
	self = [self initWithRootPath:rootPath];
	if (self) {
		_entityName = [entityName copy];
	}
	return self;
}

- (id)initWithEntityName:(NSString *)entityName {
	return [self initWithEntityName:entityName rootPath:nil];
}

+ (FEMManagedObjectMapping *)mappingForEntityName:(NSString *)entityName configuration:(void (^)(FEMManagedObjectMapping *sender))configuration {
	FEMManagedObjectMapping *mapping = [[FEMManagedObjectMapping alloc] initWithEntityName:entityName];
	configuration(mapping);
	return mapping;
}

+ (FEMManagedObjectMapping *)mappingForEntityName:(NSString *)entityName
                                         rootPath:(NSString *)rootPath
		                            configuration:(void (^)(FEMManagedObjectMapping *sender))configuration {
	FEMManagedObjectMapping *mapping = [[FEMManagedObjectMapping alloc] initWithEntityName:entityName
	                                                                              rootPath:rootPath];
	configuration(mapping);
	return mapping;
}

+ (FEMManagedObjectMapping *)mappingForEntityName:(NSString *)entityName {
	return [[self alloc] initWithEntityName:entityName rootPath:nil];
}

#pragma mark - Properties

- (FEMAttribute *)primaryKeyAttribute {
	return _attributeMap[self.primaryKey];
}

#pragma mark - Description

- (NSString *)description {
    NSString *descriptionFormat = [super description];
    return [NSString stringWithFormat:descriptionFormat, @"Entity:%@", self.entityName];
}

@end

@implementation FEMManagedObjectMapping (Deprecated)

- (FEMAttributeMapping *)primaryKeyMapping {
    return self.primaryKeyAttribute;
}

@end