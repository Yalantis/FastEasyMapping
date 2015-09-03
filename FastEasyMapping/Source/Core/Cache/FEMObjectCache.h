// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMMapping, NSManagedObjectContext;
@class FEMObjectCache;

typedef NSArray *(^FEMObjectCacheObjectsSource)(FEMMapping *mapping, NSArray *primaryKeys);

@interface FEMObjectCache : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *context;

- (instancetype)initWithMapping:(FEMMapping *)mapping representation:(id)representation  context:(NSManagedObjectContext *)context;
- (instancetype)initWithMapping:(FEMMapping *)mapping representation:(id)representation source:(FEMObjectCacheObjectsSource)source;

- (id)existingObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping;
- (id)existingObjectForPrimaryKey:(id)primaryKey mapping:(FEMMapping *)mapping;

- (void)addExistingObject:(id)object mapping:(FEMMapping *)mapping;
- (NSDictionary *)existingObjectsForMapping:(FEMMapping *)mapping;

@end