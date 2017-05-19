// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMRelationshipAssignmentContext.h"

@class FEMMapping;

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Class that is responsible for instantiation, bookeeping and removal of objects during deserialization.
 
 @discussion Moving Objects managment to a separate class allows FEMDeserializer to abstract away from how Object is actually 
 being created. Therefore you may provide your own implementation of store that will interact with any kind of database and 
 by passing it to the FEMDeserializer reuse existing mapping logic.
 
 @see FEMDeserializer, FEMManagedObjectStore
 */
@interface FEMObjectStore : NSObject <FEMRelationshipAssignmentContextDelegate>

/**
 @discussion Invoked by FEMDeserializer at the very beginning of deserialization.
 Custom implementation may want to begin write transaction or similar. Default implementation does nothing.

 @param presentedPrimaryKeys when `+[YourObjectStoreSubclass requiresPrefetch]` returns `YES` then `presentedPrimaryKeys contains a non-nil Dictionary with `-[FEMMapping uniqueIdentifier]` to Set of primary keys pairs. In case +requiresPrefetch returns NO - nil value passed.
 */
- (void)beginTransaction:(nullable NSDictionary<NSNumber *, NSSet<id> *> *)presentedPrimaryKeys;

/**
 @discussion Invoked by FEMDeserializer after all data has been deserialized.
 Custom implementation may want to commit opened transaction or similar. Default implementation does nothing.
 */
- (nullable NSError *)commitTransaction;

/**
 @brief Specifies whether your custom store requires prefetch of existing objects or not.

 @discussion During deserialization it is useful to prefetch objects from the actual store (Realm, sqlite, etc) by the primary keys that are presented in the JSON.
 Later those objects can be returned from the -registeredObjectForRepresentation:mapping: to no populate actual store with the duplicates.
 `FEMManagedObjectStore` by default returns `YES`.

 @return Flag indicating whether Store will perform prefetch or not. For instances of classes that returns `YES` `FEMDeserializer` collects presented keys, otherwise it does nothing.
 */
+ (BOOL)requiresPrefetch;

/**
 @brief Initialize new object for the given mapping.

 @discussion Default implementation returns new object of `mapping.objectClass` type.
 
 @param mapping FEMMapping instance for which Object needs to be initialized.
 
 @return Initialized instance of the Object for the given mapping.
 */
- (id)newObjectForMapping:(FEMMapping *)mapping;


/**
 @brief Instantiate new assignment context with self as a `store`.

 @discussion Typically there should be no reason to override this method.
 
 @return New instance of FEMRelationshipAssignmentContext.
 */
- (FEMRelationshipAssignmentContext *)newAssignmentContext;

/**
 @brief Adds object to the storage.
 
 @discussion Once FEMDeserializer has fulfilled object's attributes `-addObject:forPrimaryKey:mapping:` is invoked.
 Later FEMDeserializer may ask FEMObjectStore for registered objects `-objectForPrimaryKey:mapping:` to not populate database with copies.
 You may want to implement sort of a Map where key is a `primaryKey` and `value` is an `object` itself.
 
 Default implementation does nothing.

 IMPORTANT: At this point Object contains only mapped attributes and no relationships (except existing).

 @param object  Fully deserialized the Object with fulfilled attributes and relationships.
 @param primaryKey PrimaryKey value if presented in JSON and setup via FEMMapping.primaryKey or nil.
 @param mapping Mapping that is describing the `object`. You may want to ask for the `mapping.primaryKey` in order to get primary key value from `object`.
 */
- (void)addObject:(id)object forPrimaryKey:(nullable id)primaryKey mapping:(FEMMapping *)mapping;

/**
 @brief Dictionary of registered objects for the given `mapping`.
 
 @discussion Expected format is: Dictionary<PrimaryKey, Object>

 @param mapping Mapping for which registered objects requested.

 @return Dictionary where key is a Primary Key and value is Object.
 */
- (NSDictionary *)objectsForMapping:(FEMMapping *)mapping;

/**
 @brief Returns registered Object for the given PrimaryKey of the Object.
 
 @discussion When FEMDeserializer start processing JSON of a particular Object it asks FEMObjectStore for registered Object 
 for the given PrimaryKey. FEMObjectStore may want to perform a lookup in the internal cache for existing object by the given PrimaryKey.
 
 @param primaryKey PrimaryKey value from the JSON.
 @param mapping Mapping for which registered object requested.
 
 @return Registered Object or nil.
 */
- (nullable id)objectForPrimaryKey:(id)primaryKey mapping:(FEMMapping *)mapping;

@end

NS_ASSUME_NONNULL_END
