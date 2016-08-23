// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Kiwi/Kiwi.h>
#import <CMFactory/CMFixture.h>
#import <MagicalRecord/MagicalRecord.h>


#import "MappingProvider.h"
#import "Person.h"
#import "Car.h"

#import "FEMDeserializer.h"
#import "FEMRelationship.h"

#import "FEMMapping.h"
#import "Phone.h"
#import "FEMManagedObjectDeserializer.h"
#import "KWNilMatcher.h"

SPEC_BEGIN(FEMManagedObjectDeserializerSpec)

    describe(@"FEMDeserializer", ^{
        __block NSManagedObjectContext *moc;

        beforeEach(^{
            [MagicalRecord setDefaultModelFromClass:[self class]];
            [MagicalRecord setupCoreDataStackWithInMemoryStore];

            moc = [NSManagedObjectContext MR_defaultContext];
        });

        afterEach(^{
            moc = nil;

            [MagicalRecord cleanUp];
        });

        describe(@".objectFromExternalRepresentation:mapping:", ^{

            context(@"a simple object", ^{

                __block Car *car;
                __block NSDictionary *externalRepresentation;

                beforeEach(^{
                    externalRepresentation = [CMFixture buildUsingFixture:@"Car"];
                    car = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                            mapping:[MappingProvider carMapping]
                                                            context:moc];
                });

                specify(^{
                    [car shouldNotBeNil];
                });

                specify(^{
                    [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
                });

                specify(^{
                    [[car.year should] equal:[externalRepresentation objectForKey:@"year"]];
                });

            });

            context(@"with existing object", ^{
                __block Car *oldCar;
                __block Car *car;
                __block NSDictionary *externalRepresentation;

                beforeEach(^{
                    oldCar = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:moc];
                    oldCar.carID = @(1);
                    oldCar.year = @"1980";
                    oldCar.model = @"";
                    [moc MR_saveToPersistentStoreAndWait];

                    externalRepresentation = @{
                        @"id" : @(1),
                        @"model" : @"i30",
                        @"year" : @"2013"
                    };

                    car = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                            mapping:[MappingProvider carMappingWithPrimaryKey]
                                                            context:moc];
                });

                specify(^{
                    [car shouldNotBeNil];
                });

                specify(^{
                    [[car should] equal:oldCar];
                });

                specify(^{
                    [[car.carID should] equal:oldCar.carID];
                });

                specify(^{
                    [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
                });

                specify(^{
                    [[car.year should] equal:[externalRepresentation objectForKey:@"year"]];
                });

                specify(^{
                    [[[Car MR_findAll] should] haveCountOf:1];
                });
            });

            context(@"don't clear missing values", ^{
                __block Car *oldCar;
                __block Car *car;
                __block NSDictionary *externalRepresentation;

                beforeEach(^{
                    oldCar = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:moc];
                    oldCar.carID = @(1);
                    oldCar.year = @"1980";
                    oldCar.model = @"";

                    externalRepresentation = @{@"id" : @(1), @"model" : @"i30",};
                    car = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                            mapping:[MappingProvider carMappingWithPrimaryKey]
                                                            context:moc];
                });

                specify(^{
                    [[car.carID should] equal:oldCar.carID];
                });

                specify(^{
                    [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
                });

                specify(^{
                    [[car.year should] equal:oldCar.year];
                });

                specify(^{
                    [[[Car MR_findAll] should] haveCountOf:1];
                });

            });

            context(@"with root key", ^{
                __block Car *car;
                __block NSDictionary *externalRepresentation;

                beforeEach(^{
                    externalRepresentation = [CMFixture buildUsingFixture:@"CarWithRoot"];
                    car = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                            mapping:[MappingProvider carWithRootKeyMapping]
                                                            context:moc];
                    externalRepresentation = [externalRepresentation objectForKey:@"car"];
                });

                specify(^{
                    [car shouldNotBeNil];
                });

                specify(^{
                    [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
                });

                specify(^{
                    [[car.year should] equal:[externalRepresentation objectForKey:@"year"]];
                });

            });

            context(@"with nested information", ^{
                __block Car *car;
                __block NSDictionary *externalRepresentation;

                beforeEach(^{
                    externalRepresentation = [CMFixture buildUsingFixture:@"CarWithNestedAttributes"];
                    car = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                            mapping:[MappingProvider carNestedAttributesMapping]
                                                            context:moc];
                });

                specify(^{
                    [car shouldNotBeNil];
                });

                specify(^{
                    [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
                });

                specify(^{
                    [[car.year should] equal:[[externalRepresentation objectForKey:@"information"] objectForKey:@"year"]];
                });

            });

            context(@"with dateformat", ^{
                __block Car *car;
                __block NSDictionary *externalRepresentation;

                beforeEach(^{
                    moc = [NSManagedObjectContext MR_defaultContext];
                    externalRepresentation = [CMFixture buildUsingFixture:@"CarWithDate"];
                    car = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                            mapping:[MappingProvider carWithDateMapping]
                                                            context:moc];
                });

                specify(^{
                    [car shouldNotBeNil];
                });

                specify(^{
                    [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
                });

                specify(^{
                    [[car.year should] equal:[externalRepresentation objectForKey:@"year"]];
                });

                it(@"should populate createdAt property with a NSDate", ^{

                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    format.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                    format.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                    format.dateFormat = @"yyyy-MM-dd";
                    NSDate *expectedDate = [format dateFromString:[externalRepresentation objectForKey:@"created_at"]];
                    [[car.createdAt should] equal:expectedDate];

                });

            });

            context(@"with null relationship for PK mapping", ^{
                __block Person *person;
                __block NSDictionary *externalRepresentation;

                beforeEach(^{
                    externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithNullRelationships"];
                    person = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                               mapping:[MappingProvider personWithCarPKMapping]
                                                               context:moc];
                });

                specify(^{
                    [[person.car should] beNil];

//                    [[person.model should] equal:[externalRepresentation objectForKey:@"model"]];
                });

//                specify(^{
//                    [[person.year should] equal:[externalRepresentation objectForKey:@"year"]];
//                });
                
            });

            context(@"with hasOne mapping", ^{
                __block Person *person;
                __block Car *expectedCar;

                beforeEach(^{
                    expectedCar = [Car MR_createEntity];
                    expectedCar.model = @"i30";
                    expectedCar.year = @"2013";

                    NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                    person = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                               mapping:[MappingProvider personMapping]
                                                               context:moc];
                });

                specify(^{
                    [person.car shouldNotBeNil];
                });

                specify(^{
                    [[person.car.model should] equal:expectedCar.model];
                });

                specify(^{
                    [[person.car.year should] equal:expectedCar.year];
                });

            });
            
            context(@"with hasOne recursive mapping", ^{
                __block Person *person;
                __block Person *partner;
                
                beforeEach(^{
                    partner = [Person MR_createEntity];
                    partner.personID = @21;
                    partner.name = @"Ana";
                    partner.email = @"ana@gmail.com";
                    
                    NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"ManagedPersonWithRecursiveRelationship"];
                    person = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                               mapping:[MappingProvider personWithRecursiveMapping]
                                                               context:moc];
                });
                
                specify(^{
                    [person.partner shouldNotBeNil];
                });
                
                specify(^{
                    [[person.partner.personID should] equal:partner.personID];
                });
                
                specify(^{
                    [[person.partner.name should] equal:partner.name];
                });
                
            });

            context(@"with hasMany mapping", ^{
                __block Person *person;

                beforeEach(^{
                    moc = [NSManagedObjectContext MR_defaultContext];
                    NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                    person = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                               mapping:[MappingProvider personMapping]
                                                               context:moc];
                });

                specify(^{
                    [person.phones shouldNotBeNil];
                });

                specify(^{
                    [[person.phones should] haveCountOf:2];
                });

            });
            
            context(@"with hasMany recursive mapping", ^{
                __block Person *person;
                
                beforeEach(^{
                    
                    NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"ManagedPersonWithRecursiveRelationship"];
                    person = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                               mapping:[MappingProvider personWithRecursiveToManyMapping]
                                                               context:moc];
                });
                
                it(@"should be a person", ^{
                    [[person should] beKindOfClass:[Person class]];
                });
                
                it(@"should have friends", ^{
                    [[@(person.friends.count) should] equal:@2];
                });
                
                it(@"should have friends that have friends", ^{
                    Person *friend = person.friends.allObjects.firstObject;
                    [[@(friend.friends.count) should] equal:@1];
                    [[friend.friends.allObjects.firstObject should] beKindOfClass:[Person class]];
                    Person *friendsFriend = (Person *)friend.friends.allObjects.firstObject;
                    [[friendsFriend.name should] equal:@"Pedro"];
                    [[friendsFriend.email should] equal:@"pedro@gmail.com"];
                });
            });

        });

        describe(@".deserializeCollectionExternalRepresentation:usingmapping:", ^{
            __block NSArray *carsArray;
            __block NSArray *externalRepresentation;

            beforeEach(^{
                externalRepresentation = [CMFixture buildUsingFixture:@"Cars"];
                carsArray = [FEMDeserializer collectionFromRepresentation:externalRepresentation
                                                                  mapping:[MappingProvider carMapping]
                                                                  context:moc];
            });

            specify(^{
                [carsArray shouldNotBeNil];
            });

            specify(^{
                [[carsArray should] haveCountOf:[externalRepresentation count]];
            });

        });

        describe(@"null relationship", ^{
            __block Person *person = nil;

            beforeAll(^{
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithMissingRelationships"];
                FEMMapping *mapping = [MappingProvider personMapping];
                person = [FEMDeserializer objectFromRepresentation:externalRepresentation mapping:mapping context:moc];
            });

            context(@"to-one", ^{
                it(@"it should be nil", ^{
                    [[person.car should] beNil];
                });
            });

            context(@"to-many", ^{
                it(@"it should be empty", ^{
                    [[person.phones should] beNil];
                });
            });
        });

        describe(@"relationship assignment policy", ^{
            __block NSDictionary *externalRepresentation_v1 = nil;
            __block NSDictionary *externalRepresentation_v2 = nil;
            __block FEMMapping *mapping = nil;
            __block FEMRelationship *relationshipMapping = nil;

            context(@"to-one", ^{
                beforeEach(^{
                    externalRepresentation_v1 = [CMFixture buildUsingFixture:@"PersonWithCar_1"];
                    externalRepresentation_v2 = [CMFixture buildUsingFixture:@"PersonWithCar_2"];
                    mapping = [MappingProvider personWithCarMapping];
                    relationshipMapping = [mapping relationshipForProperty:@"car"];
                });

                afterEach(^{
                    externalRepresentation_v1 = nil;
                    externalRepresentation_v2 = nil;
                    mapping = nil;
                    relationshipMapping = nil;
                });

                context(@"assign", ^{
                    it(@"should assign new value", ^{
                        relationshipMapping.assignmentPolicy = FEMAssignmentPolicyAssign;

                        [[@([Car MR_countOfEntitiesWithContext:moc]) should] beZero];
                        Person *person_v1 = [FEMDeserializer objectFromRepresentation:externalRepresentation_v1
                                                                              mapping:mapping
                                                                              context:moc];
                        [moc MR_saveToPersistentStoreAndWait];

                        [[@([Car MR_countOfEntitiesWithContext:moc]) should] equal:@1];

                        Car *car_v1 = person_v1.car;
                        [[car_v1 should] equal:[Car MR_findFirstInContext:moc]];

                        Person *person_v2 = [FEMDeserializer objectFromRepresentation:externalRepresentation_v2
                                                                              mapping:mapping
                                                                              context:moc];

                        [[person_v1 should] equal:person_v2];
                        Car *car_v2 = person_v1.car;

                        [[car_v1 shouldNot] equal:car_v2];
                        [[car_v1.person should] beNil];
                    });
                });

                context(@"merge", ^{
                    it(@"should act as assign", ^{
                        relationshipMapping.assignmentPolicy = FEMAssignmentPolicyObjectMerge;

                        [[@([Car MR_countOfEntitiesWithContext:moc]) should] beZero];
                        Person *person_v1 = [FEMDeserializer objectFromRepresentation:externalRepresentation_v1
                                                                              mapping:mapping
                                                                              context:moc];
                        [moc MR_saveToPersistentStoreAndWait];

                        [[@([Car MR_countOfEntitiesWithContext:moc]) should] equal:@1];

                        Car *car_v1 = person_v1.car;
                        [[car_v1 should] equal:[Car MR_findFirstInContext:moc]];

                        Person *person_v2 = [FEMDeserializer objectFromRepresentation:externalRepresentation_v2
                                                                              mapping:mapping
                                                                              context:moc];
                        [moc MR_saveToPersistentStoreAndWait];

                        [[person_v1 should] equal:person_v2];
                        Car *car_v2 = person_v1.car;

                        [[car_v1 shouldNot] equal:car_v2];
                        [[car_v1.person should] beNil];
                    });
                });

                context(@"replace", ^{
                    it(@"should not replace equal object", ^{
                        relationshipMapping.assignmentPolicy = FEMAssignmentPolicyObjectReplace;

                        [[@([Car MR_countOfEntitiesWithContext:moc]) should] beZero];
                        Person *person_v1 = [FEMDeserializer objectFromRepresentation:externalRepresentation_v1
                                                                              mapping:mapping
                                                                              context:moc];
                        Car *car_v1 = person_v1.car;

                        [moc MR_saveToPersistentStoreAndWait];

                        [[@([Car MR_countOfEntitiesWithContext:moc]) should] equal:@1];

                        [FEMDeserializer fillObject:person_v1
                                 fromRepresentation:externalRepresentation_v1
                                            mapping:mapping];
                        [moc MR_saveToPersistentStoreAndWait];
                        [[@([Car MR_countOfEntitiesWithContext:moc]) should] equal:@1];

                        [[person_v1.car should] equal:car_v1];
                    });
                });
            });
            context(@"to-many", ^{
                beforeEach(^{
                    externalRepresentation_v1 = [CMFixture buildUsingFixture:@"Person_1"];
                    externalRepresentation_v2 = [CMFixture buildUsingFixture:@"Person_2"];
                    mapping = [MappingProvider personWithPhoneMapping];
                    relationshipMapping = [mapping relationshipForProperty:@"phones"];
                });

                afterEach(^{
                    externalRepresentation_v1 = nil;
                    externalRepresentation_v2 = nil;
                    mapping = nil;
                    relationshipMapping = nil;
                });

                context(@"merge", ^{
                    it(@"should merge existing and new objects", ^{
                        relationshipMapping.assignmentPolicy = FEMAssignmentPolicyCollectionMerge;

                        [[@([Phone MR_countOfEntitiesWithContext:moc]) should] beZero];
                        Person *person_v1 = [FEMDeserializer objectFromRepresentation:externalRepresentation_v1
                                                                              mapping:mapping
                                                                              context:moc];
                        [moc MR_saveToPersistentStoreAndWait];

                        [[@([Phone MR_countOfEntitiesWithContext:moc]) should] equal:@2];

                        NSSet *phones_1 = person_v1.phones;
                        [[@([phones_1 isEqualToSet:[NSSet setWithArray:[Phone MR_findAllInContext:moc]]]) should] beTrue];

                        [FEMDeserializer fillObject:person_v1
                                 fromRepresentation:externalRepresentation_v2
                                            mapping:mapping];
                        [moc MR_saveToPersistentStoreAndWait];

                        [[@([Phone MR_countOfEntitiesWithContext:moc]) should] equal:@3];

                        [[@([phones_1 isSubsetOfSet:person_v1.phones]) should] beTrue];
                    });
                });

                context(@"replace", ^{
                    it(@"should delete existing and assign new objects", ^{
                        relationshipMapping.assignmentPolicy = FEMAssignmentPolicyCollectionReplace;

                        [[@([Phone MR_countOfEntitiesWithContext:moc]) should] beZero];
                        Person *person_v1 = [FEMDeserializer objectFromRepresentation:externalRepresentation_v1
                                                                              mapping:mapping
                                                                              context:moc];
                        [moc MR_saveToPersistentStoreAndWait];

                        [[@([Phone MR_countOfEntitiesWithContext:moc]) should] equal:@2];

                        NSSet *phones_1 = person_v1.phones;
                        [[@([phones_1 isEqualToSet:[NSSet setWithArray:[Phone MR_findAllInContext:moc]]]) should] beTrue];

                        [FEMDeserializer fillObject:person_v1
                                 fromRepresentation:externalRepresentation_v2
                                            mapping:mapping];
                        [moc MR_saveToPersistentStoreAndWait];

                        [[@([Phone MR_countOfEntitiesWithContext:moc]) should] equal:@2];
                    });
                });
            });
        });





//    describe(@"synchronization", ^{
//        __block Car *car;
//        __block NSDictionary *externalRepresentation;
//        __block FEMMapping *mapping;
//
//        beforeEach(^{
//            externalRepresentation = @{
//                @"id": @2,
//                @"model": @"i30",
//                @"year": @"2014"
//            };
//
//            car = [Car MR_createInContext:moc];
//            [car setCarID:@1];
//
//            mapping = [MappingProvider carMappingWithPrimaryKey];
//        });

//        context(@"without predicate", ^{
//            it(@"should replace all existing objects", ^{
//                [[@([Car MR_countOfEntitiesWithContext:moc]) should] equal:@1];
//
//                [FEMDeserializer synchronizeCollectionExternalRepresentation:@[externalRepresentation]
//                                                                mapping:mapping
//                                                                   predicate:nil
//                                                                     context:moc];
//                [[@([Car MR_countOfEntitiesWithContext:moc]) should] equal:@1];
//                Car *existingCar = [Car MR_findFirstInContext:moc];
//                [[existingCar.carID should] equal:@2];
//            });
//        });
//
//        context(@"with predicate", ^{
//            it(@"should replace objects specified by predicate", ^{
//                [[@([Car MR_countOfEntitiesWithContext:moc]) should] equal:@1];
//
//                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"carID == 1"];
//                [FEMDeserializer synchronizeCollectionExternalRepresentation:@[externalRepresentation]
//                                                                mapping:mapping
//                                                                   predicate:predicate
//                                                                     context:moc];
//                [[@([Car MR_countOfEntitiesWithContext:moc]) should] equal:@1];
//                Car *existingCar = [Car MR_findFirstInContext:moc];
//                [[existingCar.carID should] equal:@2];
//            });
//
//            it(@"should not replace objects not specified by predicate", ^{
//                [[@([Car MR_countOfEntitiesWithContext:moc]) should] equal:@1];
//
//                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"carID != 1"];
//                [FEMDeserializer synchronizeCollectionExternalRepresentation:@[externalRepresentation]
//                                                                mapping:mapping
//                                                                   predicate:predicate
//                                                                     context:moc];
//                [[@([Car MR_countOfEntitiesWithContext:moc]) should] equal:@2];
//            });
//        });
//    });
    });

SPEC_END
