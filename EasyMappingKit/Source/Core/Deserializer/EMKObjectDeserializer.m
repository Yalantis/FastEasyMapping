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
#import <objc/runtime.h>
#import "EMKManagedObjectDeserializer.h"
#import "NSArray+EMKExtension.h"
#import "EMKAttributeMapping+Extension.h"
#import "EMKObjectMapping.h"
#import "EMKRelationshipMapping.h"

@implementation EMKObjectDeserializer

+ (id)deserializeObjectRepresentation:(NSDictionary *)representation usingMapping:(EMKObjectMapping *)mapping {
	id object = [[mapping.objectClass alloc] init];
	return [self fillObject:object fromRepresentation:representation usingMapping:mapping];
}

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(EMKObjectMapping *)mapping {
	NSDictionary *representation = [mapping extractRootFromExternalRepresentation:externalRepresentation];
	return [self deserializeObjectRepresentation:representation usingMapping:mapping];
}

+ (id)fillObject:(id)object fromRepresentation:(NSDictionary *)representation usingMapping:(EMKObjectMapping *)mapping {
	for (EMKAttributeMapping *attributeMapping in mapping.attributeMappings) {
		[attributeMapping mapValueToObject:object fromRepresentation:representation];
	}

	for (EMKRelationshipMapping *relationshipMapping in mapping.relationshipMappings) {
		id deserializedRelationship = nil;
		id relationshipRepresentation = [relationshipMapping extractRootFromExternalRepresentation:representation];

		if (relationshipMapping.isToMany) {
			deserializedRelationship = [self deserializeCollectionRepresentation:relationshipRepresentation
			                                                        usingMapping:relationshipMapping.objectMapping];

			objc_property_t property = class_getProperty([object class], [relationshipMapping.property UTF8String]);
			deserializedRelationship = [deserializedRelationship ek_propertyRepresentation:property];
		} else {
			deserializedRelationship = [self deserializeObjectRepresentation:relationshipRepresentation
			                                                    usingMapping:relationshipMapping.objectMapping];
		}

		if (deserializedRelationship) {
			[object setValue:deserializedRelationship forKeyPath:relationshipMapping.property];
		}
	}

	return object;
}

+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(EMKObjectMapping *)mapping {
	NSDictionary *representation = [mapping extractRootFromExternalRepresentation:externalRepresentation];
	return [self fillObject:object fromRepresentation:representation usingMapping:mapping];
}

+ (NSArray *)deserializeCollectionRepresentation:(NSArray *)representation usingMapping:(EMKObjectMapping *)mapping {
	NSMutableArray *output = [NSMutableArray array];
	for (NSDictionary *objectRepresentation in representation) {
		@autoreleasepool {
			[output addObject:[self deserializeObjectRepresentation:objectRepresentation usingMapping:mapping]];
		}
	}
	return [output copy];
}

+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation usingMapping:(EMKObjectMapping *)mapping {
	NSArray *representation = [mapping extractRootFromExternalRepresentation:externalRepresentation];
	return [self deserializeCollectionRepresentation:representation usingMapping:mapping];
}

@end