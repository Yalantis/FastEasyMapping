// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Kiwi/Kiwi.h>
#import <CMFactory/CMFixture.h>
#import <OCMock/OCMock.h>
#import <FastEasyMapping/FastEasyMapping.h>
#import "UniqueObject.h"

SPEC_BEGIN(FEMDeserializerOptionsSpec)
describe(@"FEMDeserializer", ^{
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
                json = [CMFixture buildUsingFixture:@"UniqueObject"];
            });

            context(@"updatePrimaryKey is true", ^{
                it(@"should update PK value", ^{
                    mapping.updatePrimaryKey = YES;

                    id objectMock = OCMClassMock([UniqueObject class]);
                    OCMStub([objectMock valueForKey:@"integerPrimaryKey"]).andReturn(@3);
                    [deserializer fillObject:objectMock fromRepresentation:json mapping:mapping];

                    OCMVerify([objectMock setValue:@5 forKey:@"integerPrimaryKey"]);
                });

                it(@"should update 0 PK value", ^{
                    mapping.updatePrimaryKey = YES;

                    id objectMock = OCMClassMock([UniqueObject class]);
                    OCMStub([objectMock valueForKey:@"integerPrimaryKey"]).andReturn(@0);
                    [deserializer fillObject:objectMock fromRepresentation:json mapping:mapping];

                    OCMVerify([objectMock setValue:@5 forKey:@"integerPrimaryKey"]);
                });
            });

            context(@"updatePrimaryKey is false", ^{
                it(@"should not update PK value", ^{
                    mapping.updatePrimaryKey = NO;

                    id objectMock = OCMClassMock([UniqueObject class]);
                    OCMStub([objectMock valueForKey:@"integerPrimaryKey"]).andReturn(@5);
                    [[objectMock reject] setValue:@5 forKey:@"integerPrimaryKey"];

                    [deserializer fillObject:objectMock fromRepresentation:json mapping:mapping];
                });

                it(@"should update 0 PK value", ^{
                    mapping.updatePrimaryKey = NO;

                    id objectMock = OCMClassMock([UniqueObject class]);
                    OCMStub([objectMock valueForKey:@"integerPrimaryKey"]).andReturn(@0);
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
                json = [CMFixture buildUsingFixture:@"UniqueObject"];
            });

            context(@"updatePrimaryKey is true", ^{
                it(@"should update PK value", ^{
                    mapping.updatePrimaryKey = YES;

                    id objectMock = OCMClassMock([UniqueObject class]);
                    OCMStub([objectMock valueForKey:@"stringPrimaryKey"]).andReturn(@"PK!"); // should be different to trigger update
                    [deserializer fillObject:objectMock fromRepresentation:json mapping:mapping];

                    OCMVerify([objectMock setValue:@"PK" forKey:@"stringPrimaryKey"]);
                });

                it(@"should update nil PK value", ^{
                    mapping.updatePrimaryKey = YES;

                    id objectMock = OCMClassMock([UniqueObject class]);
                    OCMStub([objectMock valueForKey:@"stringPrimaryKey"]).andReturn(nil);
                    [deserializer fillObject:objectMock fromRepresentation:json mapping:mapping];

                    OCMVerify([objectMock setValue:@"PK" forKey:@"stringPrimaryKey"]);
                });
            });

            context(@"updatePrimaryKey is false", ^{
                it(@"should not update PK value", ^{
                    mapping.updatePrimaryKey = NO;

                    id objectMock = OCMClassMock([UniqueObject class]);
                    OCMStub([objectMock valueForKey:@"stringPrimaryKey"]).andReturn(@"PK!"); // should be different to trigger update
                    [[objectMock reject] setValue:@"PK" forKey:@"stringPrimaryKey"];

                    [deserializer fillObject:objectMock fromRepresentation:json mapping:mapping];
                });

                it(@"should update nil PK value", ^{
                    mapping.updatePrimaryKey = NO;

                    id objectMock = OCMClassMock([UniqueObject class]);
                    OCMStub([objectMock valueForKey:@"stringPrimaryKey"]).andReturn(nil);
                    [deserializer fillObject:objectMock fromRepresentation:json mapping:mapping];

                    OCMVerify([objectMock setValue:@"PK" forKey:@"stringPrimaryKey"]);
                });
            });
        });
    });
});

SPEC_END
