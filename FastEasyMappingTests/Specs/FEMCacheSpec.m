//
// Created by zen on 15/06/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

#import "Person.h"
#import "FEMManagedObjectMapping.h"
#import "FEMCache.h"
#import "MappingProvider.h"
#import "Car.h"
#import "FEMManagedObjectDeserializer.h"


SPEC_BEGIN(FEMCacheSpec)
    __block NSManagedObjectContext *context = nil;
    __block NSDictionary *simpleRepresentation = nil;
    __block FEMManagedObjectMapping *simpleMapping = nil;

    beforeEach(^{
        [MagicalRecord setDefaultModelFromClass:[self class]];
        [MagicalRecord setupCoreDataStackWithInMemoryStore];

        context = [NSManagedObjectContext MR_rootSavingContext];
        simpleRepresentation = @{
            @"id": @1,
            @"model": @"i30",
            @"year": @"2013"
        };
        simpleMapping = [MappingProvider carMappingWithPrimaryKey];
    });

    afterEach(^{
        simpleMapping = nil;
        simpleRepresentation = nil;
        context = nil;
        [MagicalRecord cleanUp];
    });

    describe(@"init", ^{
        it(@"should store NSManagedObjectContext", ^{
            FEMCache *cache = [[FEMCache alloc] initWithMapping:simpleMapping
                                         externalRepresentation:simpleRepresentation
                                                        context:context];

            [[cache.context should] equal:context];
        });
    });

    describe(@"object retrieval", ^{
        __block FEMCache *cache = nil;
        beforeEach(^{
            cache = [[FEMCache alloc] initWithMapping:simpleMapping
                               externalRepresentation:simpleRepresentation
                                              context:context];
        });
        afterEach(^{
            cache = nil;
        });

        it(@"should return nil for missing object", ^{
            [[@([Car MR_countOfEntitiesWithContext:context]) should] beZero];
            [[[cache existingObjectForRepresentation:simpleRepresentation mapping:simpleMapping] should] beNil];
        });

        it(@"should add objects", ^{
            [[@([Car MR_countOfEntitiesWithContext:context]) should] beZero];

            Car *car = [FEMManagedObjectDeserializer deserializeObjectExternalRepresentation:simpleRepresentation
                                                                                usingMapping:simpleMapping
                                                                                     context:context];
            [[[cache existingObjectForRepresentation:simpleRepresentation mapping:simpleMapping] should] beNil];
            [cache addExistingObject:car usingMapping:simpleMapping];
            [[[cache existingObjectForRepresentation:simpleRepresentation mapping:simpleMapping] should] equal:car];
        });

        it(@"should return registered object", ^{
            [[@([Car MR_countOfEntitiesWithContext:context]) should] beZero];

            Car *car = [FEMManagedObjectDeserializer deserializeObjectExternalRepresentation:simpleRepresentation
                                                                                usingMapping:simpleMapping
                                                                                     context:context];

            [[@(car.objectID.isTemporaryID) should] beTrue];
            [[[context objectRegisteredForID:car.objectID] should] equal:car];

            [[[cache existingObjectForRepresentation:simpleRepresentation mapping:simpleMapping] should] equal:car];
        });

        it(@"should return saved object", ^{
            [[@([Car MR_countOfEntitiesWithContext:context]) should] beZero];

            Car *car = [FEMManagedObjectDeserializer deserializeObjectExternalRepresentation:simpleRepresentation
                                                                                usingMapping:simpleMapping
                                                                                     context:context];
            [[@(car.objectID.isTemporaryID) should] beTrue];
            [context MR_saveToPersistentStoreAndWait];
            [[@([Car MR_countOfEntitiesWithContext:context]) should] equal:@1];

            [context reset];

            [[[context objectRegisteredForID:car.objectID] should] beNil];

            car = [Car MR_findFirstInContext:context];
            [[[cache existingObjectForRepresentation:simpleRepresentation mapping:simpleMapping] should] equal:car];
        });
    });

SPEC_END
