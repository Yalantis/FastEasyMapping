// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMProperty.h"
#import "FEMAssignmentPolicy.h"

@class FEMMapping;

@interface FEMRelationship : NSObject <FEMProperty>

@property (nonatomic, copy) FEMAssignmentPolicy assignmentPolicy;

@property (nonatomic, strong) FEMMapping *objectMapping;
@property (nonatomic, getter=isToMany) BOOL toMany;

- (void)setObjectMapping:(FEMMapping *)objectMapping forKeyPath:(NSString *)keyPath;

- (instancetype)initWithProperty:(NSString *)property
                         keyPath:(NSString *)keyPath
                assignmentPolicy:(FEMAssignmentPolicy)policy
                   objectMapping:(FEMMapping *)objectMapping;

+ (instancetype)mappingOfProperty:(NSString *)property
                    configuration:(void (^)(FEMRelationship *mapping))configuration;
+ (instancetype)mappingOfProperty:(NSString *)property
                        toKeyPath:(NSString *)keyPath
                    configuration:(void (^)(FEMRelationship *mapping))configuration;

/**
* same as + [FEMRelationship mappingOfProperty:property toKeyPath:nil objectMapping:objectMapping];
*/
+ (instancetype)mappingOfProperty:(NSString *)property objectMapping:(FEMMapping *)objectMapping;
+ (instancetype)mappingOfProperty:(NSString *)property
                        toKeyPath:(NSString *)keyPath
                    objectMapping:(FEMMapping *)objectMapping;

@end

@interface FEMRelationship (Extension)

- (id)extractRootFromExternalRepresentation:(id)externalRepresentation;

@end