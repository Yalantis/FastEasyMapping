// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMObjectStore, FEMMapping, NSManagedObject, NSFetchRequest, NSManagedObjectContext;

@interface FEMDeserializer : NSObject

@property (nonatomic, strong, readonly) FEMObjectStore *store;
- (id)initWithStore:(FEMObjectStore *)store;

- (id)deserializeObjectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping;
- (id)fillObject:(id)object fromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping;
- (NSArray *)deserializeCollectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping;

@end

@interface FEMDeserializer (Shortcut)

+ (id)deserializeObjectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping context:(NSManagedObjectContext *)context;
+ (id)fillObject:(NSManagedObject *)object fromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping;

/** Get an array of managed objects from an external representation. If the objectMapping has
a primary key existing objects will be updated. This method is slow and it doesn't
delete obsolete objects, use
syncArrayOfObjectsFromExternalRepresentation:withMapping:fetchRequest:inManagedObjectContext:
instead.
*/
+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                            usingMapping:(FEMMapping *)mapping
                                                 context:(NSManagedObjectContext *)context;

+ (NSArray *)synchronizeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                            usingMapping:(FEMMapping *)mapping
                                               predicate:(NSPredicate *)predicate
                                                 context:(NSManagedObjectContext *)context;


@end