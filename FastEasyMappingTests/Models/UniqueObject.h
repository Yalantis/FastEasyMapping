// For License please refer to LICENSE file in the root of FastEasyMapping project

@import Foundation;

@class FEMMapping;

@interface UniqueObject : NSObject

@property (nonatomic) NSInteger integerPrimaryKey;
@property (nonatomic, copy) NSString *stringPrimaryKey;

@end

@interface UniqueObject (Mapping)

+ (FEMMapping *)defaultMapping;

@end
