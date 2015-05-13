// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMMapping.h"

@compatibility_alias FEMObjectMapping FEMMapping;

@interface FEMMapping (FEMObjectMapping_Deprecated)

+ (FEMObjectMapping *)mappingForClass:(Class)objectClass
                        configuration:(void (^)(FEMObjectMapping *mapping))configuration __attribute__((deprecated("Use -[FEMMapping initWithObjectClass:] instead")));

+ (FEMObjectMapping *)mappingForClass:(Class)objectClass
                             rootPath:(NSString *)rootPath
                        configuration:(void (^)(FEMObjectMapping *mapping))configuration __attribute__((deprecated("Use -[FEMMapping initWithObjectClass:rootPath:] instead")));

@end
