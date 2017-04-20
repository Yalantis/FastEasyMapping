// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "MagicalRecord+FEMExtension.h"

@import CoreData;

#import "Fixture.h"

@implementation MagicalRecord (FEMExtension)

+ (void)fem_setupTestsSQLiteStore {
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle bundleForClass:[Fixture class]]]];
    [NSManagedObjectModel MR_setDefaultManagedObjectModel:model];
    
    NSURL *baseURL = [[NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES]
                      URLByAppendingPathComponent:@"com.FastEaysMapping.Core.Tests" isDirectory:YES];
    NSURL *url = [NSURL fileURLWithPath:@"database" relativeToURL:baseURL];
    
    [[NSFileManager defaultManager] removeItemAtURL:baseURL error:nil]; // drop if there any sqlite store
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:url];
}

+ (void)fem_cleanUp {
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
    for (NSPersistentStore *store in coordinator.persistentStores) {
        [coordinator removePersistentStore:store error:nil];

        if (store.URL != nil) {
            // running on iOS 9+
            if ([coordinator respondsToSelector:@selector(destroyPersistentStoreAtURL:withType:options:error:)]) {
                [coordinator destroyPersistentStoreAtURL:store.URL withType:store.type options:store.options error:nil];
            } else {
                NSURL *baseURL = [store.URL URLByDeletingLastPathComponent];
                [[NSFileManager defaultManager] removeItemAtURL:baseURL error:nil];
            }
        }
    }
    
    [MagicalRecord cleanUp];
}

@end
