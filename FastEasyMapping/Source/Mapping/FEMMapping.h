// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMAttribute.h"
#import "FEMRelationship.h"

NS_ASSUME_NONNULL_BEGIN

/**
 @brief FEMMapping is a class that describes mapping for NSObject or NSManagedObject by encapsulating a set of attributes and relationships.
 
 @disucssion FEMMapping also defines the possibilities for objects uniquing (supported by CoreData only). This allows developer to not create duplicates in the database during JSON mapping.
 
 Currently only NSObject and NSManagedObject successors are supported, therefore in Swift world you have to subclass them in order to use FEM.
 
 In order to initalize FEM for NSObject mapping you should use target object class:
 @code
 FEMMapping *objectMapping = [[FEMMapping alloc] initWithObjectClass:[CustomNSObjectSuccessor class]];
 @endcode
 
 For NSManagedObject mapping you should use entity name, which corresponds to the CoreData's entity name:
 @code
 FEMMapping *managedObjectMapping = [[FEMMapping alloc] initWithEntityName:@"EntityName"];
 @endcode
 */
@interface FEMMapping : NSObject <NSCopying>

/**
 @brief Initialize FEMMapping with a given NSObject-success class. 
 
 @discussion This creates new FEMMapping instance for NSObject-successors mapping. This type of mapping can not be used for CoreData mappings.
 
 @param objectClass Class of NSObject successor. For example: `[[FEMMapping alloc] initWithObjectClass:[CustomNSObjectSuccessor class]]`.

 @return New instance of the FEMMapping.
 
 @warning FEM assumes, that instances of the `objectClass` can be instantiated by calling [[ObjectClass alloc] init].
 */
- (instancetype)initWithObjectClass:(Class)objectClass NS_DESIGNATED_INITIALIZER;

/**
 @brief Initialize FEMMapping with a given NSObject-success class and a root path.
 
 @discussion This creates new FEMMapping instance targeted for NSObject mapping. This type of mapping can not be used for CoreData mappings.

 @param objectClass Class of NSObject successor. For example: `[[FEMMapping alloc] initWithObjectClass:[CustomNSObjectSuccessor class]]`.
 @param rootPath    Path to the Object's representation in the JSON. For example for the given JSON `{"data": {"username": "user"}}` it will equal to the "data".

 @return New instance of the FEMMapping.
 
 @warning FEM assumes, that instances of the `objectClass` can be instantiated by calling [[ObjectClass alloc] init].
 */
- (instancetype)initWithObjectClass:(Class)objectClass rootPath:(nullable NSString *)rootPath;

/**
 @brief Initialize FEMMapping with a given CoreData's entity name.

 @discussion This creates new FEMMapping instance targeted for CoreData mapping. This type of mapping can not be used for NSObject successors mapping.
 
 @param entityName Entity Name of the NSManagedObject sucessor. For example "User" or "MyAppModule.User".

 @return New instance of the FEMMapping.
 */
- (instancetype)initWithEntityName:(NSString *)entityName NS_DESIGNATED_INITIALIZER;

/**
 @brief Initialize FEMMapping with a given CoreData's entity name.

 @discussion This creates new FEMMapping instance targeted for CoreData mapping. This type of mapping can not be used for NSObject successors mapping.
 
 @param entityName Entity Name of the NSManagedObject sucessor. For example "User" or "MyAppModule.User".
 @param rootPath    Path to the Object's representation in the JSON. For example for the given JSON `{"data": {"username": "user"}}` it will equal to the "data".

 @return New instance of the FEMMapping.
 */
- (instancetype)initWithEntityName:(NSString *)entityName rootPath:(nullable NSString *)rootPath;


- (instancetype)init __attribute__((unavailable("use -[FEMMapping initWithObjectClass:] or -[FEMMapping initWithEntityName:] instead")));
+ (instancetype)new __attribute__((unavailable("use -[FEMMapping initWithObjectClass:] or -[FEMMapping initWithEntityName:] instead")));


/// NSObject successor's class used during NSObject mapping. It can be nil for CoreData-targeted mappings. Has representation of `[CustomNSObjectSuccessor class]`
@property (nonatomic, strong, nullable) Class objectClass;

/// CoreData entity name used during CoreData-targeted mapping. It can be nil for NSObject-targeted mappings.
@property (nonatomic, copy, nullable) NSString *entityName;

/// Opaque unique value that is used internally to combine different in-memory instances that describes same Class / Entity.
@property (nonatomic, strong, readonly) NSNumber *uniqueIdentifier;

/**
 @brief path to the Object's representation in the JSON. Same as `keyPath` property of the `FEMProperty` protocol. 
 
 @discussion For example key path for the User Object of the given JSON is going to be "response.user":
 
 @code
 {
    "response": {
        "user": {
            "username": "john@doe.com
        }
    }
 }
 @endcode

 @warning When `FEMMapping` is used as a `FEMRelationship.mapping` value, then `rootPath` is ignored. `FEMRelationship.keyPath` is used instead.
 */
@property (nonatomic, copy, nullable) NSString *rootPath;

/**
 @brief Name of the property that makes the Object unique. 
 
 @discussion Primary Key of the Object you're going to deserialize from the JSON. This gives FEM ability to prevent data duplication in the database by performing lookup of the existing Objects for the given JSON.
 Typical usecase is to assign `primaryKey` to the primary key of your backend's Object. For example `username` for the User or `photoID` for Asset and so on.
 Currently supported only for CoreData mappings. Preferred types are: Integers, Strings. 
 
 In case you're facing with deserialization performance issues there are few ways to improve it:
 
 * Index your Primary Key property in the .xcdatamodel.
 
 * When NSManagedObjectContext saves takes too much time you may want to split your JSON into a batches and perform sequential deserialization. Therefore instead of 1 deserialization of 10k Objects at once perform 5 deserialization of 2k Objects in row with context saving after each. This is a subject for measurments: use CoreData Saves Instrument on Profiler.
 */
@property (nonatomic, copy, nullable) NSString *primaryKey;

/**
 @brief Returns existing attribute for the `primaryKey` (if any).
 */
@property (nonatomic, strong, readonly, nullable) FEMAttribute *primaryKeyAttribute;

/**
 @brief Returns all known attributes. Order is not saved.
 */
@property (nonatomic, strong, readonly) NSArray<FEMAttribute *> *attributes;

/**
 @brief Adds an attribute to the mapping.
 
 @discussion Attributes stored by the `attribute.property` key. Therefore attempt to add another attribute with `attribute.property` that is already
 registered will replace old value by new. Error message will be logged to the console. 
 Recommended way of mappings reuse is to declare basic mapping and append required propertis to it: 
 
 @code
 // basic version of mapping
 - (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"EntityName"];
    mapping.primaryKey = @"identifier";
    [mapping addAttributesFromArray:@[@"identifier", @"title"];
    
    return mapping;
 }
 
 // mapping used for the Timeline
 - (FEMMapping *)timelineMapping {
    FEMMapping *mapping = [self defaultMapping];
    
    // append attributes that are presented only for entities that come from the Timeline View Controller
    [mapping addAttributesFromDictionary:@{@"name": @"user.name", @"author": @"user.email" }];
 
    return mapping;
 }
 
 // mapping used for the Profile
 - (FEMMapping *)profileMapping {
    FEMMapping *mapping = [self defaultMapping];
 
    // append attributes that are presented only for entities that come from the Profile View Controller
    [mapping addAttributesFromDictionary:@{@"owner": @"owner.name", @"email": @"owner.email" }];
 
    return mapping;
 }
 @endcode
 
 @param attribute instance of the `FEMAttribute`.
 */
- (void)addAttribute:(FEMAttribute *)attribute;

/**
 @brief Returns registered `FEMAttribute` for the given property.
 
 @discussion Property value equals to the `attribute.property` of the attribute passed to the `-[FEMMapping addAttribute:]`.
 For example:
 
 @code
 FEMAttribute *attribute = [[FEMAttribute alloc] initWithProperty:@"title" ...];
 [mapping addAttribute:attribute];
 
 FEMAttribute *titleAttribute = [mapping attributeForProperty:@"title"];
 BOOL theyAreEqual = attribute == titleAttribute; // YES
 @endcode

 @param property Value of the `attribute.property`.

 @return Instance of `FEMAttribute` for the given property or nil.
 */
- (nullable FEMAttribute *)attributeForProperty:(NSString *)property;

/**
 @brief Returns all known relationships. Order is not saved.
 */
@property (nonatomic, strong, readonly) NSArray<FEMRelationship *> *relationships;

/**
 @brief Adds an relationship to the mapping.
 
 @discussion Attributes stored by the `relationship.property` key. Therefore attempt to add another attribute with `relationship.property` that is already
 registered will replace old value by new. Error message will be logged to the console. For recommendation regarding mappings reuse see `addAttribute:` method description.
 
 @param relationship instance of the `FEMAttribute`.
 */
- (void)addRelationship:(FEMRelationship *)relationship;

/**
 @brief Returns registered `FEMRelationship` for the given property.
 
 @discussion Property value equals to the `relationship.property` of the attribute passed to the `-[FEMMapping addRelationship:]`.
 
 @param property Value of the `relationship.property`.
 
 @return Instance of `FEMRelationship` for the given property or nil.
 */
- (nullable FEMRelationship *)relationshipForProperty:(NSString *)property;

/**
 * @brief Returns collection of the mapping itself and all of the relationships by flattening them into a Set.
 * @return `NSSet` that contains all of the unique mappings owned by the receiver via relationships including receiver.
 */
- (NSSet<FEMMapping *> *)flatten;

@end

@interface FEMMapping (Shortcut)

/**
 @brief Adds attributes for the given property names. It also assumes that your JSON contains keys that are the same as property names.
 
 @discussion FEM automatically converts array property names to the array of the Attributes where property and keyPath equal.
 It also assumes that no types transformation needs to be done and JSON contains same types as your Object for the give propertis (String to String, Int to Int and so on).

 @param attributes Array of properties with the same JSON keys.
 */
- (void)addAttributesFromArray:(NSArray<NSString *> *)attributes;

/**
 @brief Adds attributes from the given Dictionary of Property to KeyPath values.
 
 @discussion FEM automatically converts dictionary to the array of Attributes where `property` equals to the Dictionary key and `keyPath` to the Dictionary `value`. 
 For example for the object User with property `username` and the JSON:
 @code
 {
    "result": {
        "username": "john@doe.com"
    }
 }
 @endcode
 
 method usage looks as follows:
 
 @code
 [mapping addAttributesFromDictionary:@{@"username": @"result.username"}];
 @endcode
 
 @param attributesToKeyPath Dictionary of properties with the same JSON keys.
 */
- (void)addAttributesFromDictionary:(NSDictionary<NSString *, NSString *> *)attributesToKeyPath;

/**
 @brief Adds FEMAttribute construction from the give property and keyPath.
 
 @discussion FEM assumes that type of the JSON's value equal to the Object's property and no transformation required.

 @param property Property name for the Attribute (same as for the KVC)
 @param keyPath  KeyPath for the Attribute from the JSON (optional)
 */
- (void)addAttributeWithProperty:(NSString *)property keyPath:(nullable NSString *)keyPath;

/**
 @brief Adds FEMMapping as a to-one relationship with the given `property` and `keyPath`.

 @param property Property name for the Relationship (same as for the KVC)
 @param keyPath  KeyPath for the Relationship from the JSON (optional)
 */
- (void)addRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(nullable NSString *)keyPath;

/**
 @brief Adds FEMMapping as a to-many relationship with the given `property` and `keyPath`.

 @param property Property name for the Relationship (same as for the KVC)
 @param keyPath  KeyPath for the Relationship from the JSON (optional)
 */
- (void)addToManyRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(nullable NSString *)keyPath NS_SWIFT_NAME(addToManyRelationshipMapping(_:forProperty:keyPath:));

/**
 @brief Adds recursive to-one relationship with the given `property` and `keyPath`.

 @discussion Often Object's can have relationship to the same Object as a child. For example User has list of friends of User type.
 For example imagine following JSON:
  @code
 {
    "result": {
        "username": "john@doe.com"
        "age": 24,

        "followers": [
            {
                "username": "friend_of_john@doe.com",
                "age": 28
            },
            {
                "username": "another_friend_of_john@doe.com",
                "age": 22
            }
        ]
    }
 }
 @endcode

 As you can see, User's JSON contains instances of User with the same number of attributes. Therefore it is useful to reuse
 the same User mapping for nested relationship:
 @code
 FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"User"];
 [mapping addAttributesFromArray:@[@"username", @"age"]];
 [mapping addRecursiveToManyRelationshipForProperty:@"followers" keyPath:@"followers"];
 @endcode

 For the given mapping FEM will deserialize User recursively by "followers" `keyPath` until this `keyPath` presented in the JSON.
 Therefore for the example JSON above FEM stops recursive mapping on the first "followers", because nested dictionaries don't contain
 "followers" `keyPath`.

 @param property Property name for the Relationship (same as for the KVC)
 @param keyPath  KeyPath for the Relationship from the JSON (optional)
 */
- (void)addRecursiveRelationshipMappingForProperty:(NSString *)property keypath:(nullable NSString *)keyPath;

/**
 @brief Adds Adds recursive to-many relationship with the given `property` and `keyPath`.

 @see addRecursiveRelationshipMappingForProperty:keyPath: for description

 @param property Property name for the Relationship (same as for the KVC)
 @param keyPath  KeyPath for the Relationship from the JSON (optional)
 */
- (void)addRecursiveToManyRelationshipForProperty:(NSString *)property keypath:(nullable NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
