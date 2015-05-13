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

@compatibility_alias FEMManagedObjectMapping FEMMapping;

@interface FEMMapping (FEMManagedObjectMapping_Deprecated)

+ (instancetype)mappingForEntityName:(NSString *)entityName __attribute__((deprecated("Use -[FEMMapping initWithEntityName:] instead")));
+ (instancetype)mappingForEntityName:(NSString *)entityName
                       configuration:(void (^)(FEMManagedObjectMapping *sender))configuration __attribute__((deprecated("Use -[FEMMapping initWithEntityName:] instead")));
+ (instancetype)mappingForEntityName:(NSString *)entityName
                            rootPath:(NSString *)rootPath
                                    configuration:(void (^)(FEMManagedObjectMapping *sender))configuration __attribute__((deprecated("Use -[FEMMapping initWithEntityName:rootPath:] instead")));

@end
