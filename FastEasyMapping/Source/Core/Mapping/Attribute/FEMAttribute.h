// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMProperty.h"
#import "FEMTypes.h"

@interface FEMAttribute : NSObject <FEMProperty>

- (id)mapValue:(id)value;
- (id)reverseMapValue:(id)value;

- (id)initWithProperty:(NSString *)property keyPath:(NSString *)keyPath map:(FEMMapBlock)map reverseMap:(FEMMapBlock)reverseMap;
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath map:(FEMMapBlock)map reverseMap:(FEMMapBlock)reverseMap;

@end

@interface FEMAttribute (Shortcut)

/**
* same as +[FEMAttribute mappingOfProperty:property toKeyPath:property];
*/
+ (instancetype)mappingOfProperty:(NSString *)property;

/**
* same as +[FEMAttribute mappingOfProperty:property toKeyPath:nil map:NULL];
*/
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath;

/**
* same as +[FEMAttribute mappingOfProperty:property toKeyPath:nil map:map];
*/
+ (instancetype)mappingOfProperty:(NSString *)property map:(FEMMapBlock)map;

/**
* same as +[FEMAttribute mappingOfProperty:property toKeyPath:nil map:NULL reverseMap:NULL];
*/
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath map:(FEMMapBlock)map;

/**
* create mapping object, based on NSDateFormatter.
* NSDateFormatter instance uses en_US_POSIX locale and UTC Timezone
*/
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath dateFormat:(NSString *)dateFormat;

/**
* property represented by NSURL, value at keyPath - NSString
*/
+ (instancetype)mappingOfURLProperty:(NSString *)property toKeyPath:(NSString *)keyPath;

@end