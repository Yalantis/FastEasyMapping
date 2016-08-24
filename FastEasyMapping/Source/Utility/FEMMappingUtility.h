// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMMapping;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN void FEMMappingApply(FEMMapping *mapping, void (^apply)(FEMMapping *object));
FOUNDATION_EXTERN NSSet * FEMMappingCollectUsedEntityNames(FEMMapping *mapping);

NS_ASSUME_NONNULL_END