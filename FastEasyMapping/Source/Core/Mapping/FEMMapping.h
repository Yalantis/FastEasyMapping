// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMAttribute.h"
#import "FEMRelationship.h"

@interface FEMMapping : NSObject {
    @protected
	NSMutableDictionary *_attributeMap;
	NSMutableDictionary *_relationshipMap;
}

@property (nonatomic, copy) NSString *rootPath;
- (id)initWithRootPath:(NSString *)rootPath;

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

- (id)extractRootFromExternalRepresentation:(id)externalRepresentation;

@end

@interface FEMMapping (Deprecated)

- (void)addAttributeMappingFromArray:(NSArray *)attributes;
- (void)addAttributeMappingDictionary:(NSDictionary *)attributesToKeyPath;
- (void)addAttributeMappingOfProperty:(NSString *)property atKeypath:(NSString *)keypath;

@property (nonatomic, strong, readonly) NSArray *attributeMappings;
- (void)addAttributeMapping:(FEMAttributeMapping *)attributeMapping;
- (FEMAttributeMapping *)attributeMappingForProperty:(NSString *)property;

@property (nonatomic, strong, readonly) NSArray *relationshipMappings;
- (void)addRelationshipMapping:(FEMRelationshipMapping *)relationshipMapping;
- (FEMRelationshipMapping *)relationshipMappingForProperty:(NSString *)property;

@end