// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "MagicalRecord+FEMExtension.h"

@import CoreData;

#import "Fixture.h"

@implementation MagicalRecord (FEMExtension)

+ (void)fem_setupTestsSQLiteStore {
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle bundleForClass:[Fixture class]]]];
    [NSManagedObjectModel MR_setDefaultManagedObjectModel:model];
    
    NSURL *url = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSString *storeName = @"FastEasyMappingTests.sqlite";
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:[url URLByAppendingPathComponent:storeName]];
}

+ (void)fem_cleanUp {
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
    for (NSPersistentStore *store in coordinator.persistentStores) {
        if (store.URL != nil) {
            [coordinator destroyPersistentStoreAtURL:store.URL withType:store.type options:store.options error:nil];
        }
        [coordinator removePersistentStore:store error:nil];
    }

    [MagicalRecord cleanUp];
}

@end
