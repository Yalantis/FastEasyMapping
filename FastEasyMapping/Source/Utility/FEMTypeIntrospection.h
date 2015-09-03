// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN BOOL FEMObjectPropertyTypeIsScalar(id object, NSString *propertyName);

FOUNDATION_EXTERN NSString * FEMPropertyTypeStringRepresentation(objc_property_t property);

NS_ASSUME_NONNULL_END