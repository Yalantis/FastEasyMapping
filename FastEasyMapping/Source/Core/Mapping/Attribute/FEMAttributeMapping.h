// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMPropertyMapping.h"
#import "FEMTypes.h"

@interface FEMAttributeMapping : NSObject <FEMPropertyMapping>

- (id)mapValue:(id)value;
- (id)reverseMapValue:(id)value;

- (id)initWithProperty:(NSString *)property keyPath:(NSString *)keyPath map:(FEMMapBlock)map reverseMap:(FEMMapBlock)reverseMap;
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath map:(FEMMapBlock)map reverseMap:(FEMMapBlock)reverseMap;

@end

@interface FEMAttributeMapping (Shortcut)

/**
* same as +[FEMAttributeMapping mappingOfProperty:property toKeyPath:property];
*/
+ (instancetype)mappingOfProperty:(NSString *)property;

/**
* same as +[FEMAttributeMapping mappingOfProperty:property toKeyPath:nil map:NULL];
*/
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath;

/**
* same as +[FEMAttributeMapping mappingOfProperty:property toKeyPath:nil map:map];
*/
+ (instancetype)mappingOfProperty:(NSString *)property map:(FEMMapBlock)map;

/**
* same as +[FEMAttributeMapping mappingOfProperty:property toKeyPath:nil map:NULL reverseMap:NULL];
*/
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath map:(FEMMapBlock)map;

/**
* create mapping object, based on NSDateFormatter.
* NSDateFormatter instance uses en_US_POSIX locale and Timezone with name "Europe/London"
*/
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath dateFormat:(NSString *)dateFormat;

/**
* property represented by NSURL, value at keyPath - NSString
*/
+ (instancetype)mappingOfURLProperty:(NSString *)property toKeyPath:(NSString *)keyPath;

@end

@interface FEMAttributeMapping (Deprecated)

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath __attribute__((deprecated("will become obsolete in 0.5.0; use +[FEMAttributeMapping mappingOfProperty:toKeyPath: instead")));
+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath map:(FEMMapBlock)map __attribute__((deprecated("will become obsolete in 0.5.0;use +[FEMAttributeMapping mappingOfProperty:toKeyPath:map: instead")));
+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath dateFormat:(NSString *)dateFormat __attribute__((deprecated("will become obsolete in 0.5.0; use +[FEMAttributeMapping mappingOfProperty:toKeyPath:dateFormat: instead")));
+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath map:(FEMMapBlock)map reverseMap:(FEMMapBlock)reverseMap __attribute__((deprecated("will become obsolete in 0.5.0; use +[FEMAttributeMapping mappingOfProperty:toKeyPath:reverseMap: instead")));

@end