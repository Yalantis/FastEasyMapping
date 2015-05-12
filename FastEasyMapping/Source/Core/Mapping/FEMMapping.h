// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMAttribute.h"
#import "FEMAttributeMapping.h"
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
- (instancetype)initWithEntityName:(NSString *)entityName NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) Class objectClass;
@property (nonatomic, copy, readonly) NSString *entityName;

@property (nonatomic, copy) NSString *rootPath;

@property (nonatomic, copy) NSString *primaryKey;
@property (nonatomic, strong, readonly) FEMAttributeMapping *primaryKeyAttribute;

@property (nonatomic, strong, readonly) NSArray *attributes;
- (void)addAttribute:(FEMAttribute *)attribute;
- (FEMAttribute *)attributeForProperty:(NSString *)property;

@property (nonatomic, strong, readonly) NSArray *relationships;
- (void)addRelationship:(FEMRelationship *)relationship;
- (FEMRelationship *)relationshipForProperty:(NSString *)property;

@end

@interface FEMMapping (Shortcut)

- (void)addAttributesFromArray:(NSArray *)attributes;
- (void)addAttributesDictionary:(NSDictionary *)attributesToKeyPath;
- (void)addAttributeWithProperty:(NSString *)property keyPath:(NSString *)keyPath;

- (void)addRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath;
- (void)addToManyRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath;

- (id)representationFromExternalRepresentation:(id)externalRepresentation;

@end