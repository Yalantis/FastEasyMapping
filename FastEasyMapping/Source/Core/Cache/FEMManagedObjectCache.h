// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMManagedObjectCache, FEMManagedObjectMapping, NSManagedObjectContext;

@interface FEMManagedObjectCache : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *context;

- (instancetype)initWithMapping:(FEMManagedObjectMapping *)mapping
         externalRepresentation:(id)externalRepresentation
					    context:(NSManagedObjectContext *)context;

#pragma mark -

- (id)existingObjectForRepresentation:(id)representation mapping:(FEMManagedObjectMapping *)mapping;
- (id)existingObjectForPrimaryKey:(id)primaryKey mapping:(FEMManagedObjectMapping *)mapping;

- (void)addExistingObject:(id)object usingMapping:(FEMManagedObjectMapping *)mapping;

- (NSDictionary *)existingObjectsForMapping:(FEMManagedObjectMapping *)mapping;

@end