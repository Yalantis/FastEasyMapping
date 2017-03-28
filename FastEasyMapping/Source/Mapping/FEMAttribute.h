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
@interface FEMAttribute : NSObject <FEMProperty, NSCopying>

/**
 @brief Initialize FEMAttribute with a given property and a keyPath and transformation blocks for value transformation.
 
 @discussion Returns a new FEMAttribute for a given property and a keyPath.
 Block `map` will be executed before value applied from the JSON to the Object's property.
 Block `reverseMap` - when Object's property value transfomed to the JSON.
 
 @param property   Object's property name (same as for the KVC).
 @param keyPath    JSON's keyPath to the value (optional).
 @param map        Transform of the value before applying it from the JSON to the Object's property. If `nil` - no transformation perfomed.
 @param reverseMap Transform of the value before applying it from the Object's property to the JSON. If `nil` - no transformation perfomed.

 @return New instance of the FEMAttribute.
 */
- (instancetype)initWithProperty:(NSString *)property keyPath:(nullable NSString *)keyPath map:(nullable FEMMapBlock)map reverseMap:(nullable FEMMapBlock)reverseMap NS_DESIGNATED_INITIALIZER;

/// Shortcut the for -[FEMAttribute initWithProperty:keyPath:map:reverseMap:]. See original `-initWithProperty:keyPath:map:reverseMap:` for full documentation.
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(nullable NSString *)keyPath map:(nullable FEMMapBlock)map reverseMap:(nullable FEMMapBlock)reverseMap;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 @brief Initialize FEMAttribute with a given property and a keyPath.
 
 @discussion Returns new FEMAttribute for a given property and a keyPath. JSON Value doesn't require any additional transformation
 and will be applied as it is to the Object's attribute (therefore String to String, Int to Int and so on).
 
 @param property Object's property name (same as for the KVC)
 @param keyPath  JSON's keyPath to the value (optional)
 
 @return New instance of the FEMAttribute.
 */
- (instancetype)initWithProperty:(NSString *)property keyPath:(nullable NSString *)keyPath;


/**
 @brief Map given `value` using `map` block passed in the -init (if any). This function doesn't have any side effect on the Object's property / JSON.
 
 @discussion Developer most likely will never invoke this function on his own. Utilized by FEMDeserializer internals.
 
 @param value JSON's value that is going to be applied to the Object's property.

 @return Mapped value or the same if no mapping specified.
 */
- (nullable id)mapValue:(nullable id)value;

/**
 @brief Map given `value` using `reverseMap` block passed in the -init (if any). This function doesn't have any side effect on the Object's property / JSON.
 
 @discussion Developer most likely will never invoke this function on his own. Utilized by FEMSerializer internals.
 
 @param value Object's property value that is going to be applied to the JSON.
 
 @return Mapped value or the same if no mapping specified.
 */
- (nullable id)reverseMapValue:(nullable id)value;

@end

@interface FEMAttribute (Shortcut)

/**
 @brief FEMAttribute that doesn't have a keyPath (`keyPath = nil`) and value doesn't require any additional tranforms.

 @discussion Equivalent for `-[FEMAttribute initWithProperty:property keyPath:nil map:nil reverseMap:nil]`
 
 @param property name of the property (same as for the KVC).

 @return New instance of the FEMAttribute.
 */
+ (instancetype)mappingOfProperty:(NSString *)property;

/**
 @brief FEMAttribute where value doesn't require any additional tranforms.

 @discussion Equivalent for `-[FEMAttribute initWithProperty:property keyPath:keyPath map:nil reverseMap:nil]`

 @param property name of the property (same as for the KVC).
 @param keyPath  JSON's keyPath to the value (optional).

 @return New instance of the FEMAttribute.
 */
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(nullable NSString *)keyPath;

/**
 @brief FEMAttribute that doesn't have a keyPath (`keyPath = nil`) and requires transformation from JSON to Object's property.

 @discussion Useful in case Object only needs to be deserialized (from JSON to Object) and JSON's value requires transformation. 
 Equivalent for `-[FEMAttribute initWithProperty:property keyPath:nil map:map reverseMap:nil]`
 
 @param property name of the property (same as for the KVC).
 @param map      Transform of the value before applying it from the JSON to the Object's property.

 @return New instance of the FEMAttribute.
 */
+ (instancetype)mappingOfProperty:(NSString *)property map:(FEMMapBlock)map;

/**
 @brief Shortcut for FEMAttribute that doesn't have a keyPath (`keyPath = nil`) and requires transformation from JSON to Object's property.
 
 @discussion Useful in case Object only needs to be serialized (from Object to JSON) and Object's property value requires transformation.
 Equivalent for `-[FEMAttribute initWithProperty:property keyPath:nil map:nil reverseMap:reverseMap]`
 
 @param property name of the property (same as for the KVC).
 @param reverseMap Transform of the value before applying it from the Object's property to the JSON.
 
 @return New instance of the FEMAttribute.
 */
+ (instancetype)mappingOfProperty:(NSString *)property reverseMap:(FEMMapBlock)reverseMap;

/**
 @brief FEMAttribute where value requires transformation from JSON to Object's property.
 
 @discussion Useful in case Object only needs to be deserialized (from JSON to Object) and JSON's value requires transformation.
 Equivalent for `-[FEMAttribute initWithProperty:property keyPath:keyPath map:map reverseMap:nil]`
 
 @param property name of the property (same as for the KVC).
 @param keyPath  JSON's keyPath to the value (optional).
 @param map      Transform of the value before applying it from the JSON to the Object's property.
 
 @return New instance of the FEMAttribute.
 */
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(nullable NSString *)keyPath map:(FEMMapBlock)map;

/**
 @brief FEMAttribute that maps to Object's NSDate from JSON's String using given date format.
 
 @discussion FEMAttribute that uses `NSDateFormatter` to map String from the JSON to the NSDate.
 Used locale identifier: en_US_POSIX, time zone: UTC.
 
 @param property   name of the property (same as for the KVC).
 @param keyPath    JSON's keyPath to the value (optional).
 @param dateFormat date format used by NSDateFormatter. For example `yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ` for `2016-09-03T10:12:21.121+02:00`

 @return New instance of the FEMAttribute.
 */
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(nullable NSString *)keyPath dateFormat:(NSString *)dateFormat;

/**
 @brief FEMAttribute that maps to Object's NSURL from JSON's String.
 
 @discussion FEMAttribute that maps String from the JSON to the NSURL using `-[NSURL initWithString:]`. Reverse map returns `-[NSURL absoluteString]`
 
 @param property   name of the property (same as for the KVC).
 @param keyPath    JSON's keyPath to the value (optional).

 @return New instance of the FEMAttribute.
 */
+ (instancetype)mappingOfURLProperty:(NSString *)property toKeyPath:(nullable NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
