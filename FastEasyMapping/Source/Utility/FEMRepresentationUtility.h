// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMMapping, FEMAttribute;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN id FEMRepresentationRootForKeyPath(id representation, NSString *keyPath);

FOUNDATION_EXTERN NSDictionary *FEMRepresentationCollectPresentedPrimaryKeys(id representation, FEMMapping *mapping);

FOUNDATION_EXTERN _Nullable id FEMRepresentationValueForAttribute(id representation, FEMAttribute *attribute);

NS_ASSUME_NONNULL_END