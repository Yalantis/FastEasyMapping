// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Kiwi/Kiwi.h>
#import <CMFactory/CMFixture.h>
#import <FastEasyMapping/FastEasyMapping.h>
#import <FastEasyMappingRealm/FastEasyMappingRealm.h>
#import <Realm/Realm.h>
#import "RealmObject.h"

SPEC_BEGIN(FEMRealmStoreSpec)
describe(@"FEMRealmStore", ^{
    context(@"deserialization", ^{
        __block RLMRealm *realm = nil;
        __block FEMRealmStore *store = nil;

        beforeEach(^{
            RLMRealmConfiguration *configuration = [[RLMRealmConfiguration alloc] init];
            configuration.inMemoryIdentifier = @"tests";
            realm = [RLMRealm realmWithConfiguration:configuration error:nil];

            store = [[FEMRealmStore alloc] initWithRealm:realm];
        });

        afterEach(^{
            [realm transactionWithBlock:^{
                [realm deleteAllObjects];
            }];

            realm = nil;
            store = nil;
        });

        context(@"transaction", ^{
            it(@"should perform write transaction", ^{
                [[@(realm.inWriteTransaction) should] beFalse];
                [store beginTransaction];
                [[@(realm.inWriteTransaction) should] beTrue];
                [store commitTransaction];
                [[@(realm.inWriteTransaction) should] beFalse];
            });
        });

        context(@"new object", ^{
            __block FEMMapping *mapping = nil;
            beforeAll(^{
                mapping = [[FEMMapping alloc] initWithEntityName:[RealmObject className]];
            });

            it(@"should create RLMObject specified in FEMMapping.entityName", ^{
                [store beginTransaction];

                RealmObject *object = [store newObjectForMapping:mapping];
                [[object should] beKindOfClass:[RealmObject class]];
                [[[object.class className] should] equal:mapping.entityName];

                [store commitTransaction];
            });

            it(@"should save new object after commit", ^{
                [store beginTransaction];
                RealmObject *object = [store newObjectForMapping:mapping];
                [store commitTransaction];

                [[@([RealmObject allObjectsInRealm:realm].count) should] equal:@(1)];
            });
        });


        context(@"delete object", ^{
           it(@"should delete object as a delegate of assingment context", ^{
               [store beginTransaction];

               FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:[RealmObject className]];
               RealmObject *object = [store newObjectForMapping:mapping];
               FEMRelationshipAssignmentContext *context = [store newAssignmentContext];
               [context deleteRelationshipObject:object];

               [store commitTransaction];

               [[@([RealmObject allObjectsInRealm:realm].count) should] equal:@(0)];
           });
        });

        context(@"registration", ^{
            __block FEMMapping *mapping = nil;
            beforeEach(^{
                mapping = [[FEMMapping alloc] initWithEntityName:[RealmObject className]];
                [mapping addAttributesFromArray:@[@"integerProperty"]];

                [store prepareTransactionForMapping:mapping ofRepresentation:@[]];
                [store beginTransaction];
            });

            afterEach(^{
                [store commitTransaction];
            });

            it(@"can not register object without specified PK", ^{
                RealmObject *object = [store newObjectForMapping:mapping];

                [[@([store canRegisterObject:object forMapping:mapping]) should] beFalse];
            });

            it(@"can register object with PK", ^{
                mapping.primaryKey = @"integerProperty";

                RealmObject *object = [store newObjectForMapping:mapping];
                [[@([store canRegisterObject:object forMapping:mapping]) should] beTrue];
            });

            it(@"should register object with PK", ^{
                mapping.primaryKey = @"integerProperty";
                RealmObject *object = [store newObjectForMapping:mapping];
                object.integerProperty = 5;

                [store registerObject:object forMapping:mapping];

                NSDictionary *json = @{@"integerProperty": @(5)};
                [[[store registeredObjectForRepresentation:json mapping:mapping] should] equal:object];

                NSDictionary *invalidJSON = @{@"integerProperty": @(6)};
                [[[store registeredObjectForRepresentation:invalidJSON mapping:mapping] should] beNil];
            });


        });

        context(@"registration prefetch", ^{
            __block FEMMapping *mapping = nil;
            beforeEach(^{
                mapping = [RealmObject primaryKeyMapping];
            });

            it(@"should automatically register existing objects", ^{
                NSDictionary *json = @{@"integerProperty": @(5)};
                __block RealmObject *object = nil;
                [realm transactionWithBlock:^{
                    object = [[RealmObject alloc] init];
                    object.integerProperty = 5;
                    [realm addObject:object];
                }];

                [store prepareTransactionForMapping:mapping ofRepresentation:@[json]];
                [store beginTransaction];

                [[[store registeredObjectForRepresentation:json mapping:mapping] should] equal:object];

                [store commitTransaction];
            });
        });
    });
});

SPEC_END
