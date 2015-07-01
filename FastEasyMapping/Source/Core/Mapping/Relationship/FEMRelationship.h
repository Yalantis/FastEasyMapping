// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMAssignmentPolicy.h"
#import "FEMProperty.h"

@class FEMMapping;

@interface FEMRelationship : NSObject <FEMProperty>

@property (nonatomic, copy, nonnull) FEMAssignmentPolicy assignmentPolicy;

@property (nonatomic) BOOL weak;
@property (nonatomic, strong, nonnull) FEMMapping *objectMapping;
@property (nonatomic, getter=isToMany) BOOL toMany;

- (void)setObjectMapping:(nonnull FEMMapping *)objectMapping forKeyPath:(nullable NSString *)keyPath;

- (nonnull instancetype)initWithProperty:(nonnull NSString *)property
                                 keyPath:(nullable NSString *)keyPath
                        assignmentPolicy:(nullable FEMAssignmentPolicy)policy
                           objectMapping:(nullable FEMMapping *)objectMapping NS_DESIGNATED_INITIALIZER;

+ (nonnull instancetype)mappingOfProperty:(nonnull NSString *)property
                            configuration:(nonnull void (^)(FEMRelationship * __nonnull mapping))configuration;

+ (nonnull instancetype)mappingOfProperty:(nonnull NSString *)property
                                toKeyPath:(nullable NSString *)keyPath
                            configuration:(nonnull void (^)(FEMRelationship * __nonnull mapping))configuration;

/**
* same as + [FEMRelationship mappingOfProperty:property toKeyPath:nil objectMapping:objectMapping];
*/
+ (nonnull instancetype)mappingOfProperty:(nonnull NSString *)property objectMapping:(nonnull FEMMapping *)objectMapping;
+ (nonnull instancetype)mappingOfProperty:(nonnull NSString *)property
                                toKeyPath:(nullable NSString *)keyPath
                            objectMapping:(nonnull FEMMapping *)objectMapping;

@end