//
//  EMKManagedObjectDeserializer.h
//  EasyMappingCoreDataExample
//
//  Created by Lucas Medeiros on 2/24/14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EMKDeserializer.h"

@class EMKManagedObjectMapping, NSManagedObject, NSFetchRequest, NSManagedObjectContext;

@interface EMKManagedObjectDeserializer : EMKDeserializer

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation
                                 usingMapping:(EMKManagedObjectMapping *)mapping
			                          context:(NSManagedObjectContext *)context;

+ (id)fillObject:(NSManagedObject *)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(EMKManagedObjectMapping *)mapping;

/** Get an array of managed objects from an external representation. If the objectMapping has
    a primary key existing objects will be updated. This method is slow and it doesn't
    delete obsolete objects, use
    syncArrayOfObjectsFromExternalRepresentation:withMapping:fetchRequest:inManagedObjectContext:
    instead.
 */
+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                            usingMapping:(EMKManagedObjectMapping *)mapping
			                                     context:(NSManagedObjectContext *)context;

/** Synchronize the objects in the managed obejct context with the objets from an external
    representation. Any new objects will be created, any existing objects will be updated
    and any object not present in the external representation will be deleted from the
    managed object context. The fetch request is used to pre-fetch all existing objects.
    This speeds up managed object lookup by a very significant amount.
 */
+ (NSArray *)syncArrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                              withMapping:(EMKManagedObjectMapping *)mapping
		                                     fetchRequest:(NSFetchRequest *)fetchRequest
					               inManagedObjectContext:(NSManagedObjectContext *)moc;

@end