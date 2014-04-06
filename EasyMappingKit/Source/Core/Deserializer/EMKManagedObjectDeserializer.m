//
//  EMKManagedObjectDeserializer.m
//  EasyMappingCoreDataExample
//
//  Created by Lucas Medeiros on 2/24/14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EMKManagedObjectDeserializer.h"

#import <CoreData/CoreData.h>

#import "EMKManagedObjectMapping.h"
#import "EMKAttributeMapping.h"

#import "NSArray+EMKExtension.h"
#import "EMKAttributeMapping+Extension.h"
#import "EMKRelationshipMapping.h"
#import "EMKLookupCache.h"

@implementation EMKManagedObjectDeserializer

#pragma mark - Deserialization

+ (id)_deserializeObjectRepresentation:(NSDictionary *)representation usingMapping:(EMKManagedObjectMapping *)mapping context:(NSManagedObjectContext *)context {
	id object = [EMKLookupCacheGetCurrent() existingObjectForRepresentation:representation mapping:mapping];
	if (!object) {
		object = [NSEntityDescription insertNewObjectForEntityForName:mapping.entityName inManagedObjectContext:context];
	}

	[self _fillObject:object fromRepresentation:representation usingMapping:mapping];

	if ([object isInserted] && mapping.primaryKey) {
		[EMKLookupCacheGetCurrent() addExistingObject:object usingMapping:mapping];
	}

	return object;
}

+ (id)_deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation
                                  usingMapping:(EMKManagedObjectMapping *)mapping
			                           context:(NSManagedObjectContext *)context {
	id objectRepresentation = [mapping extractRootFromExternalRepresentation:externalRepresentation];
	return [self _deserializeObjectRepresentation:objectRepresentation usingMapping:mapping context:context];
}


+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation
                                 usingMapping:(EMKManagedObjectMapping *)mapping
			                          context:(NSManagedObjectContext *)context {
	EMKLookupCache *cache = [[EMKLookupCache alloc] initWithMapping:mapping
	                                         externalRepresentation:externalRepresentation
						                                    context:context];
	EMKLookupCacheSetCurrent(cache);
	id object = [self _deserializeObjectExternalRepresentation:externalRepresentation usingMapping:mapping context:context];
	EMKLookupCacheRemoveCurrent();

	return object;
}

+ (id)_fillObject:(NSManagedObject *)object fromRepresentation:(NSDictionary *)representation usingMapping:(EMKManagedObjectMapping *)mapping {
	for (EMKAttributeMapping *attributeMapping in mapping.attributeMappings) {
		[attributeMapping mapValueToObject:object fromRepresentation:representation];
	}

	NSManagedObjectContext *context = object.managedObjectContext;
	for (EMKRelationshipMapping *relationshipMapping in mapping.relationshipMappings) {
		id deserializedRelationship = nil;
		id relationshipRepresentation = [relationshipMapping extractRootFromExternalRepresentation:representation];

		if (relationshipMapping.isToMany) {
			deserializedRelationship = [self _deserializeCollectionRepresentation:relationshipRepresentation
			                                                         usingMapping:relationshipMapping.objectMapping
						                                                  context:context];

			objc_property_t property = class_getProperty([object class], [relationshipMapping.property UTF8String]);
			deserializedRelationship = [deserializedRelationship ek_propertyRepresentation:property];
		} else {
			deserializedRelationship = [self _deserializeObjectRepresentation:relationshipRepresentation
			                                                     usingMapping:relationshipMapping.objectMapping
						                                              context:context];
		}

		if (deserializedRelationship) {
			[object setValue:deserializedRelationship forKey:relationshipMapping.property];
		}
	}

	return object;
}

+ (id)fillObject:(NSManagedObject *)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(EMKManagedObjectMapping *)mapping {
	id objectRepresentation = [mapping extractRootFromExternalRepresentation:externalRepresentation];
	return [self _fillObject:object fromRepresentation:objectRepresentation usingMapping:mapping];
}

+ (NSArray *)_deserializeCollectionRepresentation:(NSArray *)representation
                                     usingMapping:(EMKManagedObjectMapping *)mapping
			                              context:(NSManagedObjectContext *)context {
	NSMutableArray *output = [NSMutableArray array];
	for (id objectRepresentation in representation) {
		@autoreleasepool {
			[output addObject:[self _deserializeObjectRepresentation:objectRepresentation
			                                            usingMapping:mapping
						                                     context:context]];
		}
	}
	return [output copy];
}

+ (NSArray *)_deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                             usingMapping:(EMKManagedObjectMapping *)mapping
			                                      context:(NSManagedObjectContext *)context {
	id representation = [mapping extractRootFromExternalRepresentation:externalRepresentation];
	return [self _deserializeCollectionRepresentation:representation usingMapping:mapping context:context];
}

+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                            usingMapping:(EMKManagedObjectMapping *)mapping
			                                     context:(NSManagedObjectContext *)context {
	EMKLookupCache *cache = [[EMKLookupCache alloc] initWithMapping:mapping
	                                         externalRepresentation:externalRepresentation
						                                    context:context];
	EMKLookupCacheSetCurrent(cache);
	NSArray *output = [self _deserializeCollectionExternalRepresentation:externalRepresentation
	                                                        usingMapping:mapping
				                                                 context:context];
	EMKLookupCacheRemoveCurrent();

	return output;
}

// unused
+ (NSArray *)syncArrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                              withMapping:(EMKManagedObjectMapping *)mapping
		                                     fetchRequest:(NSFetchRequest *)fetchRequest
					               inManagedObjectContext:(NSManagedObjectContext *)moc {
	NSAssert(mapping.primaryKey, @"A objectMapping with a primary key is required");
	EMKAttributeMapping *primaryKeyFieldMapping = [mapping primaryKeyMapping];

	// Create a dictionary that maps primary keys to existing objects
	NSArray *existing = [moc executeFetchRequest:fetchRequest error:NULL];
	NSDictionary *existingByPK = [NSDictionary dictionaryWithObjects:existing
	                                                         forKeys:[existing valueForKey:primaryKeyFieldMapping.property]];

	NSMutableArray *array = [NSMutableArray array];
	for (NSDictionary *representation in externalRepresentation) {
		// Look up the object by its primary key

		id primaryKeyValue = [primaryKeyFieldMapping mapValue:[externalRepresentation valueForKeyPath:primaryKeyFieldMapping.keyPath]];
		id object = [existingByPK objectForKey:primaryKeyValue];

		// Create a new object if necessary
		if (!object) {
					object = [NSEntityDescription insertNewObjectForEntityForName:mapping.entityName
					                                       inManagedObjectContext:moc];
		}

		[self fillObject:object fromExternalRepresentation:representation usingMapping:mapping];
		[array addObject:object];
	}

	// Any object returned by the fetch request not in the external represntation has to be deleted
	NSMutableSet *toDelete = [NSMutableSet setWithArray:existing];
	[toDelete minusSet:[NSSet setWithArray:array]];
	for (NSManagedObject *o in toDelete) {
			[moc deleteObject:o];
	}

	return [NSArray arrayWithArray:array];
}

@end