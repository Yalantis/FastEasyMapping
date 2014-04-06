//
//  EMKManagedObjectDeserializer.h
//  EasyMappingCoreDataExample
//
//  Created by Lucas Medeiros on 2/24/14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMKManagedObjectMapping, NSManagedObject, NSFetchRequest, NSManagedObjectContext;

@interface EMKManagedObjectDeserializer : NSObject

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

@end