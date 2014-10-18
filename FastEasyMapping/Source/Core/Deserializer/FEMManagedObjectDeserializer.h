// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMManagedObjectMapping, NSManagedObject, NSFetchRequest, NSManagedObjectContext;

@interface FEMManagedObjectDeserializer : NSObject

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation
                                 usingMapping:(FEMManagedObjectMapping *)mapping
			                          context:(NSManagedObjectContext *)context;

+ (id)fillObject:(NSManagedObject *)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMManagedObjectMapping *)mapping;

/** Get an array of managed objects from an external representation. If the objectMapping has
    a primary key existing objects will be updated. This method is slow and it doesn't
    delete obsolete objects, use
    syncArrayOfObjectsFromExternalRepresentation:withMapping:fetchRequest:inManagedObjectContext:
    instead.
 */
+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                            usingMapping:(FEMManagedObjectMapping *)mapping
			                                     context:(NSManagedObjectContext *)context;

+ (NSArray *)synchronizeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                            usingMapping:(FEMManagedObjectMapping *)mapping
                                               predicate:(NSPredicate *)predicate
                                                 context:(NSManagedObjectContext *)context;

@end