// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@protocol FEMProperty <NSObject>

@property (nonatomic, copy, readonly) NSString *property;
@property (nonatomic, copy) NSString *keyPath;

@end