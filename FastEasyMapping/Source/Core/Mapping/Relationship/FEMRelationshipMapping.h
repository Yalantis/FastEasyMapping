// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMPropertyMapping.h"
#import "FEMAssignmentPolicy.h"

@class FEMMapping;

@interface FEMRelationshipMapping : NSObject <FEMPropertyMapping>

@property (nonatomic, copy) FEMAssignmentPolicy assignmentPolicy;

@property (nonatomic, strong) FEMMapping *objectMapping;
@property (nonatomic, getter=isToMany) BOOL toMany;

- (void)setObjectMapping:(FEMMapping *)objectMapping forKeyPath:(NSString *)keyPath;

- (instancetype)initWithProperty:(NSString *)property
                         keyPath:(NSString *)keyPath
                assignmentPolicy:(FEMAssignmentPolicy)policy
                   objectMapping:(FEMMapping *)objectMapping;

+ (instancetype)mappingOfProperty:(NSString *)property
                    configuration:(void (^)(FEMRelationshipMapping *mapping))configuration;
+ (instancetype)mappingOfProperty:(NSString *)property
                        toKeyPath:(NSString *)keyPath
                    configuration:(void (^)(FEMRelationshipMapping *mapping))configuration;

/**
* same as + [FEMRelationshipMapping mappingOfProperty:property toKeyPath:nil objectMapping:objectMapping];
*/
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

- (id)extractRootFromExternalRepresentation:(id)externalRepresentation;

@end