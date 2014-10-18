// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>
#import "FEMMapping.h"

@interface FEMObjectMapping : FEMMapping

@property (nonatomic, readonly) Class objectClass;

- (id)initWithObjectClass:(Class)objectClass;
- (id)initWithObjectClass:(Class)objectClass rootPath:(NSString *)rootPath;

+ (instancetype)mappingForClass:(Class)objectClass configuration:(void (^)(FEMObjectMapping *mapping))configuration;
+ (instancetype)mappingForClass:(Class)objectClass
                       rootPath:(NSString *)rootPath
		          configuration:(void (^)(FEMObjectMapping *mapping))configuration;

@end