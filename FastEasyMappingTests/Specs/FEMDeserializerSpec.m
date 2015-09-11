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
                    OCMStub([objectMock integerPrimaryKey]).andReturn(@3);
                    [deserializer fillObject:objectMock fromRepresentation:json mapping:mapping];

                    OCMVerify([objectMock setValue:@5 forKey:@"integerPrimaryKey"]);
                });

                it(@"should update 0 PK value", ^{
                    mapping.updatePrimaryKey = YES;

                    id objectMock = OCMClassMock([UniqueObject class]);
                    OCMStub([objectMock integerPrimaryKey]).andReturn(@0);
                    [deserializer fillObject:objectMock fromRepresentation:json mapping:mapping];

                    OCMVerify([objectMock setValue:@5 forKey:@"integerPrimaryKey"]);
                });
            });

            context(@"updatePrimaryKey is false", ^{
                it(@"should not update PK value", ^{
                    mapping.updatePrimaryKey = NO;

                    id objectMock = OCMClassMock([UniqueObject class]);
                    OCMStub([objectMock integerPrimaryKey]).andReturn(@5);
                    [[objectMock reject] setValue:@5 forKey:@"integerPrimaryKey"];

                    [deserializer fillObject:objectMock fromRepresentation:json mapping:mapping];
                });

                it(@"should update 0 PK value", ^{
                    mapping.updatePrimaryKey = NO;

                    id objectMock = OCMClassMock([UniqueObject class]);
                    OCMStub([objectMock integerPrimaryKey]).andReturn(@0);
                    [deserializer fillObject:objectMock fromRepresentation:json mapping:mapping];

                    OCMVerify([objectMock setValue:@5 forKey:@"integerPrimaryKey"]);
                });
            });
        });
    });
});

SPEC_END
