// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Kiwi/Kiwi.h>
#import <CMFactory/CMFixture.h>
#import <FastEasyMapping/FastEasyMapping.h>
#import <FastEasyMappingRealm/FastEasyMappingRealm.h>
#import <Realm/Realm.h>
#import "RealmObject.h"
#import "KWBeKindOfClassMatcher.h"

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
            realm = nil;
            store = nil;
        });

        context(@"transaction", ^{
            it(@"should perform write transaction", ^{
                [[@(realm.inWriteTransaction) should] beFalse];
                [store beginTransactionForMapping:nil ofRepresentation:nil];
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
                [store beginTransactionForMapping:nil ofRepresentation:nil];

                RealmObject *object = [store newObjectForMapping:mapping];
                [[object should] beKindOfClass:[RealmObject class]];
                [[[object.class className] should] equal:mapping.entityName];

                [store commitTransaction];
            });

            it(@"should not save new object without registration", ^{
                [store beginTransactionForMapping:nil ofRepresentation:nil];
                [store newObjectForMapping:mapping];
                [store commitTransaction];

                [[@([RealmObject allObjectsInRealm:realm].count) should] equal:@(0)];
            });

            it(@"should save new object after registration", ^{
                [store beginTransactionForMapping:nil ofRepresentation:nil];
                RealmObject *object = [store newObjectForMapping:mapping];
                [store registerObject:object forMapping:mapping];
                [store commitTransaction];

                [[@([RealmObject allObjectsInRealm:realm].count) should] equal:@(1)];
            });
        });


        context(@"delete object", ^{
           it(@"should delete object as a delegate of assingment context", ^{
               [store beginTransactionForMapping:nil ofRepresentation:nil];

               FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:[RealmObject className]];
               RealmObject *object = [store newObjectForMapping:mapping];
               FEMRelationshipAssignmentContext *context = [store newAssignmentContext];
               [context deleteRelationshipObject:object];

               [store commitTransaction];

               [[@([RealmObject allObjectsInRealm:realm].count) should] equal:@(0)];
           });
        });
    });
});

SPEC_END
