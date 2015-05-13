// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMAttribute.h"
#import "FEMRelationship.h"

@interface FEMMapping : NSObject {
    @protected
	NSMutableDictionary *_attributeMap;
	NSMutableDictionary *_relationshipMap;
}

- (instancetype)init __attribute__((unavailable("use -[FEMMapping initWithObjectClass] or -[FEMMapping initWithEntityName:] insted")));
+ (instancetype)new __attribute__((unavailable("use -[FEMMapping initWithObjectClass] or -[FEMMapping initWithEntityName:] insted")));
- (id)initWithRootPath:(NSString *)rootPath __attribute__((unavailable("use -[FEMMapping initWithObjectClass] or -[FEMMapping initWithEntityName:] insted")));


- (instancetype)initWithObjectClass:(Class)objectClass NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithObjectClass:(Class)objectClass rootPath:(NSString *)rootPath;

- (instancetype)initWithEntityName:(NSString *)entityName NS_DESIGNATED_INITIALIZER;
- (id)initWithEntityName:(NSString *)entityName rootPath:(NSString *)rootPath;


@property (nonatomic, readonly) Class objectClass;
@property (nonatomic, copy, readonly) NSString *entityName;

@property (nonatomic, copy) NSString *rootPath;

@property (nonatomic, copy) NSString *primaryKey;
@property (nonatomic, strong, readonly) FEMAttribute *primaryKeyAttribute;

@property (nonatomic, strong, readonly) NSArray *attributes;
- (void)addAttribute:(FEMAttribute *)attribute;
- (FEMAttribute *)attributeForProperty:(NSString *)property;

@property (nonatomic, strong, readonly) NSArray *relationships;
- (void)addRelationship:(FEMRelationship *)relationship;
- (FEMRelationship *)relationshipForProperty:(NSString *)property;

@end

@interface FEMMapping (Shortcut)

- (void)addAttributesFromArray:(NSArray *)attributes;
- (void)addAttributesFromDictionary:(NSDictionary *)attributesToKeyPath;
- (void)addAttributeWithProperty:(NSString *)property keyPath:(NSString *)keyPath;

- (void)addRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath;
- (void)addToManyRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath;

@end

@interface FEMMapping (FEMObjectMapping_Deprecated)

+ (FEMMapping *)mappingForClass:(Class)objectClass configuration:(void (^)(FEMMapping *mapping))configuration __attribute__((deprecated("Use -[FEMMapping initWithObjectClass:] instead")));
+ (FEMMapping *)mappingForClass:(Class)objectClass rootPath:(NSString *)rootPath configuration:(void (^)(FEMMapping *mapping))configuration __attribute__((deprecated("Use -[FEMMapping initWithObjectClass:rootPath:] instead")));

@end


@interface FEMMapping (FEMManagedObjectMapping_Deprecated)

+ (FEMMapping *)mappingForEntityName:(NSString *)entityName __attribute__((deprecated("Use -[FEMMapping initWithEntityName:] instead")));
+ (FEMMapping *)mappingForEntityName:(NSString *)entityName configuration:(void (^)(FEMMapping *sender))configuration __attribute__((deprecated("Use -[FEMMapping initWithEntityName:] instead")));
+ (FEMMapping *)mappingForEntityName:(NSString *)entityName rootPath:(NSString *)rootPath configuration:(void (^)(FEMMapping *sender))configuration __attribute__((deprecated("Use -[FEMMapping initWithEntityName:rootPath:] instead")));

@end
