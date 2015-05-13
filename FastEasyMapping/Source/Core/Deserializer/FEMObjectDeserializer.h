// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMDeserializer.h"
#import "FEMObjectMapping.h"

@compatibility_alias FEMObjectDeserializer FEMDeserializer;

@interface FEMDeserializer (FEMObjectDeserializer_Deprecated)

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMObjectMapping *)mapping __attribute__((deprecated("Use +[FEMDeserializer objectFromRepresentation:mapping:] instead")));
+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMObjectMapping *)mapping __attribute__((deprecated("Use +[FEMDeserializer fillObject:fromRepresentation:mapping:] instead")));
+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation usingMapping:(FEMObjectMapping *)mapping __attribute__((deprecated("Use +[FEMDeserializer collectionFromRepresentation:mapping:] instead")));

@end

//+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMObjectMapping *)mapping {
//return [self objectFromRepresentation:externalRepresentation mapping:mapping];
//}
//
//+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMObjectMapping *)mapping {
//return [self fillObject:object fromRepresentation:externalRepresentation mapping:mapping];
//}
//
//+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation usingMapping:(FEMObjectMapping *)mapping {
//return [self collectionFromRepresentation:externalRepresentation mapping:mapping];
//}
