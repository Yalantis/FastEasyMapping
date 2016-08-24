// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>
#import "FEMMapping.h"
#import "FEMSerializer.h"

NS_ASSUME_NONNULL_BEGIN

@interface FEMSerializer : NSObject

+ (NSDictionary *)serializeObject:(id)object usingMapping:(FEMMapping *)mapping;
+ (id)serializeCollection:(NSArray *)collection usingMapping:(FEMMapping *)mapping;

@end

NS_ASSUME_NONNULL_END
