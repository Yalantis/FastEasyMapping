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
#import "EMKPropertyHelper.h"

#import "NSArray+EMKExtension.h"
#import "NSDictionary+EMKFieldMapping.h"
#import "EMKAttributeMapping+Extension.h"
#import "EMKRelationshipMapping.h"

@implementation EMKManagedObjectDeserializer

+ (id)getExistingObjectFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EMKManagedObjectMapping *)mapping inManagedObjectContext:(NSManagedObjectContext *)moc {
	EMKAttributeMapping *primaryKeyFieldMapping = [mapping primaryKeyMapping];
	id primaryKeyValue = [primaryKeyFieldMapping mapValue:[externalRepresentation valueForKeyPath:primaryKeyFieldMapping.keyPath]];

//	id primaryKeyValue = [self getValueOfField:primaryKeyFieldMapping fromRepresentation:externalRepresentation];
	if (!primaryKeyValue || primaryKeyValue == (id)[NSNull null])
		return nil;

	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:mapping.entityName];
	[request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", mapping.primaryKey, primaryKeyValue]];

	NSArray *array = [moc executeFetchRequest:request error:NULL];
	if (array.count == 0)
		return nil;

	return [array lastObject];
}

+ (id)deserializeObjectRepresentation:(NSDictionary *)representation usingMapping:(EMKManagedObjectMapping *)mapping context:(NSManagedObjectContext *)context
{
	NSManagedObject* object = [self getExistingObjectFromExternalRepresentation:representation
	                                                                withMapping:mapping
			                                             inManagedObjectContext:context];
	if (!object)
		object = [NSEntityDescription insertNewObjectForEntityForName:mapping.entityName inManagedObjectContext:context];
	return [self fillObject:object fromRepresentation:representation usingMapping:mapping];
}

+ (id)fillObject:(NSManagedObject *)object fromRepresentation:(NSDictionary *)representation usingMapping:(EMKManagedObjectMapping *)mapping {
	NSDictionary *objectRepresentation = mapping.rootPath ? representation[mapping.rootPath] : representation;

	for (EMKAttributeMapping *attributeMapping in mapping.attributeMappings) {
		[attributeMapping mapValueToObject:object fromRepresentation:objectRepresentation];
	}

	NSManagedObjectContext *context = object.managedObjectContext;
	for (EMKRelationshipMapping *relationshipMapping in mapping.relationshipMappings) {
		id relationshipRepresentation = relationshipMapping.keyPath ? objectRepresentation[relationshipMapping.keyPath] : objectRepresentation;
		if (!relationshipRepresentation) continue;

		if (relationshipMapping.isToMany) {
			id deserializedRelationship = [self deserializeCollectionRepresentation:relationshipRepresentation
			                                                           usingMapping:relationshipMapping.objectMapping
						                                                    context:context];

			objc_property_t property = class_getProperty([object class], [relationshipMapping.property UTF8String]);
			[object setValue:[deserializedRelationship ek_propertyRepresentation:property]
			          forKey:relationshipMapping.property];
		} else {
			id deserializedRelationship = [self deserializeObjectRepresentation:relationshipRepresentation
			                                                       usingMapping:relationshipMapping.objectMapping
						                                                context:context];
			[object setValue:deserializedRelationship forKey:relationshipMapping.property];
		}
	}

	return object;
}

+ (NSArray *)deserializeCollectionRepresentation:(NSArray *)externalRepresentation
                                    usingMapping:(EMKManagedObjectMapping *)mapping
			                             context:(NSManagedObjectContext *)context
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSDictionary *representation in externalRepresentation) {
		id parsedObject = [self deserializeObjectRepresentation:representation usingMapping:mapping context:context];
		[array addObject:parsedObject];
	}
	return [NSArray arrayWithArray:array];
}

+ (NSArray *)syncArrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                              withMapping:(EMKManagedObjectMapping *)mapping
		                                     fetchRequest:(NSFetchRequest*)fetchRequest
					               inManagedObjectContext:(NSManagedObjectContext *)moc
{
	NSAssert(mapping.primaryKey, @"A objectMapping with a primary key is required");
	EMKAttributeMapping * primaryKeyFieldMapping = [mapping primaryKeyMapping];

	// Create a dictionary that maps primary keys to existing objects
	NSArray* existing = [moc executeFetchRequest:fetchRequest error:NULL];
	NSDictionary* existingByPK = [NSDictionary dictionaryWithObjects:existing forKeys:[existing valueForKey:primaryKeyFieldMapping.property]];

	NSMutableArray *array = [NSMutableArray array];
	for (NSDictionary *representation in externalRepresentation) {
		// Look up the object by its primary key

		id primaryKeyValue = [primaryKeyFieldMapping mapValue:[externalRepresentation valueForKeyPath:primaryKeyFieldMapping.keyPath]];
		id object = [existingByPK objectForKey:primaryKeyValue];

		// Create a new object if necessary
		if (!object)
			object = [NSEntityDescription insertNewObjectForEntityForName:mapping.entityName inManagedObjectContext:moc];

		[self fillObject:object fromRepresentation:representation usingMapping:mapping];
		[array addObject:object];
	}

	// Any object returned by the fetch request not in the external represntation has to be deleted
	NSMutableSet* toDelete = [NSMutableSet setWithArray:existing];
	[toDelete minusSet:[NSSet setWithArray:array]];
	for (NSManagedObject* o in toDelete)
		[moc deleteObject:o];

	return [NSArray arrayWithArray:array];
}

@end