// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Kiwi/Kiwi.h>
#import <CMFactory/CMFixture.h>
#import <FastEasyMapping/FastEasyMapping.h>
#import <FastEasyMappingRealm/FastEasyMappingRealm.h>
#import <Realm/Realm.h>
#import "UniqueRealmObject.h"

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
                mapping = [[FEMMapping alloc] initWithEntityName:[UniqueRealmObject className]];
            });

            it(@"should create RLMObject specified in FEMMapping.entityName", ^{
                [store beginTransaction];

                UniqueRealmObject *object = [store newObjectForMapping:mapping];
                [[object should] beKindOfClass:[UniqueRealmObject class]];
                [[[object.class className] should] equal:mapping.entityName];

                [store commitTransaction];
            });

            it(@"should save new object after commit", ^{
                [store beginTransaction];
                UniqueRealmObject *object = [store newObjectForMapping:mapping];
                [store commitTransaction];

                [[@([UniqueRealmObject allObjectsInRealm:realm].count) should] equal:@(1)];
            });
        });


        context(@"delete object", ^{
           it(@"should delete object as a delegate of assingment context", ^{
               [store beginTransaction];

               FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:[UniqueRealmObject className]];
               UniqueRealmObject *object = [store newObjectForMapping:mapping];
               FEMRelationshipAssignmentContext *context = [store newAssignmentContext];
               [context deleteRelationshipObject:object];

               [store commitTransaction];

               [[@([UniqueRealmObject allObjectsInRealm:realm].count) should] equal:@(0)];
           });
        });

        context(@"registration", ^{
            __block FEMMapping *mapping = nil;
            beforeEach(^{
                mapping = [UniqueRealmObject defaultMapping];

                [store prepareTransactionForMapping:mapping ofRepresentation:@[]];
                [store beginTransaction];
            });

            afterEach(^{
                [store commitTransaction];
            });

            it(@"can not register object without specified PK", ^{
                UniqueRealmObject *object = [store newObjectForMapping:mapping];
                mapping.primaryKey = nil;

                [[@([store canRegisterObject:object forMapping:mapping]) should] beFalse];
            });

            it(@"can register object with PK", ^{
                UniqueRealmObject *object = [store newObjectForMapping:mapping];
                [[@([store canRegisterObject:object forMapping:mapping]) should] beTrue];
            });

            it(@"should register object with PK", ^{
                UniqueRealmObject *object = [store newObjectForMapping:mapping];
                object.primaryKeyProperty = 5;

                [store registerObject:object forMapping:mapping];

                NSDictionary *json = @{@"primaryKeyProperty": @(5)};
                [[[store registeredObjectForRepresentation:json mapping:mapping] should] equal:object];

                NSDictionary *invalidJSON = @{@"primaryKeyProperty": @(6)};
                [[[store registeredObjectForRepresentation:invalidJSON mapping:mapping] should] beNil];
            });


        });

        context(@"registration prefetch", ^{
            __block FEMMapping *mapping = nil;
            beforeEach(^{
                mapping = [UniqueRealmObject defaultMapping];
            });

            it(@"should automatically register existing objects", ^{
                NSDictionary *json = @{@"primaryKeyProperty": @(5)};
                __block UniqueRealmObject *object = nil;
                [realm transactionWithBlock:^{
                    object = [[UniqueRealmObject alloc] init];
                    object.primaryKeyProperty = 5;
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
