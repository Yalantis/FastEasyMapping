// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMDeserializer.h"
#import "FEMManagedObjectMapping.h"

@class NSManagedObject, NSFetchRequest, NSManagedObjectContext;

@compatibility_alias FEMManagedObjectDeserializer FEMDeserializer;

@interface FEMDeserializer (FEMManagedObjectDeserializer_Deprecated)

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMManagedObjectMapping *)mapping context:(NSManagedObjectContext *)context __attribute__((deprecated("Use +[FEMDeserializer objectFromRepresentation:mapping:context:] instead")));
+ (id)fillObject:(NSManagedObject *)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMManagedObjectMapping *)mapping __attribute__((deprecated("Use +[FEMDeserializer fillObject:fromRepresentation:mapping:] instead")));
+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation usingMapping:(FEMManagedObjectMapping *)mapping context:(NSManagedObjectContext *)context __attribute__((deprecated("Use +[FEMDeserializer collectionFromRepresentation:mapping:context:] instead")));

+ (NSArray *)synchronizeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                            usingMapping:(FEMManagedObjectMapping *)mapping
                                               predicate:(NSPredicate *)predicate
                                                 context:(NSManagedObjectContext *)context __attribute__((unavailable));

@end