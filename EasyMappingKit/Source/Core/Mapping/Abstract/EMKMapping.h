//
//  EMKMapping.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 21/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMKAttributeMapping, EMKRelationshipMapping;

@interface EMKMapping : NSObject {
    @protected
	NSMutableDictionary *_attributesMap;
	NSMutableDictionary *_relationshipsMap;
}

@property (nonatomic, copy) NSString *rootPath;
- (id)initWithRootPath:(NSString *)rootPath;

@property (nonatomic, strong, readonly) NSArray *attributeMappings;
- (void)addAttributeMapping:(EMKAttributeMapping *)attributeMapping;

- (void)addAttributeMappingFromArray:(NSArray *)attributes;
- (void)addAttributeMappingDictionary:(NSDictionary *)attributesToKeyPath;


@property (nonatomic, strong, readonly) NSArray *relationshipMappings;
- (void)addRelationshipMapping:(EMKRelationshipMapping *)relationshipMapping;

@end