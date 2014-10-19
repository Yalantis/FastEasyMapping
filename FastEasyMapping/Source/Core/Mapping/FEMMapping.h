// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMAttributeMapping, FEMRelationshipMapping;

@interface FEMMapping : NSObject {
    @protected
	NSMutableDictionary *_attributesMap;
	NSMutableDictionary *_relationshipsMap;
}

@property (nonatomic, copy) NSString *rootPath;
- (id)initWithRootPath:(NSString *)rootPath;

@property (nonatomic, copy) NSString *primaryKey;
@property (nonatomic, strong, readonly) FEMAttributeMapping *primaryKeyMapping;

@property (nonatomic, strong, readonly) NSArray *attributeMappings;
- (void)addAttributeMapping:(FEMAttributeMapping *)attributeMapping;

- (FEMAttributeMapping *)attributeMappingForProperty:(NSString *)property;

@property (nonatomic, strong, readonly) NSArray *relationshipMappings;
- (void)addRelationshipMapping:(FEMRelationshipMapping *)relationshipMapping;

- (FEMRelationshipMapping *)relationshipMappingForProperty:(NSString *)property;

@end

@interface FEMMapping (Shortcut)

- (void)addAttributeMappingFromArray:(NSArray *)attributes;
- (void)addAttributeMappingDictionary:(NSDictionary *)attributesToKeyPath;
- (void)addAttributeMappingOfProperty:(NSString *)property atKeypath:(NSString *)keypath;

- (void)addRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath;
- (void)addToManyRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath;

- (id)extractRootFromExternalRepresentation:(id)externalRepresentation;

@end