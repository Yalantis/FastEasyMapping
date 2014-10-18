// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FEMObjectMapping;

@interface FEMObjectDeserializer : NSObject

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMObjectMapping *)mapping;

+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMObjectMapping *)mapping;

+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation usingMapping:(FEMObjectMapping *)mapping;

@end