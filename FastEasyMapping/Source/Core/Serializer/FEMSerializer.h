// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>
#import "FEMMapping.h"
#import "FEMSerializer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Serializer from Object to JSON using FEMMapping.
 
 @discussion Most of the time you're going to use FEMSerializer with FEMMapping in order to get JSON from the Object back.
 */
@interface FEMSerializer : NSObject

/**
 @brief Serialize Object to JSON using given `mapping`.
 
 @discussion Serializer iterates over attributes and relationships of the given `object` and transform them to the NSDictionary
 which later can be used for NSJSONSerialization for example. 
 
 Attributes Serialization
 By default Serializer use attribute's value without any transform. Therefore String to String, Number to Number and so on. 
 In case you want to perform additional transforms before Object's attribute gets mapped into a JSON `-[FEMAttribure reverseMapValue:]` is
 going to be used. Here is an example of FEMAttribute that converts String to Number and back:
 
 @code
 FEMAttribute *someAttribute = [FEMAttribute mappingOfProperty:@"stringValue" toKeyPath:@"number_value" map:^(id value) {
     // value from the JSON might be of NSNull class, therefore we have to check whether it is a real NSNumber
     if ([value isKindOfClass:[NSNumber class]]) {
         return [value stringValue];
     }
     // it is not a number, so we return either a default value or nil / NSNull (both treated identically)
     return nil;
 } reverseMap:^(id value) {
     // reverse mapping: when object is serialized back to the JSON representation
     // type of the value is NSString. However value can be nil (depends on your use case).
     if (value != nil) { 
         // for simplicity we do not use any number formatter for parsing
         return @([value integerValue]);
     }
 
     return nil; // nil value will be replaced by Null in JSON.
 }];
 @endcode
 
 Root Path
 In case `mapping.rootPath` is not empty, returned object will be "embeded" within rootPath. For example for `rootPath = user` result is similar to:
 @code
 {
     "user": {
         "id": 42,
         "username": "john@doe.com"
     }
 }
 @endcode
 
 IMPORTANT: Currently complex `rootPath` such as `some.key.path` are not supported and will lead to the:
 @code
 {
    "root.key.path": {
        // embed json
    }
 }
 @endcode
 
 @param object  Object that is going to be serialized to JSON.
 @param mapping Mapping describing how to map given `object` to JSON.
 
 @see FEMAttribute

 @return Representation of Object in form of Dictionary.
 */
+ (NSDictionary *)serializeObject:(id)object usingMapping:(FEMMapping *)mapping;


/**
 @brief Serialize Collection of Objects to JSON using given `mapping`.

 @discussion Behavior is similar to `+serializeObject:usingMapping:` but with some exceptions. While for `+serializeObject:usingMapping:`
 return type is always `NSDictionary`, for `+serializeCollection:usingMapping:` return type depends on whether `mapping.rootPath` presented or not.
 In case `rootPath` is empty, return type is an NSArray. For non-empty `rootPath` return type is NSDictionary and has following representation:
 @code
 {
     "rootPath": [
         // collection of Objects representations
     ]
 }
 @endode
 
 @param collection Collection of Objects that are going to be serialized to the JSON.
 @param mapping Mapping describing how to map given `object` to the JSON.
 
 @see FEMAttribute
 
 @return Representation of Object in form of Dictionary.
 */
+ (id)serializeCollection:(NSArray *)collection usingMapping:(FEMMapping *)mapping;

@end

NS_ASSUME_NONNULL_END
