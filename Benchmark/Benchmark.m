
#import <XCTest/XCTest.h>

@import FastEasyMapping;
#import <MagicalRecord/MagicalRecord.h>

#import "Parent+Mapping.h"
#import "Child+Mapping.h"

const NSUInteger ObjectsCount = 10000;

@interface Benchmark : XCTestCase

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSArray *representation;

@end

@implementation Benchmark

- (void)setUp {
    [super setUp];
    
    [MagicalRecord setDefaultModelFromClass:[self class]];
    [MagicalRecord setupCoreDataStackWithStoreNamed:[NSBundle bundleForClass:self.class].bundleIdentifier];
    self.context = [NSManagedObjectContext MR_rootSavingContext];
    
    self.representation = [self generateTestData:ObjectsCount];
}

- (void)tearDown {
    for (NSPersistentStore *store in self.context.persistentStoreCoordinator.persistentStores) {
        [self.context.persistentStoreCoordinator destroyPersistentStoreAtURL:store.URL withType:store.type options:store.options error:nil];
    }
    
    [super tearDown];
}

- (NSDictionary<NSString *, id> *)dummyDataWithValue:(NSInteger)i {
    NSString *string = [NSString stringWithFormat:@"String:%zd", i];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:i];
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
    NSDecimalNumber *decimal = [NSDecimalNumber maximumDecimalNumber];

    return @{
        @"boolValue": @true,
        @"int16Value": @(i),
        @"int32Value": @(i),
        @"int64Value": @(i),
        @"floatValue": @(i),
        @"doubleValue": @(i),
        @"string": string,
        @"date": date,
        @"data": data,
        @"decimalValue": decimal
    };
}

- (NSArray<NSDictionary<NSString *, id> *> *)generateTestData:(NSInteger)count {
    NSMutableArray *representation = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        NSMutableDictionary *parent = [[self dummyDataWithValue:i] mutableCopy];
        
        NSMutableArray *children = [[NSMutableArray alloc] initWithCapacity:10];
        for (NSInteger j = 0; j < 10; j++) {
            [children addObject:[self dummyDataWithValue:j + i * 10]];
        }
        
        parent[@"children"] = children;
        
        [representation addObject:parent];
    }
    
    return representation;
}

- (void)testParentOnlyInsertPerformance {
    FEMMapping *mapping = [Parent defaultMapping];
    
    [self measureMetrics:[self.class defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithContext:self.context];
        [self startMeasuring];
        [deserializer collectionFromRepresentation:self.representation mapping:mapping];
        [self stopMeasuring];
        [Parent MR_truncateAllInContext:self.context];
    }];
}

- (void)testParentOnlyUpdatePerformance {
    FEMMapping *mapping = [Parent defaultMapping];
    FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithContext:self.context];
    [deserializer collectionFromRepresentation:self.representation mapping:mapping];
    
    [self measureMetrics:[self.class defaultPerformanceMetrics] automaticallyStartMeasuring:YES forBlock:^{
        [deserializer collectionFromRepresentation:self.representation mapping:mapping];
    }];
}

- (void)testAssignmentInsertWithPerformance {
    FEMMapping *mapping = [Parent childrenMappingWithPolicy:FEMAssignmentPolicyAssign];
    
    [self measureMetrics:[self.class defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithContext:self.context];
        [self startMeasuring];
        [deserializer collectionFromRepresentation:self.representation mapping:mapping];
        [self stopMeasuring];
        [Parent MR_truncateAllInContext:self.context];
    }];
}

- (void)testAssignmentUpdatePerformance {
    FEMMapping *mapping = [Parent childrenMappingWithPolicy:FEMAssignmentPolicyAssign];
    FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithContext:self.context];
    [deserializer collectionFromRepresentation:self.representation mapping:mapping];
    
    [self measureMetrics:[self.class defaultPerformanceMetrics] automaticallyStartMeasuring:YES forBlock:^{
        [deserializer collectionFromRepresentation:self.representation mapping:mapping];
    }];
}

@end
