// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMProperty.h"

NS_ASSUME_NONNULL_BEGIN

typedef _Nullable id (^FEMMapBlock)(_Nullable id value);

/**
 @brief Description of relationship between the Object's `attribute` and the JSON's `keyPath`.
 
 @discussion `FEMAttribute` main purpose is to encapsulate information about how to map specific value from the JSON to the Object's attribute and back (if needed).
 Most of the time primitive values that comes from the JSON dictionary such as String, Int, Double, etc do not require any special transformation and can be described without mappings. However when Object's attribute is a bit more complext - mapping can be applied. 
 
 Lets imagine following case: User has a `accessType` property, that (dis)allows some of the App's functionality. This value comes as a String in the JSON. However, we don't want to use string within the app, since it is error-prone due to typos. Thats why we need to use enum, that can be checked by compiler and easier to use / compare. Best place to do this converation is during the mapping of the JSON. Mapping for this case might looks like:
 
 @code
 // for simplicity in native code we're using following enum
 enum AccessType {
    case AccessTypeNone,
    case AccessTypeRead,
    case AccessTypeWrite,
    case AccessTypeReadWrite,
 };
 
 // json's expected values are: "read", "write" and "readwrite". We need to map them
 
 NSDictionary *accessTypeMap = @{
    @"read": @(AccessTypeRead),
    @"write": @(AccessTypeWrite),
    @"readwrite": @(AccessTypeReadWrite)
 };
 
 NSDictionary *accessTypeReverseMap = @{
    @(AccessTypeRead): @"read",
    @(AccessTypeWrite): @"write",
    @(AccessTypeReadWrite): @"readwrite"
 };
 
 FEMAttribute *accessType = [FEMAttribute mappingOfProperty:@"accessType" toKeyPath:@"access_type" map:^(id value) {
    // value from the JSON might be of NSNull class, therefore we have to check whether it is a real string
    if ([value isKindOfClass:[NSString class]]) {
        // if access map dictionary contains access type - return it, otherwise return None
        return accessTypeMap[value] ?: @(AccessTypeNone);
    }
 
    return @(AccessTypeNone); // it is a null and therefore we have to nullify our attribute or return some default value - None in our case.
 } reverseMap:^(id value) {
    // reverse mapping: when object is serialized back to the JSON representation
    
    // type of the value is the one, returned by the Key Value Coding. Therefore for enum we're expecting NSNumber, that boxes our enum's value.
    // for None case we're returning nil, that will be represented as a Null in the JSON
    return accessTypeReverseMap[value] ?: nil;
 }];
 
 @endcode
 */
@interface FEMAttribute : NSObject <FEMProperty>

- (instancetype)initWithProperty:(NSString *)property keyPath:(nullable NSString *)keyPath;
- (instancetype)initWithProperty:(NSString *)property keyPath:(nullable NSString *)keyPath map:(nullable FEMMapBlock)map reverseMap:(nullable FEMMapBlock)reverseMap;
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(nullable NSString *)keyPath map:(nullable FEMMapBlock)map reverseMap:(nullable FEMMapBlock)reverseMap;


- (nullable id)mapValue:(nullable id)value;
- (nullable id)reverseMapValue:(nullable id)value;


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
