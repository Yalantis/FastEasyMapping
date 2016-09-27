// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMAttribute.h"
#import "FEMRelationship.h"

NS_ASSUME_NONNULL_BEGIN

@interface FEMMapping : NSObject <NSCopying>

- (instancetype)init __attribute__((unavailable("use -[FEMMapping initWithObjectClass:] or -[FEMMapping initWithEntityName:] instead")));
+ (instancetype)new __attribute__((unavailable("use -[FEMMapping initWithObjectClass:] or -[FEMMapping initWithEntityName:] instead")));
- (instancetype)initWithRootPath:(nullable NSString *)rootPath __attribute__((unavailable("use -[FEMMapping initWithObjectClass:] or -[FEMMapping initWithEntityName:] instead")));

- (instancetype)initWithObjectClass:(Class)objectClass NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithObjectClass:(Class)objectClass rootPath:(nullable NSString *)rootPath;

- (instancetype)initWithEntityName:(NSString *)entityName NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithEntityName:(NSString *)entityName rootPath:(nullable NSString *)rootPath;

@property (nonatomic, strong, nullable) Class objectClass;
@property (nonatomic, copy, nullable) NSString *entityName;

@property (nonatomic, copy, nullable) NSString *rootPath;

@property (nonatomic, copy, nullable) NSString *primaryKey;
@property (nonatomic, strong, readonly, nullable) FEMAttribute *primaryKeyAttribute;

@property (nonatomic, strong, readonly) NSArray *attributes;
- (void)addAttribute:(FEMAttribute *)attribute;
- (nullable FEMAttribute *)attributeForProperty:(NSString *)property;

@property (nonatomic, strong, readonly) NSArray *relationships;
- (void)addRelationship:(FEMRelationship *)relationship;
- (nullable FEMRelationship *)relationshipForProperty:(NSString *)property;

@end

@interface FEMMapping (Shortcut)

- (void)addAttributesFromArray:(NSArray *)attributes;
- (void)addAttributesFromDictionary:(NSDictionary *)attributesToKeyPath;
- (void)addAttributeWithProperty:(NSString *)property keyPath:(nullable NSString *)keyPath;

- (void)addRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(nullable NSString *)keyPath;
- (void)addToManyRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(nullable NSString *)keyPath;
- (void)addRecursiveRelationshipMappingForProperty:(NSString *)property keypath:(nullable NSString *)keyPath;
- (void)addRecursiveToManyRelationshipForProperty:(NSString *)property keypath:(nullable NSString *)keyPath;

@end

@interface FEMMapping (FEMObjectMapping_Deprecated)

+ (FEMMapping *)mappingForClass:(Class)objectClass configuration:(void (^)(FEMMapping * __mapping))configuration __attribute__((deprecated("Use -[FEMMapping initWithObjectClass:] instead")));
+ (FEMMapping *)mappingForClass:(Class)objectClass rootPath:(nullable NSString *)rootPath configuration:(void (^)(FEMMapping * __mapping))configuration __attribute__((deprecated("Use -[FEMMapping initWithObjectClass:rootPath:] instead")));

@end


@interface FEMMapping (FEMManagedObjectMapping_Deprecated)

+ (FEMMapping *)mappingForEntityName:(NSString *)entityName __attribute__((deprecated("Use -[FEMMapping initWithEntityName:] instead")));
+ (FEMMapping *)mappingForEntityName:(NSString *)entityName configuration:(nullable void (^)(FEMMapping * __sender))configuration __attribute__((deprecated("Use -[FEMMapping initWithEntityName:] instead")));
+ (FEMMapping *)mappingForEntityName:(NSString *)entityName rootPath:(nullable NSString *)rootPath configuration:(nullable void (^)(FEMMapping * __sender))configuration __attribute__((deprecated("Use -[FEMMapping initWithEntityName:rootPath:] instead")));

@end

NS_ASSUME_NONNULL_END