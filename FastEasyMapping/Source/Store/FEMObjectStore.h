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
 @discussion Invoked by FEMDeserialized at the very beggining of deserialization. Your implementation may inspect given `representation`
 in order to perform prefetch of objects. Default implementation does nothing.

 @param mapping        FEMMapping that is passed to the FEMDeserializer to perform deserialization
 @param representation JSON passed to the FEMDeserialializer to perform deserialization. Note that it always of Array type for both Collection and Object deserialization.
 */
- (void)prepareTransactionForMapping:(FEMMapping *)mapping ofRepresentation:(NSArray *)representation;

/**
 @discussion Invoked by FEMDeserializer after -prepareTransactionForMapping:ofRepresentation:. 
 Custom implementation may want to begin write transaction or similar. Default implementation does nothing.
 */
- (void)beginTransaction;

/**
 @discussion Invoked by FEMDeserializer after all data has been deserialized.
 Custom implementation may want to commit opened transaction or similar. Default implementation does nothing.
 */
- (nullable NSError *)commitTransaction;

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
 @brief Register object in the cache storage.
 
 @discussion Once FEMDeserializer has fulfilled object's attributes and relationships `-registerObject:forMapping:` is invoked. 
 Later FEMDeserializer may ask FEMObjectStore for registered objects `-registeredObjectsForMapping:` to not populate database with copies.
 You may want to implement sort of a Map where key is a `primaryKey` and `value` is an `object` itself.
 
 Default implementation does nothing.
 
 IMPORTANT: This method invoked only in case `-canRegisterObject:forMapping:` returns true.

 @param object  Fully deserialized the Object with fulfilled attributes and relationships.
 @param mapping Mapping that is describing the `object`. You may want to ask for the `mapping.primaryKey` in order to get primary key value from `object`.
 */
- (void)registerObject:(id)object forMapping:(FEMMapping *)mapping;

/**
 @brief Evaluates whether object can be registered in the internal cache or not.
 
 @param object  Fully deserialized the Object with fulfilled attributes and relationships.
 @param mapping Mapping that is describing the `object`. You may want to ask for the `mapping.primaryKey` in order to get primary key value from `object`.

 @return Flag indicating whether `object` can be stored in the internal cache or not.
 */
- (BOOL)canRegisterObject:(id)object forMapping:(FEMMapping *)mapping;

/**
 @brief Dictionary of registered objects for the given `mapping`. 
 
 @discussion Expected format is: Dictionary<PrimaryKey, Object>

 @param mapping Mapping for which registered objects requested.

 @return Dictionary where key is a Primary Key and value is Object.
 */
- (NSDictionary *)registeredObjectsForMapping:(FEMMapping *)mapping;

/**
 @brief Returns regitered Object for the given JSON representation of the Object.
 
 @discussion When FEMDeserializer start processing JSON of a particular Object it asks FEMObjectStore for registered Object 
 for the given JSON. FEMObjectStore may want to perform a lookup in the internal cache for existing object by extracting
 primary key from the JSON.
 
 @param representation JSON representing the Object
 @param mapping Mapping for which registered object requested.
 
 @return Registered Object or nil.
 */
- (nullable id)registeredObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping;

@end

NS_ASSUME_NONNULL_END
