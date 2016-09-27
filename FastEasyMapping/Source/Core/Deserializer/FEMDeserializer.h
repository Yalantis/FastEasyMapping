// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>
#import "FEMManagedObjectMapping.h"

@class FEMDeserializer, FEMObjectStore, FEMMapping, NSManagedObject, NSFetchRequest, NSManagedObjectContext;

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Interface for delegate that allows FEMDeserializer to inform outer object about deserialization process.

 @discussion Sometime it is useful to perform additional actions at some points of deserialization process. For example to
 updated external index once User instance has been deserialized or similar. Develope needs to be aware that deserialization is
 recursive and therefore you won't receive `-deserializer:didMapObject:fromRepresentation:mapping:` for the next object in the same collection
 until all nested relationships deserialized.
 
 For example lets deserialize following JSON: 
 @code
 {
     "name": "Lucas",
     "user_email": "lucastoc@gmail.com",
     "phones": [
         {
             "ddi": "55",
             "ddd": "85",
             "number": "1111-1111"
         }
     ]
 }
 @endcode

 Mapping described as follows:
 @code
 @implementation Person (Mapping)

 + (FEMMapping *)defaultMapping {
     FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Person"];
     [mapping addAttributesFromArray:@[@"name"]];
     [mapping addAttributesFromDictionary:@{@"email": @"user_email"}];
     [mapping addToManyRelationshipMapping:[Person defaultMapping] forProperty:@"phones" keyPath:@"phones"];

     return mapping;
 }
 @end

 @implementation Phone (Mapping)
 + (FEMMapping *)defaultMapping {
     FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Phone"];
     [mapping addAttributesFromArray:@[@"number", @"ddd", @"ddi"]];

     return mapping;
 }
 @end
 @endcode

 During deserialization of persons collection order will be the following:
 * -willMapCollectionFromRepresentation:`Persons Array` mapping:`Person mapping`
 * -willMapObjectFromRepresentation:`Person Dictionary` mapping:`Person mapping`
 * -willMapCollectionFromRepresentation:`Phones Array` mapping:`Phone mapping`
 * -willMapObjectFromRepresentation:`Phone Dictionary` mapping:`Phone mapping`
 * -didMapObject:`Phone instance` fromRepresentation:`Phone Dictionary` mapping:`Phone mapping`
 * -didMapObject:`Person instance` fromRepresentation:`Person Dictionary` mapping:`Person mapping`
 * -didMapCollection:`Persons instances Array` fromRepresentation:`Persons Array` mapping:`Person mapping`
 */
@protocol FEMDeserializerDelegate <NSObject>

@optional
/**
 @brief `deserializer` is going to deserialize representation by using a given `mapping`.

 @param deserializer Sender of the message.
 @param representation JSON value that is going to be deserialized. It will be of an JSON-valid type (Dictionary, Array, Int, String, etc).
 @param mapping Instance of FEMMapping that is going to be used for deserializing of `representation`.
 */
- (void)deserializer:(FEMDeserializer *)deserializer willMapObjectFromRepresentation:(id)representation mapping:(FEMMapping *)mapping;

/**
 @brief `deserializer` did deserialize representation by using a given `mapping` to the `object` instance.

 @param deserializer Sender of the message.
 @param representation JSON value was deserialized. It will be of an JSON-valid type (Dictionary, Array, Int, String, etc).
 @param mapping Instance of FEMMapping that was used for deserializing of `representation`.
 */
- (void)deserializer:(FEMDeserializer *)deserializer didMapObject:(id)object fromRepresentation:(id)representation mapping:(FEMMapping *)mapping;

/**
 @brief `deserializer` is going to deserialize collection of representations by using a given `mapping`.

 @param deserializer Sender of the message.
 @param representation Array of JSON values that is going to be deserialized. It contains values of an JSON-valid type (Dictionary, Array, Int, String, etc).
 @param mapping Instance of FEMMapping that is going to be used for deserializing of `representation`.
 */
- (void)deserializer:(FEMDeserializer *)deserializer willMapCollectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping;

/**
 @brief `deserializer` did deserialize collection of representations by using a given `mapping`.

 @param deserializer Sender of the message.
 @param representation Array of JSON values that was deserialized. It contains values of an JSON-valid type (Dictionary, Array, Int, String, etc).
 @param mapping Instance of FEMMapping that was used for deserializing of `representation`.
 */
- (void)deserializer:(FEMDeserializer *)deserializer didMapCollection:(NSArray *)collection fromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping;

@end

/**
 @brief Deserializer from JSON to Object using FEMMapping.

 @discussion Most of the time you're going to use FEMDeserializer with FEMMapping in order to get Objects from the JSON.
 Currently it supports 2 types of Objets: subclasses of the NSObject and sublasses of the NSManagedObject. You can extend
 supported types by providing your custom implementation of `FEMObjectStore`.

 Here are few usage samples:

 Deserialize CoreData's subclass
 @code
 FEMMapping *mapping = [Person defaultMapping];
 Person *person = [FEMDeserializer objectFromRepresentation:json mapping:mapping context:managedObjectContext];
 @endcode

 Deserialize array of a CoreData's subclass
 @code
 FEMMapping *mapping = [Person defaultMapping];
 NSArray *persons = [FEMDeserializer collectionFromRepresentation:json mapping:mapping context:managedObjectContext];
 @endcode

 Update existing object from its JSON representation
 @code
 FEMMapping *mapping = [Person defaultMapping];
 [FEMDeserializer fillObject:person fromRepresentation:json mapping:mapping];
 @endcode
 */
@interface FEMDeserializer : NSObject

/**
 @brief Store for deserialized objects.

 @discussion FEMDeserializer doesn't store objects on its own but delegate it to the `store`. This allows developer to
 pass custom implementation of FEMObjectStore. For example, RealmObjectStore (in development currently) that will interoperate with Realm database.
 It means that single mapping can be reused for NSObject, NSManagedObject and any custom Object that you would like to use.

 Currently there are: FEMObjectStore for plain NSObject's subclasses and FEMManagedObjectStore for CoreData.
 */
@property (nonatomic, strong, readonly) FEMObjectStore *store;

/**
 @brief Initializes FEMDeserializer with a given `store`. Designated initializer.

 @param store Instance of FEMObjectStore to be used during deserialization.
 @return New instance of the FEMDeserializer.
 */
- (instancetype)initWithStore:(FEMObjectStore *)store NS_DESIGNATED_INITIALIZER;

/**
 @brief Initializes FEMDeserializer for mapping of NSObject's subclasses. Convenience initializer.

 @discussion Same as initializing FEMDeserializer with FEMObjectStore instance.

 @return New instance of the FEMDeserializer.

 @see FEMObjectStore
 */
- (instancetype)init;

/**
 @brief Initializes FEMDeserializer for mapping of NSManagedObject's subclasses in a given `context`. Convenience initializer.

 @discussion Same as initializing FEMDeserializer with FEMManagedObjectStore instance with a given `context`.
 
 IMPORTANT: Developer is responsible for deserializing objects on a `context`s queue. FEM doesn't manage concurrency.
 
 @param context Instance of NSManagedObjectContext to be used during deserialization.

 @return New instance of the FEMDeserializer.

 @see FEMManabedObjectStore
 */
- (instancetype)initWithContext:(NSManagedObjectContext *)context;

/**
 @brief Instance of id<FEMDeserializerDelegate> that can be notified about deserialization process.
 @see FEMDeserializerDelegate
 */
@property (nonatomic, unsafe_unretained, nullable) id<FEMDeserializerDelegate> delegate;

/**
 @brief Deserialize Object from the given `representation` by using `mapping`.

 @discussion Class of the Object depends on the `mapping`.
 For example for the `[[FEMMapping alloc] initWithObjectClass:[User class]]]` returned value will be of a User class.
 For `[[FEMMapping alloc] initWithEntityName:@"User"]]` returned value will be of Class, specified in the .xcdatamodel for the "User" entity.

 @param representation Dictionary that representes object. Typically you get this value from the `-[NSJSONSerialization JSONObjectWithData:options:error:]` or similar.
 @param mapping Instance of `FEMMapping` used for the deserialization.
 @return Deserialized instance of the type, specified by `mapping`.
 */
- (id)objectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping;

/**
 @brief Update given `object` by applying deserialized `representation` to it using `mapping`.

 IMPORTANT: FastEasyMapping assumes that `mapping` describes Object of the same class as `object` value.
 Otherwise behaviour is undefined.

 @param object Object to which deserialized `representation` needs to be applied.
 @param representation Dictionary, representing JSON.
 @param mapping Instance of `FEMMapping` describing how `representation` needs to be applied to the `object`.

 @return Same instance as passed to the `object`.
 */
- (id)fillObject:(id)object fromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping;

/**
 @brief Deserialize array of Object's from the given `representation` by using `mapping`.

 @discussion Class of the Object depends on the `mapping`.
 For example for the `[[FEMMapping alloc] initWithObjectClass:[User class]]]` returned value will be of a User class.
 For `[[FEMMapping alloc] initWithEntityName:@"User"]]` returned value will be of Class, specified in the .xcdatamodel for the "User" entity.

 @param representation Array that representes objects. Typically you get this value from the `-[NSJSONSerialization JSONObjectWithData:options:error:]` or similar.
 @param mapping Instance of `FEMMapping` used for the deserialization.

 @return Array of deserialized instances of the type, specified by `mapping`.

 @see -[FEMDeserializer objectFromRepresentation:mapping:]
 */
- (NSArray *)collectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping;

@end

@interface FEMDeserializer (Extension)

/**
 @brief Deserialize NSManagedObject's subclass from the given `representation` by using `mapping`.

 @discussion Same as initializing `FEMDeserializer` with a `FEMManagedObjectStore` and invoking -objectFromRepresentation:mapping:.

 @param representation Dictionary that representes object. Typically you get this value from the `-[NSJSONSerialization JSONObjectWithData:options:error:]` or similar.
 @param mapping Instance of `FEMMapping` used for the deserialization.

 @return Deserialized instance of the type, specified by `mapping`.
 */
+ (id)objectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping context:(NSManagedObjectContext *)context;

/**
 @brief Deserialize NSObject's subclass from the given `representation` by using `mapping`.

 @discussion Same as initializing `FEMDeserializer` with a `FEMObjectStore` and invoking -objectFromRepresentation:mapping:.

 @param representation Dictionary that representes object. Typically you get this value from the `-[NSJSONSerialization JSONObjectWithData:options:error:]` or similar.
 @param mapping Instance of `FEMMapping` used for the deserialization.

 @return Deserialized instance of the type, specified by `mapping`.
 */
+ (id)objectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping;

/**
 @brief Update given `object` by applying deserialized `representation` to it using `mapping`.

 @discussion Same as initializing `FEMDeserializer` with either a `FEMObjectStore` or `FEMManagedObjectStore` depending on the Object's class
 and invoking -fillObject:fromRepresentation:mapping:.

 @param object Object to which deserialized `representation` needs to be applied.
 @param representation Dictionary, representing JSON.
 @param mapping Instance of `FEMMapping` describing how `representation` needs to be applied to the `object`.

 @return Same instance as passed to the `object`.
 */
+ (id)fillObject:(id)object fromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping;

/**
 @brief Deserialize array of NSManagedObject's subclass from the given `representation` by using `mapping`.

 @discussion Same as initializing `FEMDeserializer` with a `FEMManagedObjectStore` and invoking -collectionFromRepresentation:mapping:.

 @param representation Array that representes objects. Typically you get this value from the `-[NSJSONSerialization JSONObjectWithData:options:error:]` or similar.
 @param mapping Instance of `FEMMapping` used for the deserialization.

 @return Array of deserialized instances of the type, specified by `mapping`.
 */
+ (NSArray *)collectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping context:(NSManagedObjectContext *)context;

/**
 @brief Deserialize array of NSObject's subclass from the given `representation` by using `mapping`.

 @discussion Same as initializing `FEMDeserializer` with a `FEMObjectStore` and invoking -collectionFromRepresentation:mapping:.

 @param representation Array that representes objects. Typically you get this value from the `-[NSJSONSerialization JSONObjectWithData:options:error:]` or similar.
 @param mapping Instance of `FEMMapping` used for the deserialization.

 @return Array of deserialized instances of the type, specified by `mapping`.
 */
+ (NSArray *)collectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping;

@end


@interface FEMDeserializer (FEMObjectDeserializer_Deprecated)

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMMapping *)mapping __attribute__((deprecated("Use +[FEMDeserializer objectFromRepresentation:mapping:] instead")));
+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMMapping *)mapping __attribute__((deprecated("Use +[FEMDeserializer fillObject:fromRepresentation:mapping:] instead")));
+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation usingMapping:(FEMMapping *)mapping __attribute__((deprecated("Use +[FEMDeserializer collectionFromRepresentation:mapping:] instead")));

@end

@interface FEMDeserializer (FEMManagedObjectDeserializer_Deprecated)

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMMapping *)mapping context:(NSManagedObjectContext *)context __attribute__((deprecated("Use +[FEMDeserializer objectFromRepresentation:mapping:context:] instead")));
+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation usingMapping:(FEMMapping *)mapping context:(NSManagedObjectContext *)context __attribute__((deprecated("Use +[FEMDeserializer collectionFromRepresentation:mapping:context:] instead")));
+ (NSArray *)synchronizeCollectionExternalRepresentation:(NSArray *)externalRepresentation usingMapping:(FEMMapping *)mapping predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context __attribute__((unavailable));

@end

NS_ASSUME_NONNULL_END
