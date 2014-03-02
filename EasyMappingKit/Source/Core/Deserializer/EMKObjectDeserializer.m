//
//  EMKObjectDeserializer.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 21/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "EMKObjectDeserializer.h"
#import "EMKPropertyHelper.h"
#import "EMKAttributeMapping.h"
#import "EMKTransformer.h"
#import <objc/runtime.h>
#import "EMKManagedObjectDeserializer.h"
#import "NSArray+EMKExtension.h"
#import "NSDictionary+EMKFieldMapping.h"
#import "EMKAttributeMapping+Extension.h"
#import "EMKObjectMapping.h"
#import "EMKRelationshipMapping.h"

@implementation EMKObjectDeserializer

+ (id)deserializeObjectRepresentation:(NSDictionary *)externalRepresentation usingMapping:(EMKObjectMapping *)mapping
{
    id object = [[mapping.objectClass alloc] init];
    return [self fillObject:object fromRepresentation:externalRepresentation usingMapping:mapping];
}

+ (id)fillObject:(id)object fromRepresentation:(NSDictionary *)representation usingMapping:(EMKObjectMapping *)mapping {
	NSDictionary *objectRepresentation = mapping.rootPath ? representation[mapping.rootPath] : representation;

	for (EMKAttributeMapping *attributeMapping in mapping.attributeMappings) {
		[attributeMapping mapValueToObject:object fromRepresentation:objectRepresentation];
	}

	for (EMKRelationshipMapping *relationshipMapping in mapping.relationshipMappings) {
		id relationshipRepresentation = relationshipMapping.keyPath ? objectRepresentation[relationshipMapping.keyPath] : objectRepresentation;
		if (!relationshipRepresentation) continue;

		if (relationshipMapping.isToMany) {
			id deserializedRelationship = [self deserializeCollectionRepresentation:relationshipRepresentation
			                                                           usingMapping:relationshipMapping.objectMapping];

			objc_property_t property = class_getProperty([object class], [relationshipMapping.property UTF8String]);
			[object setValue:[deserializedRelationship ek_propertyRepresentation:property]
			      forKeyPath:relationshipMapping.property];
		} else {
			id deserializedRelationship = [self deserializeObjectRepresentation:relationshipRepresentation
			                                                       usingMapping:relationshipMapping.objectMapping];
			[object setValue:deserializedRelationship forKeyPath:relationshipMapping.property];
		}
	}

    return object;
}

+ (NSArray *)deserializeCollectionRepresentation:(NSArray *)externalRepresentation usingMapping:(EMKObjectMapping *)mapping
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *representation in externalRepresentation) {
        id parsedObject = [self deserializeObjectRepresentation:representation usingMapping:mapping];
        [array addObject:parsedObject];
    }
    return [NSArray arrayWithArray:array];
}

@end