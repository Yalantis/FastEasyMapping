// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMTypes.h"
#import "FEMProperty.h"

NS_ASSUME_NONNULL_BEGIN

@interface FEMAttribute : NSObject <FEMProperty>

- (nullable id)mapValue:(nullable id)value;
- (nullable id)reverseMapValue:(nullable id)value;

- (instancetype)initWithProperty:(NSString *)property keyPath:(nullable NSString *)keyPath map:(nullable FEMMapBlock)map reverseMap:(nullable FEMMapBlock)reverseMap;
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(nullable NSString *)keyPath map:(nullable FEMMapBlock)map reverseMap:(nullable FEMMapBlock)reverseMap;

@end

@interface FEMAttribute (Shortcut)

/**
* same as +[FEMAttribute mappingOfProperty:property toKeyPath:property];
*/
+ (instancetype)mappingOfProperty:(NSString *)property;

/**
* same as +[FEMAttribute mappingOfProperty:property toKeyPath:nil map:NULL];
*/
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(nullable NSString *)keyPath;

/**
* same as +[FEMAttribute mappingOfProperty:property toKeyPath:nil map:map];
*/
+ (instancetype)mappingOfProperty:(NSString *)property map:(FEMMapBlock)map;

+ (instancetype)mappingOfProperty:(NSString *)property reverseMap:(FEMMapBlock)reverseMap;

/**
* same as +[FEMAttribute mappingOfProperty:property toKeyPath:nil map:NULL reverseMap:NULL];
*/
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(nullable NSString *)keyPath map:(FEMMapBlock)map;

/**
* create mapping object, based on NSDateFormatter.
* NSDateFormatter instance uses en_US_POSIX locale and UTC Timezone
*/
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(nullable NSString *)keyPath dateFormat:(NSString *)dateFormat;

/**
* property represented by NSURL, value at keyPath - NSString
*/
+ (instancetype)mappingOfURLProperty:(NSString *)property toKeyPath:(nullable NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END