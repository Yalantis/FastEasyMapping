// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@class FEMObjectStore, FEMMapping, NSManagedObject, NSFetchRequest, NSManagedObjectContext;

@interface FEMDeserializer : NSObject

@property (nonatomic, strong, readonly) FEMObjectStore *store;
- (id)initWithStore:(FEMObjectStore *)store;

- (id)objectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping;
- (id)fillObject:(id)object fromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping;
- (NSArray *)collectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping;

@end

@interface FEMDeserializer (Extension)

+ (id)objectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping context:(NSManagedObjectContext *)context;
+ (id)objectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping;

+ (id)fillObject:(id)object fromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping;

+ (NSArray *)collectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping context:(NSManagedObjectContext *)context;
+ (NSArray *)collectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping;

@end