// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Kiwi/Kiwi.h>
#import <CMFactory/CMFixture.h>
#import <CMFactory/CMFactory.h>
#import <FastEasyMapping/FastEasyMapping.h>
#import <FastEasyMappingRealm/FastEasyMappingRealm.h>
#import "UniqueObject.h"

SPEC_BEGIN(FEMDeserializerSpec)
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

                    CMFac
                });
            });
        });
    });
});

SPEC_END
