// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>
#import "FEMManagedObjectMapping.h"

@class FEMObjectStore, FEMMapping, NSManagedObject, NSFetchRequest, NSManagedObjectContext;
@class FEMDeserializer;

@protocol FEMDeserializerDelegate <NSObject>

@optional
- (void)deserializer:(FEMDeserializer *)deserializer willMapObjectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping;
- (void)deserializer:(FEMDeserializer *)deserializer didMapObject:(id)object fromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping;

- (void)deserializer:(FEMDeserializer *)deserializer willMapCollectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping;
- (void)deserializer:(FEMDeserializer *)deserializer didMapCollection:(NSArray *)collection fromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping;

@end

@interface FEMDeserializer : NSObject

@property (nonatomic, strong, readonly) FEMObjectStore *store;
- (id)initWithStore:(FEMObjectStore *)store;

@property (nonatomic, unsafe_unretained) id<FEMDeserializerDelegate> delegate;

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


@interface FEMDeserializer (FEMObjectDeserializer_Deprecated)

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMMapping *)mapping; // __attribute__((deprecated("Use +[FEMDeserializer objectFromRepresentation:mapping:] instead")));
+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMMapping *)mapping; // __attribute__((deprecated("Use +[FEMDeserializer fillObject:fromRepresentation:mapping:] instead")));
+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation usingMapping:(FEMMapping *)mapping; // __attribute__((deprecated("Use +[FEMDeserializer collectionFromRepresentation:mapping:] instead")));

@end

@interface FEMDeserializer (FEMManagedObjectDeserializer_Deprecated)

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMMapping *)mapping context:(NSManagedObjectContext *)context; // __attribute__((deprecated("Use +[FEMDeserializer objectFromRepresentation:mapping:context:] instead")));
+ (id)fillObject:(NSManagedObject *)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMMapping *)mapping; // __attribute__((deprecated("Use +[FEMDeserializer fillObject:fromRepresentation:mapping:] instead")));
+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation usingMapping:(FEMMapping *)mapping context:(NSManagedObjectContext *)context; // __attribute__((deprecated("Use +[FEMDeserializer collectionFromRepresentation:mapping:context:] instead")));

+ (NSArray *)synchronizeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                            usingMapping:(FEMMapping *)mapping
                                               predicate:(NSPredicate *)predicate
                                                 context:(NSManagedObjectContext *)context __attribute__((unavailable));

@end