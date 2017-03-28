// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Kiwi/Kiwi.h>
#import <CMFactory/CMFixture.h>
#import <FastEasyMapping/FastEasyMapping.h>
#import <FastEasyMappingRealm/FastEasyMappingRealm.h>
#import <Realm/Realm.h>
#import "RealmObject.h"
#import "UniqueRealmObject.h"
#import "UniqueToManyChildRealmObject.h"
#import "FEMRealmAssignmentPolicy.h"

SPEC_BEGIN(FEMAssignmentPolicySpec)
describe(@"FEMAssignmentPolicy", ^{
        __block RLMRealm *realm = nil;
        __block FEMRealmStore *store = nil;
        __block FEMDeserializer *deserializer = nil;

        beforeEach(^{
            RLMRealmConfiguration *configuration = [[RLMRealmConfiguration alloc] init];
            configuration.inMemoryIdentifier = @"assignment_policy_tests";
            realm = [RLMRealm realmWithConfiguration:configuration error:nil];

            store = [[FEMRealmStore alloc] initWithRealm:realm];
            deserializer = [[FEMDeserializer alloc] initWithStore:store];
        });

        afterEach(^{
            realm = nil;
            store = nil;
            deserializer = nil;
        });


    context(@"to-one relationship", ^{
        __block FEMMapping *mapping = nil;
        context(@"assign", ^{
            __block UniqueRealmObject *object = nil;
            beforeEach(^{
                mapping = [UniqueRealmObject toManyRelationshipMappingWithPolicy:FEMAssignmentPolicyAssign];
                NSDictionary *fixture0 = [CMFixture buildUsingFixture:@"AssingmentPolicyToManyInit"];
                object = [deserializer objectFromRepresentation:fixture0 mapping:mapping];
            });

            afterEach(^{
                [realm transactionWithBlock:^{
                    [realm deleteAllObjects];
                }];
            });
        });

        context(@"merge", ^{

        });

        context(@"replace", ^{

        });
    });

    context(@"to-many relationship", ^{
        __block FEMMapping *mapping = nil;
        context(@"assign", ^{
            __block UniqueRealmObject *object = nil;
            beforeEach(^{
                mapping = [UniqueRealmObject toManyRelationshipMappingWithPolicy:FEMAssignmentPolicyAssign];
                NSDictionary *fixture0 = [CMFixture buildUsingFixture:@"AssingmentPolicyToManyInit"];
                object = [deserializer objectFromRepresentation:fixture0 mapping:mapping];
            });

            afterEach(^{
               [realm transactionWithBlock:^{
                   [realm deleteAllObjects];
               }];
            });

            it(@"should assign value", ^{
                [[@(object.primaryKeyProperty) should] equal:@5];
                [[@(object.toManyRelationship.count) should] equal:@2];

                UniqueToManyChildRealmObject *child0 = object.toManyRelationship[0];
                [[@(child0.primaryKey) should] equal:@10];
                UniqueToManyChildRealmObject *child1 = object.toManyRelationship[1];
                [[@(child1.primaryKey) should] equal:@11];
            });

            it(@"should re-assign value", ^{
                NSDictionary *fixture1 = [CMFixture buildUsingFixture:@"AssingmentPolicyToManyUpdate"];
                [deserializer fillObject:object fromRepresentation:fixture1 mapping:mapping];

                [[@(object.primaryKeyProperty) should] equal:@5];
                [[@(object.toManyRelationship.count) should] equal:@2];

                UniqueToManyChildRealmObject *child0 = object.toManyRelationship[0];
                [[@(child0.primaryKey) should] equal:@11];
                UniqueToManyChildRealmObject *child1 = object.toManyRelationship[1];
                [[@(child1.primaryKey) should] equal:@12];

                [[@([UniqueToManyChildRealmObject allObjectsInRealm:realm].count) should] equal:@3];
                [[@([UniqueToManyChildRealmObject objectsInRealm:realm where:@"primaryKey == 10"].count) shouldNot] beZero];
            });

            it(@"should assign null", ^{
                NSDictionary *fixture2 = [CMFixture buildUsingFixture:@"AssingmentPolicyToManyNull"];
                [deserializer fillObject:object fromRepresentation:fixture2 mapping:mapping];

                [[@(object.primaryKeyProperty) should] equal:@5];
                [[@(object.toManyRelationship.count) should] equal:@0];

                [[@([UniqueToManyChildRealmObject allObjectsInRealm:realm].count) should] equal:@2];
                [[@([UniqueToManyChildRealmObject objectsInRealm:realm where:@"primaryKey == 10"].count) shouldNot] beZero];
                [[@([UniqueToManyChildRealmObject objectsInRealm:realm where:@"primaryKey == 11"].count) shouldNot] beZero];
            });
        });

        context(@"merge", ^{
            __block UniqueRealmObject *object = nil;
            beforeEach(^{
                mapping = [UniqueRealmObject toManyRelationshipMappingWithPolicy:FEMRealmAssignmentPolicyCollectionMerge];
                NSDictionary *fixture0 = [CMFixture buildUsingFixture:@"AssingmentPolicyToManyInit"];
                object = [deserializer objectFromRepresentation:fixture0 mapping:mapping];
            });

            afterEach(^{
                [realm transactionWithBlock:^{
                    [realm deleteAllObjects];
                }];
            });

            it(@"should assign value", ^{
                [[@(object.primaryKeyProperty) should] equal:@5];
                [[@(object.toManyRelationship.count) should] equal:@2];

                UniqueToManyChildRealmObject *child0 = object.toManyRelationship[0];
                [[@(child0.primaryKey) should] equal:@10];
                UniqueToManyChildRealmObject *child1 = object.toManyRelationship[1];
                [[@(child1.primaryKey) should] equal:@11];

                [[@([UniqueToManyChildRealmObject allObjectsInRealm:realm].count) should] equal:@2];
            });

            it(@"should merge values", ^{
                NSDictionary *fixture1 = [CMFixture buildUsingFixture:@"AssingmentPolicyToManyUpdate"];
                [deserializer fillObject:object fromRepresentation:fixture1 mapping:mapping];

                [[@(object.primaryKeyProperty) should] equal:@5];
                [[@(object.toManyRelationship.count) should] equal:@3];

                UniqueToManyChildRealmObject *child0 = object.toManyRelationship[0];
                [[@(child0.primaryKey) should] equal:@10];
                UniqueToManyChildRealmObject *child1 = object.toManyRelationship[1];
                [[@(child1.primaryKey) should] equal:@11];
                UniqueToManyChildRealmObject *child2 = object.toManyRelationship[2];
                [[@(child2.primaryKey) should] equal:@12];

                [[@([UniqueToManyChildRealmObject allObjectsInRealm:realm].count) should] equal:@3];
            });

            it(@"should ignore null value", ^{
                NSDictionary *fixture2 = [CMFixture buildUsingFixture:@"AssingmentPolicyToManyNull"];
                [deserializer fillObject:object fromRepresentation:fixture2 mapping:mapping];

                [[@(object.primaryKeyProperty) should] equal:@5];
                [[@(object.toManyRelationship.count) should] equal:@2];

                UniqueToManyChildRealmObject *child0 = object.toManyRelationship[0];
                [[@(child0.primaryKey) should] equal:@10];
                UniqueToManyChildRealmObject *child1 = object.toManyRelationship[1];
                [[@(child1.primaryKey) should] equal:@11];

                [[@([UniqueToManyChildRealmObject allObjectsInRealm:realm].count) should] equal:@2];
            });

            it(@"should ignore empty array", ^{
                NSDictionary *fixture3 = [CMFixture buildUsingFixture:@"AssingmentPolicyToManyEmptyArray"];
                [deserializer fillObject:object fromRepresentation:fixture3 mapping:mapping];

                [[@(object.primaryKeyProperty) should] equal:@5];
                [[@(object.toManyRelationship.count) should] equal:@2];

                UniqueToManyChildRealmObject *child0 = object.toManyRelationship[0];
                [[@(child0.primaryKey) should] equal:@10];
                UniqueToManyChildRealmObject *child1 = object.toManyRelationship[1];
                [[@(child1.primaryKey) should] equal:@11];

                [[@([UniqueToManyChildRealmObject allObjectsInRealm:realm].count) should] equal:@2];
            });
        });

        context(@"replace", ^{
            __block UniqueRealmObject *object = nil;
            beforeEach(^{
                mapping = [UniqueRealmObject toManyRelationshipMappingWithPolicy:FEMRealmAssignmentPolicyCollectionReplace];
                NSDictionary *fixture0 = [CMFixture buildUsingFixture:@"AssingmentPolicyToManyInit"];
                object = [deserializer objectFromRepresentation:fixture0 mapping:mapping];
            });

            afterEach(^{
                [realm transactionWithBlock:^{
                    [realm deleteAllObjects];
                }];
            });

            it(@"should assign value", ^{
                [[@(object.primaryKeyProperty) should] equal:@5];
                [[@(object.toManyRelationship.count) should] equal:@2];

                UniqueToManyChildRealmObject *child0 = object.toManyRelationship[0];
                [[@(child0.primaryKey) should] equal:@10];
                UniqueToManyChildRealmObject *child1 = object.toManyRelationship[1];
                [[@(child1.primaryKey) should] equal:@11];

                [[@([UniqueToManyChildRealmObject allObjectsInRealm:realm].count) should] equal:@2];
            });

            it(@"should replace values", ^{
                NSDictionary *fixture1 = [CMFixture buildUsingFixture:@"AssingmentPolicyToManyUpdate"];
                [deserializer fillObject:object fromRepresentation:fixture1 mapping:mapping];

                [[@(object.primaryKeyProperty) should] equal:@5];
                [[@(object.toManyRelationship.count) should] equal:@2];

                UniqueToManyChildRealmObject *child0 = object.toManyRelationship[0];
                [[@(child0.primaryKey) should] equal:@11];
                UniqueToManyChildRealmObject *child1 = object.toManyRelationship[1];
                [[@(child1.primaryKey) should] equal:@12];

                [[@([UniqueToManyChildRealmObject allObjectsInRealm:realm].count) should] equal:@2];
                [[@([UniqueToManyChildRealmObject objectsInRealm:realm where:@"primaryKey == 10"].count) should] beZero];
            });

            it(@"should replace by null value", ^{
                NSDictionary *fixture2 = [CMFixture buildUsingFixture:@"AssingmentPolicyToManyNull"];
                [deserializer fillObject:object fromRepresentation:fixture2 mapping:mapping];

                [[@(object.primaryKeyProperty) should] equal:@5];
                [[@(object.toManyRelationship.count) should] equal:@0];

                [[@([UniqueToManyChildRealmObject allObjectsInRealm:realm].count) should] equal:@0];
            });

            it(@"should replace by empty array", ^{
                NSDictionary *fixture3 = [CMFixture buildUsingFixture:@"AssingmentPolicyToManyEmptyArray"];
                [deserializer fillObject:object fromRepresentation:fixture3 mapping:mapping];

                [[@(object.primaryKeyProperty) should] equal:@5];
                [[@(object.toManyRelationship.count) should] equal:@0];

                [[@([UniqueToManyChildRealmObject allObjectsInRealm:realm].count) should] equal:@0];
            });
        });
    });



//    context(@"deserialization", ^{
//
//        context(@"attributes", ^{
//            __block RealmObject *realmObject = nil;
//
//            afterAll(^{
//                [realm transactionWithBlock:^{
//                    [realm deleteAllObjects];
//                }];
//                realmObject = nil;
//            });
//
//            context(@"nonnull values", ^{
//                __block FEMMapping *mapping = nil;
//
//                beforeAll(^{
//                    mapping = [RealmObject supportedTypesMapping];
//                    NSDictionary *json = [CMFixture buildUsingFixture:@"SupportedTypes"];
//                    realmObject = [deserializer objectFromRepresentation:json mapping:mapping];
//                });
//
//                afterAll(^{
//                    mapping = nil;
//                });
//
//                specify(^{
//                    BOOL expected = YES;
//                    [[@(realmObject.boolProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    bool expected = true;
//                    [[@(realmObject.booleanProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    int expected = 3;
//                    [[@(realmObject.intProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    NSInteger expected = 5;
//                    [[@(realmObject.integerProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    long expected = 7;
//                    [[@(realmObject.longProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    long long expected = 9;
//                    [[@(realmObject.longLongProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    float expected = 11.1f;
//                    [[@(realmObject.floatProperty) should] equal:expected withDelta:0.01f];
//                });
//
//                specify(^{
//                    double expected = 12.2;
//                    [[@(realmObject.doubleProperty) should] equal:expected withDelta:0.01f];
//                });
//
//                specify(^{
//                    CGFloat expected = 13.3;
//                    [[@(realmObject.cgFloatProperty) should] equal:expected withDelta:0.01f];
//                });
//
//                specify(^{
//                    NSString *expected = @"string";
//                    [[realmObject.stringProperty should] equal:expected];
//                });
//
//                specify(^{
//                    FEMAttribute *attribute = [mapping attributeForProperty:@"dateProperty"];
//                    NSDate *expected = [attribute mapValue:@"2005-08-09T18:31:42+03"];
//                    [[realmObject.dateProperty should] equal:expected];
//                });
//
//                specify(^{
//                    FEMAttribute *attribute = [mapping attributeForProperty:@"dataProperty"];
//                    NSData *expected = [attribute mapValue:@"utf8"];
//                    [[realmObject.dataProperty should] equal:expected];
//                });
//            });
//
//            context(@"null values", ^{
//                beforeEach(^{
//                    FEMMapping *mapping = [RealmObject supportedNullableTypesMapping];
//                    NSDictionary *json = [CMFixture buildUsingFixture:@"SupportedNullTypes"];
//                    realmObject = [deserializer objectFromRepresentation:json mapping:mapping];
//                });
//
//                specify(^{
//                    BOOL expected = NO;
//                    [[@(realmObject.boolProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    bool expected = false;
//                    [[@(realmObject.booleanProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    int expected = 0;
//                    [[@(realmObject.intProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    NSInteger expected = 0;
//                    [[@(realmObject.integerProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    long expected = 0;
//                    [[@(realmObject.longProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    long long expected = 0;
//                    [[@(realmObject.longLongProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    float expected = 0.f;
//                    [[@(realmObject.floatProperty) should] equal:expected withDelta:0.01f];
//                });
//
//                specify(^{
//                    double expected = 0.0;
//                    [[@(realmObject.doubleProperty) should] equal:expected withDelta:0.01f];
//                });
//
//                specify(^{
//                    CGFloat expected = 0.0;
//                    [[@(realmObject.cgFloatProperty) should] equal:expected withDelta:0.01f];
//                });
//            });
//
//            context(@"update by null values", ^{
//                beforeAll(^{
//                    FEMMapping *mapping = [RealmObject supportedTypesMapping];
//                    NSDictionary *json = [CMFixture buildUsingFixture:@"SupportedTypes"];
//                    realmObject = [deserializer objectFromRepresentation:json mapping:mapping];
//
//                    FEMMapping *nullMapping = [RealmObject supportedNullableTypesMapping];
//                    NSDictionary *nullJSON = [CMFixture buildUsingFixture:@"SupportedNullTypes"];
//                    [deserializer fillObject:realmObject fromRepresentation:nullJSON mapping:nullMapping];
//                });
//
//                specify(^{
//                    BOOL expected = YES;
//                    [[@(realmObject.boolProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    bool expected = true;
//                    [[@(realmObject.booleanProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    int expected = 3;
//                    [[@(realmObject.intProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    NSInteger expected = 5;
//                    [[@(realmObject.integerProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    long expected = 7;
//                    [[@(realmObject.longProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    long long expected = 9;
//                    [[@(realmObject.longLongProperty) should] equal:@(expected)];
//                });
//
//                specify(^{
//                    float expected = 11.1f;
//                    [[@(realmObject.floatProperty) should] equal:expected withDelta:0.01f];
//                });
//
//                specify(^{
//                    double expected = 12.2;
//                    [[@(realmObject.doubleProperty) should] equal:expected withDelta:0.01f];
//                });
//
//                specify(^{
//                    CGFloat expected = 13.3;
//                    [[@(realmObject.cgFloatProperty) should] equal:expected withDelta:0.01f];
//                });
//
//                // Not yet supported by Realm <= 0.95.0
////                specify(^{
////                    [[realmObject.stringProperty should] beNil];
////                });
////
////                specify(^{
////                    [[realmObject.dateProperty should] beNil];
////                });
////
////                specify(^{
////                    [[realmObject.dataProperty should] beNil];
////                });
//            });
//        });
//
//
//        context(@"to-one relationship", ^{
//            context(@"nonnull value", ^{
//                __block RealmObject *realmObject = nil;
//                __block ChildRealmObject *childRealmObject = nil;
//
//                beforeEach(^{
//                    FEMMapping *mapping = [RealmObject toOneRelationshipMapping];
//                    NSDictionary *json = [CMFixture buildUsingFixture:@"ToOneRelationship"];
//                    realmObject = [deserializer objectFromRepresentation:json mapping:mapping];
//                    childRealmObject = realmObject.toOneRelationship;
//                });
//
//                specify(^{
//                    [[realmObject.toOneRelationship shouldNot] beNil];
//                    [[@([realmObject.toOneRelationship isEqualToObject:childRealmObject]) should] beTrue];
//                });
//
//                specify(^{
//                    [[@(childRealmObject.identifier) should] equal:@(10)];
//                });
//            });
//
//            context(@"null value", ^{
//                __block RealmObject *realmObject = nil;
//                beforeEach(^{
//                    FEMMapping *mapping = [RealmObject toOneRelationshipMapping];
//                    NSDictionary *json = [CMFixture buildUsingFixture:@"ToOneNullRelationship"];
//                    realmObject = [deserializer objectFromRepresentation:json mapping:mapping];
//                });
//
//                specify(^{
//                    [[realmObject.toOneRelationship should] beNil];
//                });
//            });
//        });
//
//        context(@"to-many relationship", ^{
//            context(@"nonnull value", ^{
//                __block RealmObject *realmObject = nil;
//                __block RLMArray<ChildRealmObject> *relationship = nil;
//
//                beforeEach(^{
//                    FEMMapping *mapping = [RealmObject toManyRelationshipMapping];
//                    NSDictionary *json = [CMFixture buildUsingFixture:@"ToManyRelationship"];
//                    realmObject = [deserializer objectFromRepresentation:json mapping:mapping];
//                    relationship = realmObject.toManyRelationship;
//                });
//
//                specify(^{
//                    [[relationship shouldNot] beNil];
//                    [[@(relationship.count) should] equal:@(2)];
//                });
//
//                specify(^{
//                    ChildRealmObject *child0 = relationship[0];
//                    [[@(child0.identifier) should] equal:@(20)];
//
//                    ChildRealmObject *child1 = relationship[1];
//                    [[@(child1.identifier) should] equal:@(21)];
//                });
//            });
//
//            context(@"null value", ^{
//                __block RealmObject *realmObject = nil;
//                __block RLMArray<ChildRealmObject> *relationship = nil;
//
//                beforeEach(^{
//                    FEMMapping *mapping = [RealmObject toManyRelationshipMapping];
//                    NSDictionary *json = [CMFixture buildUsingFixture:@"ToManyNullRelationship"];
//                    realmObject = [deserializer objectFromRepresentation:json mapping:mapping];
//                    relationship = realmObject.toManyRelationship;
//                });
//
//                specify(^{
//                    [[@(relationship.count) should] equal:@(0)];
//                });
//            });
//        });
//    });
});

SPEC_END
