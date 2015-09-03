// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMMapping, NSManagedObjectContext;

typedef id<NSFastEnumeration> (^FEMObjectCacheSource)(FEMMapping *objectMapping, NSSet *primaryKeys);

@interface FEMObjectCache : NSObject

- (instancetype)initWithMapping:(FEMMapping *)mapping representation:(id)representation source:(FEMObjectCacheSource)source NS_DESIGNATED_INITIALIZER;

- (id)existingObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping;
- (id)existingObjectForPrimaryKey:(id)primaryKey mapping:(FEMMapping *)mapping;

- (void)addExistingObject:(id)object mapping:(FEMMapping *)mapping;
- (NSDictionary *)existingObjectsForMapping:(FEMMapping *)mapping;

@end

@interface FEMObjectCache (CoreData)

- (instancetype)initWithMapping:(FEMMapping *)mapping representation:(id)representation context:(NSManagedObjectContext *)context;

@end