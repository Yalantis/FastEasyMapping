// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMObjectStore.h"

@class NSManagedObjectContext;

NS_ASSUME_NONNULL_BEGIN

@interface FEMManagedObjectStore : FEMObjectStore

- (instancetype)initWithContext:(NSManagedObjectContext *)context NS_DESIGNATED_INITIALIZER;
@property (nonatomic, strong, readonly) NSManagedObjectContext *context;

@property (nonatomic) BOOL saveContextOnCommit;

@end

NS_ASSUME_NONNULL_END