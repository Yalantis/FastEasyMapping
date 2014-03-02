//
//  EMKManagedObjectMapping.h
//  EasyMappingExample
//
//  Created by Alejandro Isaza on 2013-03-13.
//  Copyright (c) 2013 Alejandro Isaza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMKTypes.h"
#import "EMKMapping.h"

@class EMKAttributeMapping;

@interface EMKManagedObjectMapping : EMKMapping

@property (nonatomic, copy, readonly) NSString *entityName;
@property (nonatomic, copy) NSString *primaryKey;

@property (nonatomic, strong, readonly) EMKAttributeMapping *primaryKeyMapping;

+ (EMKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName
                                    configuration:(void (^)(EMKManagedObjectMapping *mapping))configuration;
+ (EMKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName
                                         rootPath:(NSString *)rootPath
		                            configuration:(void (^)(EMKManagedObjectMapping *mapping))configuration;

- (id)initWithEntityName:(NSString *)entityName;
- (id)initWithEntityName:(NSString *)entityName rootPath:(NSString *)rootPath;

@end
