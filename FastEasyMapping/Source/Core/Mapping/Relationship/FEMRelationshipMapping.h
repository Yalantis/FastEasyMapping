//
//  FEMRelationshipMapping.h
//  FastEasyMapping
//
//  Created by zen on 03/12/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "FEMRelationship.h"

/**
* @discussion
* FEMRelationshipMapping has been renamed to FEMRelationship
*/

@interface FEMRelationshipMapping

+ (instancetype)mappingOfProperty:(NSString *)property objectMapping:(FEMMapping *)objectMapping;
+ (instancetype)mappingOfProperty:(NSString *)property
                        toKeyPath:(NSString *)keyPath
                    objectMapping:(FEMMapping *)objectMapping;

@end

@interface FEMRelationshipMapping (Deprecated)

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath configuration:(void (^)(FEMRelationshipMapping *mapping))configuration __attribute__((deprecated("will become obsolete in 0.5.0; use + [FEMRelationshipMapping mappingOfProperty:toKeyPath:configuration:] instead")));
+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath objectMapping:(FEMMapping *)objectMapping __attribute__((deprecated("will become obsolete in 0.5.0; use + [FEMRelationshipMapping mappingOfProperty:toKeyPath:objectMapping:] instead")));

@end

@interface FEMRelationshipMapping (Extension)

- (id)representationFromExternalRepresentation:(id)externalRepresentation;

@end

@compatibility_alias FEMRelationshipMapping FEMRelationship;
