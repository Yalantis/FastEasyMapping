// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Kiwi/Kiwi.h>
#import <MagicalRecord/MagicalRecord.h>

#import "Fixture.h"

#import "Person.h"
#import "FEMMapping.h"
#import "FEMObjectCache.h"
#import "MappingProvider.h"
#import "Car.h"

#import "FEMDeserializer.h"
#import "FEMRelationship.h"
#import "FEMRepresentationUtility.h"

SPEC_BEGIN(FEMCacheSpec)
    __block NSManagedObjectContext *context = nil;


    beforeEach(^{
        [MagicalRecord setDefaultModelFromClass:[self class]];
        [MagicalRecord setupCoreDataStackWithInMemoryStore];

        context = [NSManagedObjectContext MR_rootSavingContext];
    });

    afterEach(^{
        context = nil;
        [MagicalRecord cleanUp];
    });

    describe(@"object retrieval", ^{
        __block id primaryKey = @1;
        __block NSDictionary *representation = nil;
        __block FEMMapping *mapping = nil;
        __block FEMObjectCache *cache = nil;
        beforeEach(^{
            representation = @{
                @"id": @1,
                @"model": @"i30",
                @"year": @"2013"
            };
            mapping = [MappingProvider carMappingWithPrimaryKey];

            cache = [[FEMObjectCache alloc] initWithContext:context
                                       presentedPrimaryKeys:FEMRepresentationCollectPresentedPrimaryKeys(representation, mapping)];
        });
        afterEach(^{
            mapping = nil;
            representation = nil;
            cache = nil;
        });

        it(@"should return nil for missing object", ^{
            [[@([Car MR_countOfEntitiesWithContext:context]) should] beZero];
            [[[cache objectForKey:primaryKey mapping:mapping] should] beNil];
        });

        it(@"should add objects", ^{
            [[@([Car MR_countOfEntitiesWithContext:context]) should] beZero];
            [[[cache objectForKey:primaryKey mapping:mapping] should] beNil];

            Car *car = [FEMDeserializer objectFromRepresentation:representation mapping:mapping context:context];

            [cache setObject:car forKey:primaryKey mapping:mapping];
            [[[cache objectForKey:primaryKey mapping:mapping] should] equal:car];
        });

        it(@"should return registered object", ^{
            [[@([Car MR_countOfEntitiesWithContext:context]) should] beZero];

            Car *car = [FEMDeserializer objectFromRepresentation:representation mapping:mapping context:context];

            [[@(car.objectID.isTemporaryID) should] beTrue];
            [[[context objectRegisteredForID:car.objectID] should] equal:car];

            [[[cache objectForKey:primaryKey mapping:mapping] should] equal:car];
        });

        it(@"should return saved object", ^{
            [[@([Car MR_countOfEntitiesWithContext:context]) should] beZero];

            Car *car = [FEMDeserializer objectFromRepresentation:representation mapping:mapping context:context];

            [[@(car.objectID.isTemporaryID) should] beTrue];
            [context MR_saveToPersistentStoreAndWait];
            [[@([Car MR_countOfEntitiesWithContext:context]) should] equal:@1];

            [context reset];

            [[[context objectRegisteredForID:car.objectID] should] beNil];

            car = [Car MR_findFirstInContext:context];
            [[[cache objectForKey:primaryKey mapping:mapping] should] equal:car];
        });
    });

    describe(@"nested object retrieval", ^{
        __block FEMObjectCache *cache = nil;
        __block NSDictionary *representation = nil;
        __block FEMMapping *mapping = nil;
        __block FEMMapping *carMapping = nil;

        beforeEach(^{
            representation = [Fixture buildUsingFixture:@"PersonWithCar_1"];
            mapping = [MappingProvider personWithCarMapping];

            cache = [[FEMObjectCache alloc] initWithContext:context
                                       presentedPrimaryKeys:FEMRepresentationCollectPresentedPrimaryKeys(representation, mapping)];
            carMapping = (id) [mapping relationshipForProperty:@"car"].mapping;
        });

        afterEach(^{
            cache = nil;
            representation = nil;
            mapping = nil;
            carMapping = nil;
        });

        it(@"should return nil for missing nested object", ^{
            [FEMDeserializer objectFromRepresentation:representation mapping:mapping context:context];
            id missingKey = @2;

            [[[cache objectForKey:missingKey mapping:carMapping] should] beNil];
        });

        it(@"should return existing nested object", ^{
            Person *person = [FEMDeserializer objectFromRepresentation:representation mapping:mapping context:context];
            [[[cache objectForKey:[person.car valueForKey:carMapping.primaryKey] mapping:carMapping] should] equal:person.car];
        });
    });

    describe(@"indirect relationship", ^{
        __block FEMMapping *mappingA;
        __block FEMMapping *mappingB;
        __block FEMObjectCache *cache;
        
        beforeEach(^{
            mappingA = [[FEMMapping alloc] initWithObjectClass:[NSObject class]];
            mappingA.primaryKey = @"a";
            
            mappingB = [[FEMMapping alloc] initWithObjectClass:[NSObject class]];
            mappingB.primaryKey = @"b";
            
            cache = [[FEMObjectCache alloc] init];
        });
        
        it(@"should combine objects from similar mappings", ^{
            NSObject *a = [NSObject new];
            NSObject *b = [NSObject new];
            
            [cache setObject:a forKey:@1 mapping:mappingA];
            [cache setObject:b forKey:@2 mapping:mappingB];
            
            [[[cache objectForKey:@1 mapping:mappingA] should] equal:a];
            [[[cache objectForKey:@1 mapping:mappingB] should] equal:a];
            
            [[[cache objectForKey:@2 mapping:mappingA] should] equal:b];
            [[[cache objectForKey:@2 mapping:mappingB] should] equal:b];
        });
    });

SPEC_END
