// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>


/**
 @description Abstract representation of the relation between the Object's property (both attribute and relationship) and the JSON's keyPath.
 
 Imagine following Object:
 @code 
 @interface User 
 
 @property NSString *objectName;
 
 @end
 @endcode
 
 and expected JSON:
 @code
 {
    "json_name": "John Doe"
 }
 @endcode
 
 For this case "User.objectName" is going to be FEMProperty.property, while "json_name" - FEMProperty.keyPath.
 */
@protocol FEMProperty <NSObject>

/**
 Name of the NSObject's subclass property. Same as used for the Key Value Coding.
 */
@property (nonatomic, copy, nonnull) NSString *property;

/**
 @description keyPath to the required value in the JSON's representation. It may include dots which represents embeded dictionaries.
 This value is optional.
 
 For example key path for the "title" property of the given JSON is going to be "info.title".
 
 @code
 {
    "info": {
        "title": "Text";
    }
 }
 @endcode
 
 Also for some cases it is valid to use `nil` key path. Lets imagine mapping of a to-many relationship, which represented as 
 an Array of the primary keys (Int for example): 
 
 @code
 {
    "userID": 12,
    "username": "John",
    
    "relatedPhotoIDs": [
        23,
        24,
        25
    ]
 }
 @endcode
 
 As you can see user's photos are passed as an Array of Ints. Therefore during mapping of the `Photo` object we can describe 
 relationship between `Photo.photoID` and the corresponding value in the JSON as FEMProperty which has `property` equals to the 
 `photoID` and `keyPath` equals to the `nil`.
 */
@property (nonatomic, copy, nullable) NSString *keyPath;

@end
