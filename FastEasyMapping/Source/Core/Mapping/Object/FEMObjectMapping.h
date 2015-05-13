// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMMapping.h"

@compatibility_alias FEMObjectMapping FEMMapping;

@interface FEMMapping (FEMObjectMapping_Deprecated)

+ (instancetype)mappingForClass:(Class)objectClass
                  configuration:(void (^)(FEMMapping *mapping))configuration __attribute__((deprecated("Use -[FEMMapping initWithObjectClass:] instead")));

+ (instancetype)mappingForClass:(Class)objectClass
                       rootPath:(NSString *)rootPath
                  configuration:(void (^)(FEMMapping *mapping))configuration __attribute__((deprecated("Use -[FEMMapping initWithObjectClass:rootPath:] instead")));

@end
