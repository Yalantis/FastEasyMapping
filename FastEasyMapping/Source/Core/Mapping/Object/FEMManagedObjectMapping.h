//
//  FEMManagedObjectMapping.h
//  EasyMappingExample
//
//  Created by Alejandro Isaza on 2013-03-13.
//  Copyright (c) 2013 Alejandro Isaza. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FEMTypes.h"
#import "FEMMapping.h"

@interface FEMManagedObjectMapping : FEMMapping

@property (nonatomic, copy, readonly) NSString *entityName;
@property (nonatomic, copy) NSString *primaryKey;

@property (nonatomic, strong, readonly) FEMAttribute *primaryKeyAttribute;

+ (FEMManagedObjectMapping *)mappingForEntityName:(NSString *)entityName;
+ (FEMManagedObjectMapping *)mappingForEntityName:(NSString *)entityName
                                    configuration:(void (^)(FEMManagedObjectMapping *sender))configuration;
+ (FEMManagedObjectMapping *)mappingForEntityName:(NSString *)entityName
                                         rootPath:(NSString *)rootPath
		                            configuration:(void (^)(FEMManagedObjectMapping *sender))configuration;

- (id)initWithEntityName:(NSString *)entityName;
- (id)initWithEntityName:(NSString *)entityName rootPath:(NSString *)rootPath;

@end

@interface FEMManagedObjectMapping (Deprecated)

@property (nonatomic, strong, readonly) FEMAttributeMapping *primaryKeyMapping __attribute__((deprecated("will become obsolete in 0.6.0; use -[FEMManagedObjectMapping primaryKeyAttribute] instead")));

@end