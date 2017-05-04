// For License please refer to LICENSE file in the root of FastEasyMapping project

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface FEMObjectRef<__covariant ValueType> : NSObject {
@private
    ValueType _strongValue;
    __weak ValueType _weakValue;
}

@property (nonatomic, readonly, nullable) ValueType value;

@property (nonatomic) BOOL useWeakOwnership; // default to NO

- (instancetype)initWithValue:(ValueType)value;

@end

NS_ASSUME_NONNULL_END
