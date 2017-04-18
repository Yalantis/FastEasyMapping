// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Kiwi/Kiwi.h>
#import <CMFactory/CMFactory.h>
#import <OCMock/OCMock.h>
#import <FastEasyMapping/FastEasyMapping.h>
#import <MagicalRecord/MagicalRecord.h>

#import "Fixture.h"

#import "MappingProvider.h"
#import "Person.h"
#import "Car.h"
#import "Phone.h"
#import "UniqueObject.h"
#import "MappingProviderNative.h"
#import "PersonNative.h"
#import "CarNative.h"
#import "PhoneNative.h"
#import "AddressNative.h"
#import "Native.h"
#import "PlaneNative.h"
#import "SeaplaneNative.h"
#import "AlienNative.h"
#import "FingerNative.h"
#import "CatNative.h"
#import "RecursiveRelationship+Mapping.h"

SPEC_BEGIN(FEMDeserializerOptionsSpec)
describe(@"FEMDeserializer", ^{
    context(@"NSManagedObject", ^{
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
                    externalRepresentation = [Fixture buildUsingFixture:@"Car"];
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
                    externalRepresentation = [Fixture buildUsingFixture:@"CarWithRoot"];
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
                    externalRepresentation = [Fixture buildUsingFixture:@"CarWithNestedAttributes"];
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
                    externalRepresentation = [Fixture buildUsingFixture:@"CarWithDate"];
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
                    externalRepresentation = [Fixture buildUsingFixture:@"PersonWithNullRelationships"];
                    person = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                               mapping:[MappingProvider personWithCarPKMapping]
                                                               context:moc];
                });
                
                specify(^{
                    [[person.car should] beNil];
                });
            });

            context(@"with hasOne mapping", ^{
                __block Person *person;
                __block Car *expectedCar;

                beforeEach(^{
                    expectedCar = [Car MR_createEntity];
                    expectedCar.model = @"i30";
                    expectedCar.year = @"2013";

                    NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"Person"];
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
                    
                    NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"ManagedPersonWithRecursiveRelationship"];
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
                    NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"Person"];
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
                    NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"ManagedPersonWithRecursiveRelationship"];
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
                    Person *friend = [[person.friends objectsPassingTest:^BOOL(Person *obj, BOOL *stop) {
                        return [obj.personID isEqual:@(22)];
                    }] anyObject];
                    
                    [[@(friend.friends.count) should] equal:@1];
                    [[friend.friends.allObjects.firstObject should] beKindOfClass:[Person class]];
                    Person *friendsFriend = friend.friends.allObjects.firstObject;
                    [[friendsFriend.name should] equal:@"Pedro"];
                    [[friendsFriend.email should] equal:@"pedro@gmail.com"];
                });
            });
            
            context(@"recursive cyclic relationship", ^{
                __block RecursiveRelationship *object;
                __block RecursiveRelationship *child;
                beforeEach(^{
                    NSDictionary *fixture = [Fixture buildUsingFixture:@"RecursiveCyclicRelationship"];
                    FEMMapping *mapping = [RecursiveRelationship defaultMapping];
                    object = [FEMDeserializer objectFromRepresentation:fixture mapping:mapping context:moc];
                    child = object.child;
                });
                
                it(@"should map cyclic relationship", ^{
                    [[object.primaryKey should] equal:@1];
                    [[child.primaryKey should] equal:@2];
                    
                    [[child.child should] equal:object];
                });
            });
        });

        describe(@".deserializeCollectionExternalRepresentation:usingmapping:", ^{
            __block NSArray *carsArray;
            __block NSArray *externalRepresentation;

            beforeEach(^{
                externalRepresentation = [Fixture buildUsingFixture:@"Cars"];
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
                NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"PersonWithMissingRelationships"];
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
                    externalRepresentation_v1 = [Fixture buildUsingFixture:@"PersonWithCar_1"];
                    externalRepresentation_v2 = [Fixture buildUsingFixture:@"PersonWithCar_2"];
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
                    externalRepresentation_v1 = [Fixture buildUsingFixture:@"Person_1"];
                    externalRepresentation_v2 = [Fixture buildUsingFixture:@"Person_2"];
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
    });

    context(@"NSObject", ^{
        describe(@".objectFromExternalRepresentation:withMapping:", ^{

            context(@"a simple object", ^{

                __block CarNative *car;
                __block NSDictionary *externalRepresentation;

                beforeEach(^{
                    externalRepresentation = [Fixture buildUsingFixture:@"Car"];
                    car = [FEMDeserializer objectFromRepresentation:externalRepresentation mapping:[MappingProviderNative carMapping]];
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

            context(@"with root key", ^{

                __block CarNative *car;
                __block NSDictionary *externalRepresentation;

                beforeEach(^{
                    externalRepresentation = [Fixture buildUsingFixture:@"CarWithRoot"];
                    car = [FEMDeserializer objectFromRepresentation:externalRepresentation mapping:[MappingProviderNative carWithRootKeyMapping]];
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

                __block CarNative *car;
                __block NSDictionary *externalRepresentation;

                beforeEach(^{
                    externalRepresentation = [Fixture buildUsingFixture:@"CarWithNestedAttributes"];
                    car = [FEMDeserializer objectFromRepresentation:externalRepresentation mapping:[MappingProviderNative carNestedAttributesMapping]];
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

                __block CarNative *car;
                __block NSDictionary *externalRepresentation;

                beforeEach(^{
                    externalRepresentation = [Fixture buildUsingFixture:@"CarWithDate"];
                    car = [FEMDeserializer objectFromRepresentation:externalRepresentation mapping:[MappingProviderNative carWithDateMapping]];
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

                it(@"should populate createdAt field with a NSDate", ^{

                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    format.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                    format.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                    format.dateFormat = @"yyyy-MM-dd";
                    NSDate *expectedDate = [format dateFromString:[externalRepresentation objectForKey:@"created_at"]];
                    [[car.createdAt should] equal:expectedDate];

                });

            });

            context(@"with valueBlock", ^{

                context(@"when male", ^{

                    __block PersonNative *person;
                    __block NSDictionary *externalRepresentation;

                    beforeEach(^{
                        externalRepresentation = [Fixture buildUsingFixture:@"Male"];
                        person = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                                   mapping:[MappingProviderNative personWithOnlyValueBlockMapping]];
                    });

                    specify(^{
                        [[theValue(person.gender) should] equal:theValue(GenderMale)];
                    });

                });

                context(@"when female", ^{

                    __block PersonNative *person;
                    __block NSDictionary *externalRepresentation;

                    beforeEach(^{
                        externalRepresentation = [Fixture buildUsingFixture:@"Female"];
                        person = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                                   mapping:[MappingProviderNative personWithOnlyValueBlockMapping]];
                    });

                    specify(^{
                        [[theValue(person.gender) should] equal:theValue(GenderFemale)];
                    });

                });

                context(@"with custom object returned", ^{

                    __block AddressNative *address;
                    __block NSDictionary *externalRepresentation;

                    beforeEach(^{
                        externalRepresentation = [Fixture buildUsingFixture:@"Address"];
                        address = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                                    mapping:[MappingProviderNative addressMapping]];
                    });

                    specify(^{
                        [address shouldNotBeNil];
                    });

                    specify(^{
                        [address.location shouldNotBeNil];
                    });

                });

            });

            context(@"with hasOne mapping", ^{

                __block PersonNative *person;
                __block CarNative *expectedCar;

                beforeEach(^{

                    CMFactory *carFactory = [CMFactory forClass:[CarNative class]];
                    [carFactory addToField:@"model" value:^{
                        return @"i30";
                    }];
                    [carFactory addToField:@"year" value:^{
                        return @"2013";
                    }];
                    expectedCar = [carFactory build];

                    NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"Person"];
                    person = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                               mapping:[MappingProviderNative personMapping]];
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

            context(@"with hasOne mapping with different names", ^{
                __block CarNative * expectedCar;
                __block PersonNative * person;
                beforeEach(^{
                    expectedCar = [[CarNative alloc] init];
                    expectedCar.model = @"i30";
                    expectedCar.year = @"2013";
                    FEMObjectMapping *mapping = [[FEMObjectMapping alloc] initWithObjectClass:[PersonNative class]];
                    [mapping addRelationshipMapping:[MappingProviderNative carMapping] forProperty:@"car" keyPath:@"vehicle"];

                    NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"PersonWithDifferentNaming"];
                    person = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                               mapping:mapping];
                });

                specify(^{
                    [person.car shouldNotBeNil];
                });

                specify(^{
                    [[person.car should] beMemberOfClass:[CarNative class]];
                });

                specify(^{
                    [[person.car.model should] equal:@"i30"];
                });

                specify(^{
                    [[person.car.year should] equal:@"2013"];
                });

            });

            context(@"with hasMany mapping", ^{

                __block PersonNative *person;

                beforeEach(^{
                    NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"Person"];
                    person = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                               mapping:[MappingProviderNative personMapping]];
                });

                specify(^{
                    [person.phones shouldNotBeNil];
                });

                specify(^{
                    [[person.phones should] haveCountOf:2];
                });

            });

            context(@"with hasMany mapping with different names", ^{

                __block PersonNative * person;

                beforeEach(^{
                    FEMObjectMapping * mapping = [[FEMObjectMapping alloc] initWithObjectClass:[PersonNative class]];
                    [mapping addToManyRelationshipMapping:[MappingProviderNative phoneMapping]
                                              forProperty:@"phones"
                                                  keyPath:@"cellphones"];
                    NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"PersonWithDifferentNaming"];
                    person = [FEMDeserializer objectFromRepresentation:externalRepresentation mapping:mapping];
                });

                specify(^{
                    [person.phones shouldNotBeNil];
                });

                specify(^{
                    [[person.phones should] haveCountOf:2];
                });

                specify(^{
                    [[person.phones.lastObject should] beMemberOfClass:[PhoneNative class]];
                });

                specify(^{
                    PhoneNative * lastPhone = person.phones.lastObject;

                    [[lastPhone.number should] equal:@"2222-222"];
                });
            });

            context(@"with native properties", ^{

                __block Native *native;

                beforeEach(^{
                    FEMObjectMapping * mapping = [MappingProviderNative nativeMapping];
                    NSDictionary * externalRepresentation = [Fixture buildUsingFixture:@"Native"];
                    native = [FEMDeserializer objectFromRepresentation:externalRepresentation mapping:mapping];
                });

                specify(^{
                    char expected = 'c';
                    [[@(native.charProperty) should] equal:@(expected)];
                });

                specify(^{
                    unsigned char expected = 'u';
                    [[@(native.unsignedCharProperty) should] equal:@(expected)];
                });

                specify(^{
                    short expexted = 1;
                    [[@(native.shortProperty) should] equal:@(expexted)];
                });

                specify(^{
                    unsigned short expected = 2;
                    [[@(native.unsignedShortProperty) should] equal:@(expected)];
                });

                specify(^{
                    int expected = 3;
                    [[@(native.intProperty) should] equal:@(expected)];
                });

                specify(^{
                    unsigned int expected = 4;
                    [[@(native.unsignedIntProperty) should] equal:@(expected)];
                });

                specify(^{
                    NSInteger expected = 5;
                    [[@(native.integerProperty) should] equal:@(expected)];
                });

                specify(^{
                    NSUInteger expected = 6;
                    [[@(native.unsignedIntegerProperty) should] equal:@(expected)];
                });

                specify(^{
                    long expected = 7;
                    [[@(native.longProperty) should] equal:@(expected)];
                });

                specify(^{
                    unsigned long expected = 8;
                    [[@(native.unsignedLongProperty) should] equal:@(expected)];
                });

                specify(^{
                    long long expected = 9;
                    [[@(native.longLongProperty) should] equal:@(expected)];
                });

                specify(^{
                    unsigned long long expected = 10;
                    [[@(native.unsignedLongLongProperty) should] equal:@(expected)];
                });

                specify(^{
                    float expected = 11.1f;
                    [[@(native.floatProperty) should] equal:expected withDelta:0.001];
                });

                specify(^{
                    CGFloat expected = 12.2f;
                    [[@(native.cgFloatProperty) should] equal:expected withDelta:0.001];
                });

                specify(^{
                    double expected = 13.3;
                    [[@(native.doubleProperty) should] equal:expected withDelta:0.001];
                });

                specify(^{
                    [[@(native.boolProperty) should] beYes];
                });

                context(@"with a native propertie that is null", ^{

                    __block CatNative *cat;

                    beforeEach(^{
                        FEMObjectMapping *catMapping = [MappingProviderNative nativeMappingWithNullPropertie];
                        NSDictionary *values = @{ @"age": [NSNull null] };
                        cat = [FEMDeserializer objectFromRepresentation:values mapping:catMapping];
                    });

                    specify(^{
                        [[cat shouldNot] beNil];
                    });

                    specify(^{
                        [[theValue(cat.age) should] equal:theValue(0)];
                    });

                });

            });
        });

        describe(@".arrayOfObjectsFromExternalRepresentation:withMapping:", ^{
            __block NSArray *carsArray;
            __block NSArray *externalRepresentation;

            beforeEach(^{
                externalRepresentation = [Fixture buildUsingFixture:@"Cars"];
                carsArray = [FEMDeserializer collectionFromRepresentation:externalRepresentation mapping:[MappingProviderNative carMapping]];
            });

            specify(^{
                [carsArray shouldNotBeNil];
            });

            specify(^{
                [[carsArray should] haveCountOf:[externalRepresentation count]];
            });

        });

        context(@"with hasMany mapping with set", ^{
            __block PlaneNative * plane;

            beforeEach(^{
                NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"Plane"];
                FEMObjectMapping * mapping = [[FEMObjectMapping alloc] initWithObjectClass:[PlaneNative class]];
                [mapping addToManyRelationshipMapping:[MappingProviderNative personMapping] forProperty:@"persons" keyPath:@"persons"];
                [mapping addToManyRelationshipMapping:[MappingProviderNative personMapping] forProperty:@"pilots" keyPath:@"pilots"];
                [mapping addToManyRelationshipMapping:[MappingProviderNative personMapping] forProperty:@"stewardess" keyPath:@"stewardess"];
                [mapping addToManyRelationshipMapping:[MappingProviderNative personMapping] forProperty:@"stars" keyPath:@"stars"];

                plane = [FEMDeserializer objectFromRepresentation:externalRepresentation mapping:mapping];
            });

            specify(^{
                [plane.persons shouldNotBeNil];
            });

            specify(^{
                [[plane.persons should] beKindOfClass:[NSSet class]];
            });

            specify(^{
                [[plane.pilots should] beKindOfClass:[NSMutableSet class]];
            });

            specify(^{
                [[plane.stewardess should] beKindOfClass:[NSOrderedSet class]];
            });

            specify(^{
                [[plane.stars should] beKindOfClass:[NSMutableOrderedSet class]];
            });

        });
      
        
        context(@"with hasMany recursive mapping" , ^{
            __block PersonNative *person;
            
            beforeEach(^{
                NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"PersonWithRecursiveRelationship"];
                person = [FEMDeserializer objectFromRepresentation:externalRepresentation mapping:[MappingProviderNative personWithRecursiveFriendsMapping]];
            });
            
            it(@"should be a person", ^{
                [[person should] beKindOfClass:[PersonNative class]];
            });
            
            it(@"should have friends", ^{
                [[@(person.friends.count) should] equal:@2];
            });
            
            it(@"should have friends that have friends", ^{
                PersonNative *friend = person.friends.firstObject;
                [[@(friend.friends.count) should] equal:@1];
                [[friend.friends.firstObject should] beKindOfClass:[PersonNative class]];
                PersonNative *friendsFriend = (PersonNative *)friend.friends.firstObject;
                [[friendsFriend.name should] equal:@"Pedro"];
                [[friendsFriend.email should] equal:@"pedro@gmail.com"];
                [[friendsFriend.friends should] beNil];
            });
        });
        
        context(@"with hasOne recursive mapping" , ^{
            __block PersonNative *person;
            
            beforeEach(^{
                NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"PersonWithRecursiveRelationship"];
                person = [FEMDeserializer objectFromRepresentation:externalRepresentation mapping:[MappingProviderNative personWithRecursivePartnerMapping]];
            });
            
            it(@"should be a person", ^{
                [[person should] beKindOfClass:[PersonNative class]];
            });
            
            it(@"should have a parter", ^{
                [[person.partner should] beNonNil];
                [[person.partner.name should] equal:@"Ana"];
                [[person.partner.email should] equal:@"ana@gmail.com"];
            });
        });

        context(@"with hasMany mapping with set and different key name", ^{
            __block SeaplaneNative * seaplane;

            beforeEach(^{
                NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"Plane"];
                FEMObjectMapping * mapping = [[FEMObjectMapping alloc] initWithObjectClass:[SeaplaneNative class]];
                [mapping addToManyRelationshipMapping:[MappingProviderNative personMapping] forProperty:@"passengers" keyPath:@"persons"];

                seaplane = [FEMDeserializer objectFromRepresentation:externalRepresentation mapping:mapping];
            });

            specify(^{
                [seaplane.passengers shouldNotBeNil];
            });

            specify(^{
                [[seaplane.passengers should] beKindOfClass:[NSSet class]];
            });

        });

        context(@"with hasMany mapping with NSMutableArray", ^{

            __block AlienNative *alien;

            beforeEach(^{
                NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"Alien"];
                alien = [FEMDeserializer objectFromRepresentation:externalRepresentation mapping:[MappingProviderNative alienMapping]];
            });

            specify(^{
                [alien.fingers shouldNotBeNil];
            });

            specify(^{
                [[alien.fingers should] beKindOfClass:[NSMutableArray class]];
            });

        });
    });

    context(@"deserialization", ^{
        __block FEMDeserializer *deserializer = nil;

        beforeEach(^{
            deserializer = [[FEMDeserializer alloc] init];
        });

        afterEach(^{
            deserializer = nil;
        });

        context(@"scalar primary key", ^{
            __block FEMMapping *mapping = nil;
            __block NSDictionary *json = nil;
            beforeEach(^{
                mapping = [UniqueObject defaultMapping];
                mapping.primaryKey = @"integerPrimaryKey";
                json = [Fixture buildUsingFixture:@"UniqueObject"];
            });
            
            context(@"when zero", ^{
                it(@"should update PK value", ^{
                    id objectMock = OCMClassMock([UniqueObject class]);
                    OCMStub([objectMock valueForKey:@"integerPrimaryKey"]).andReturn(@0);
                    [deserializer fillObject:objectMock fromRepresentation:json mapping:mapping];
                    
                    OCMVerify([objectMock setValue:@5 forKey:@"integerPrimaryKey"]);
                });
            });
            
            context(@"when non-zero", ^{
                it(@"should update PK value", ^{
                    id objectMock = OCMClassMock([UniqueObject class]);
                    OCMStub([objectMock valueForKey:@"integerPrimaryKey"]).andReturn(@3);
                    [deserializer fillObject:objectMock fromRepresentation:json mapping:mapping];
                    
                    OCMVerify([objectMock setValue:@5 forKey:@"integerPrimaryKey"]);
                });
            });
        });

        context(@"object primary key", ^{
            __block FEMMapping *mapping = nil;
            __block NSDictionary *json = nil;
            beforeEach(^{
                mapping = [UniqueObject defaultMapping];
                mapping.primaryKey = @"stringPrimaryKey";
                json = [Fixture buildUsingFixture:@"UniqueObject"];
            });

            context(@"when nil", ^{
                it(@"should update PK value", ^{
                    id objectMock = OCMClassMock([UniqueObject class]);
                    OCMStub([objectMock valueForKey:@"stringPrimaryKey"]).andReturn(nil);
                    [deserializer fillObject:objectMock fromRepresentation:json mapping:mapping];
                    
                    OCMVerify([objectMock setValue:@"PK" forKey:@"stringPrimaryKey"]);
                });
            });
            
            context(@"when non-nil", ^{
                it(@"should update PK value", ^{
                    id objectMock = OCMClassMock([UniqueObject class]);
                    OCMStub([objectMock valueForKey:@"stringPrimaryKey"]).andReturn(@"PK!"); // should be different to trigger update
                    [deserializer fillObject:objectMock fromRepresentation:json mapping:mapping];
                    
                    OCMVerify([objectMock setValue:@"PK" forKey:@"stringPrimaryKey"]);
                });
            });
        });
    });
});

SPEC_END
