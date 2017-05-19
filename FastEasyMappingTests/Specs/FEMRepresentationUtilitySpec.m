// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Kiwi/Kiwi.h>

@import FastEasyMapping;

#import "Fixture.h"
#import "Chat+Mapping.h"

SPEC_BEGIN(FEMRepresentationUtilitySpec)
describe(@"FEMRepresentationCollectPresentedPrimaryKeys", ^{
    context(@"indirect recursive relationship", ^{
        it(@"should combine similar mappings", ^{
            NSDictionary *fixture = [Fixture buildUsingFixture:@"RecursiveChatLastMessage"];
            FEMMapping *mapping = [Chat chatLastMessageMapping];
            
            NSDictionary<NSNumber *, NSSet<id> *> *map = FEMRepresentationCollectPresentedPrimaryKeys(fixture, mapping);
            [[[map should] have:2] values];
            
            [[map[mapping.uniqueIdentifier] should] equal:[NSSet setWithObject:@1]];
            [[map[[mapping relationshipForProperty:@"lastMessage"].mapping.uniqueIdentifier] should] equal:[NSSet setWithObject:@300]];
        });
    });
});

SPEC_END
