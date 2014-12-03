// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMAttribute.h"
#import "FEMAttributeMapping.h"
#import "FEMRelationship.h"
#import "FEMRelationshipMapping.h"

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
- (void)addAttributesFromDictionary:(NSDictionary *)attributesToKeyPath;
- (void)addAttributeWithProperty:(NSString *)property keyPath:(NSString *)keyPath;

- (void)addRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath;
- (void)addToManyRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath;

- (id)extractRootFromExternalRepresentation:(id)externalRepresentation;

@end

@interface FEMMapping (Deprecated)

- (void)addAttributeMappingFromArray:(NSArray *)attributes __attribute__((deprecated("will become obsolete in 0.6.0; use -[FEMMapping addAttributesFromArray:] instead")));
- (void)addAttributeMappingDictionary:(NSDictionary *)attributesToKeyPath __attribute__((deprecated("will become obsolete in 0.6.0; use -[FEMMapping addAttributesFromDictionary:] instead")));
- (void)addAttributeMappingOfProperty:(NSString *)property atKeypath:(NSString *)keypath __attribute__((deprecated("will become obsolete in 0.6.0; use -[FEMMapping addAttributeWithProperty:keyPath:] instead")));

@property (nonatomic, strong, readonly) NSArray *attributeMappings __attribute__((deprecated("will become obsolete in 0.6.0; use -[FEMMapping attributes] instead")));
- (void)addAttributeMapping:(FEMAttributeMapping *)attributeMapping __attribute__((deprecated("will become obsolete in 0.6.0; use -[FEMMapping addAttribute:] instead")));
- (FEMAttributeMapping *)attributeMappingForProperty:(NSString *)property __attribute__((deprecated("will become obsolete in 0.6.0; use -[FEMMapping attributeForProperty:] instead")));

@property (nonatomic, strong, readonly) NSArray *relationshipMappings __attribute__((deprecated("will become obsolete in 0.6.0; use -[FEMMapping relationships] instead")));
- (void)addRelationshipMapping:(FEMRelationshipMapping *)relationshipMapping __attribute__((deprecated("will become obsolete in 0.6.0; use -[FEMMapping addRelationship:] instead")));
- (FEMRelationshipMapping *)relationshipMappingForProperty:(NSString *)property __attribute__((deprecated("will become obsolete in 0.6.0; use -[FEMMapping relationshipForProperty:] instead")));

@end