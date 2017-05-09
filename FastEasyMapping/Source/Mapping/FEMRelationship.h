// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMAssignmentPolicy.h"
#import "FEMProperty.h"

@class FEMMapping;

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Description of a relationship between two `FEMMapping` instances.
 
 @discussion Quite often JSON contains embed Object. FEMRelationship designed to allow you to connect two FEMMapping for each Object.
 FEMRelationship has various properties such as:
 
 * `property` describes Object's property on a parent Object.
 * `keyPath` describes at what keyPath in the JSON lies representation of the nested Object.
 * `toMapy` describes whether relationship is a to many or to one.
 * `mapping` instance of the FEMMapping describing nested Object.
 * `assignmentPolicy` how to combine previous value of the parent Object's property with the new one: assign, merge, replace or even do custom handling.
 * `weak` should FEM skip nested Object mapping if it is not presented in the database.

 For example lets take a look at the following JSON which describes the User that has a to-many relationship to the Phone.
 @code
 {
     "username": "email@domain.com",
     "user_phones": [
         {
             "number": "1111-1111"
         },
         {
             "number": "2222-222"
         }
     ]
 }
 @endcode

 Here is a corresponding mapping, that uses FEMRelationship:

 @code
 FEMMapping *user = [[FEMMapping alloc] initWithObjectClass:[User class]];
 // assume that we have a User class with the `username` property
 [user addAttributesFromArray:@[@"username"]];

 // assume that User has a `phones` relationship of `NSArray<Phone>` type.
 FEMMapping *phone = [[FEMMapping alloc] initWithObjectClass:[Phone class]];
 [phone addAttributesFromArray:@[@"number"]];

 // now we have to connect Phone to the User via a shortcut on the FEMMapping
 [user addToManyRelationshipMapping:phone forProperty:@"phones" keyPath:@"user_phones"];

 // or manually
 FEMRelationship *phonesRelationship = [[FEMRelationship alloc] initWithProperty:@"phones" keyPath:@"user_phones" mapping:phone];
 phonesRelationship.toMany = YES;
 [user addRelationship:phonesRelationship];
 @endcode
 */
@interface FEMRelationship : NSObject <FEMProperty, NSCopying>

/**
 @brief FEMMapping that describes nested Object
 
 @discussion IMPORTANT: `FEMRelationship.keyPath` *always* takes predesence over `FEMMapping.rootPath`. The last one is ignored during relationship mapping.
 */
@property (nonatomic, strong) FEMMapping *mapping;

/**
 @brief Whether relationship is a to-many or to-one. Default is `NO` (to-one).
 
 @discussion For to-many relationships there is a limitation in supported collections:
 - For ObjC (with or without generics): NSArray, NSMutableArray, NSSet, NSMutableSet, NSOrderedSet, NSMutableOrderedSet.
 - For Swift: only bridgeable collections such as Array, Set. However you can also use plain ObjC collections (like NSOrderedSet) if needed.
 
 IMPORTANT: For Swift supported collections are either comes from ObjC world such as mentioned above or the ones that can be bridged
 */
@property (nonatomic, getter=isToMany) BOOL toMany;

/// Instance of the `FEMMapping` containing receiver. Set automatically after `-[FEMMapping addRelationship:]`
@property (nonatomic, weak, null_resettable) FEMMapping *owner;

/// Flag indicating whether `FEMRelationship` describes recursive dependency or not (i.e. `mapping` equals to the `owner`).
@property (nonatomic, readonly, getter=isRecursive) BOOL recursive;

/**
 @brief Flag indicating whether FEM should skip nested Object mapping if it is not presented in the database or not. Default is `NO`.
 
 @discussion This property useful, when JSON describes relationship to an object by its Primary Key only, however for some reasons this object doesn't exist in the database and therefore shoudn't be binded by Primary Key (due to requirements of the app).
 Otherwise it may lead to a new Object that is not fulfilled correctly and therefore inconsistent. In order to prevent such issue you can set this flag to `YES`.
 
 IMPORTANT: this property is used only when `mapping.primaryKey` is not nil. Otherwise ignored.

 For example imagine we have a User and a Notification in our data model:
 @code
 @interface User : NSObject

 @property (nonatomic, copy) NSString *username;
 @property (nonatomic, copy) NSArray<Notification *> *unreadNotifications;

 @end

 @interface Notification : NSObject

 @property NSNumber *identifier;
 @property NSString *title;

 @end
 @endcode

 Assume that in the database we already have a User and one Notification that can be represented as:
 @code
 {
    "username: "email@domain.com"
    "unreadNotifications": [
        {
            "id": 123,
            "title": "Notification 123"
        }
    ]
 }
 @endcode

 During network operation that updates list of the unread notifications we've received following JSON:
 @code
 {
     "username": "email@domain.com",
     "unread_notifications": [
         123,
         345
     ]
 }
 @endcode

 As you can see, we have one Notification that is already presented in the database with `id = 123` and a new one with `id = 345` that is missing.
 Since during deserialization we're mapping all of the notifications, database has the following state:
  @code
 {
    "username: "email@domain.com"
    "unreadNotifications": [
        {
            "id": 123,
            "title": "Notification 123"
        },
        {
            "id": 345,
            "title": null
        }
    ]
 }
 @endcode

 FEM did bind new notification (`id = 345`) to the User, however it has not title in it. Assume that we need to skip such
 situation and for those notifications that are not presented in the database we don't want to create a corresponding instance.
 This can be done by setting `-[FEMRelationship weak]` to `YES`. As the result of such change during deserialization we will end up with correct database state:
 @code
 {
    "username: "email@domain.com"
    "unreadNotifications": [
        {
            "id": 123,
            "title": "Notification 123"
        }
    ]
 }
 @endcode

 As you can see, our data model is in the _consistent_ state and doesn't have unfulfilled Notification where `title = null` anymore.
 */
@property (nonatomic) BOOL weak;

/**
 @discussion Assignment policy describes how deserialized relationship value should be assigned to a Object's property. 
 FEM supports 5 policies out of the box:
 * `FEMAssignmentPolicyAssign` replaces Old property's value by New. Designed for to-one and to-many relationship. Default policy.
 * `FEMAssignmentPolicyObjectMerge` assigns New relationship value unless it is nil. Designed for to-one relationship.
 * `FEMAssignmentPolicyObjectReplace` replaces Old value with New by deleting Old. Designed for to-one relationship.
 * `FEMAssignmentPolicyCollectionMerge` merges a New and Old values of relationship. Supported collections are: NSSet, NSArray, NSOrderedSet and their successors. Designed for to-many relationship.
 * `FEMAssignmentPolicyCollectionReplace` deletes objects not presented in union of New and Old values sets. Union set is used as a New value. Designed for to-many relationship.

 IMPORTANT: setting to-one relationship policy for relationship that is a to-many and vice versa leads to underfined behaviour and potential runtime errors.
 */
@property (nonatomic, copy) FEMAssignmentPolicy assignmentPolicy;

/**
 @brief Initialize FEMRelationship with a given property, keyPath and mapping of the Object.

 @param property Object's property name (same as for the KVC).
 @param keyPath  JSON's keyPath to the relationship (optional).
 @param mapping  Instance of the FEMMapping that describes Object.

 @return New instance of the FEMRelationship.
 */
- (instancetype)initWithProperty:(NSString *)property keyPath:(nullable NSString *)keyPath mapping:(FEMMapping *)mapping NS_DESIGNATED_INITIALIZER;

/**
 @brief Initialize FEMRelationship with a given property, `nil` keyPath and a mapping of the Object.
 
 @param property Object's property name (same as for the KVC).
 @param mapping  Instance of the FEMMapping that describes Object.
 
 @return New instance of the FEMRelationship.
 */
- (instancetype)initWithProperty:(NSString *)property mapping:(FEMMapping *)mapping;


/**
 @brief Initialize FEMRelationship with a given property, keyPath, mapping of the Object and assingment policy.

 @param property Object's property name (same as for the KVC).
 @param keyPath  JSON's keyPath to the relationship (optional).
 @param mapping  Instance of the FEMMapping that describes Object.
 @param assignmentPolicy Block of FEMAssingmentPolicy type.

 @return New instance of the FEMRelationship.
 */
- (instancetype)initWithProperty:(NSString *)property keyPath:(nullable NSString *)keyPath mapping:(FEMMapping *)mapping assignmentPolicy:(FEMAssignmentPolicy)assignmentPolicy;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 @brief Updates mapping and key path simultaniously. 
 
 @discussion This method may be useful during manual FEMRelationship configuration, however most of its functionality can be achieved by initializers.

 @param mapping  Instance of the FEMMapping that describes Object.
 @param keyPath  JSON's keyPath to the relationship (optional).
 */
- (void)setMapping:(FEMMapping *)mapping forKeyPath:(nullable NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
