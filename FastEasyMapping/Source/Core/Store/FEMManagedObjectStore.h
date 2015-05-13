// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMObjectStore.h"

@class NSManagedObjectContext;

@interface FEMManagedObjectStore : FEMObjectStore

- (instancetype)initWithContext:(NSManagedObjectContext *)context;
@property (nonatomic, strong, readonly) NSManagedObjectContext *context;

@property (nonatomic) BOOL saveContextOnCommit;

@end