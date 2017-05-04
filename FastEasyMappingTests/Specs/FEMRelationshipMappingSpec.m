// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Kiwi/Kiwi.h>

#import "FEMMapping.h"
#import "FEMRelationship.h"

SPEC_BEGIN(FEMRelationshipMappingSpec)
describe(@"FEMRelationship", ^{
    __block FEMMapping *mapping = nil;
    
    beforeEach(^{
        mapping = [[FEMMapping alloc] initWithObjectClass:[NSObject class]];
    });
    
    context(@"NSCopying", ^{
        context(@"recursive", ^{
            __block FEMRelationship *relationship = nil;
            
            beforeEach(^{
                relationship = [[FEMRelationship alloc] initWithProperty:@"property" mapping:mapping];
                [mapping addRelationship:relationship];
            });
            
            it(@"should copy recursive relationship", ^{
                FEMMapping *copy = [mapping copy];
                
                FEMRelationship *relationshipCopy = [copy relationshipForProperty:@"property"];
                
                [[relationshipCopy shouldNot] beNil];
                [[theValue(relationshipCopy == relationship) should] beFalse];
                [[theValue(relationshipCopy.isRecursive) should] beTrue];
                [[relationshipCopy.mapping should] equal:copy];
            });
        });
    });
    
    describe(@"recursive support", ^{
        __block FEMRelationship *relationship = nil;
        
        beforeEach(^{
            relationship = [[FEMRelationship alloc] initWithProperty:@"property" mapping:mapping];
        });
        
        it(@"should become recursive when added to the mapping", ^{
            [[theValue(relationship.isRecursive) should] beFalse];
            
            [mapping addRelationship:relationship];
            
            [[theValue(relationship.isRecursive) should] beTrue];
        });
        
        it(@"should not create retain cycle", ^{
            __block __weak FEMMapping *weakMapping = nil;
            @autoreleasepool {
                FEMMapping *strongMapping = [mapping copy];
                FEMRelationship *rel = [[FEMRelationship alloc] initWithProperty:@"property" mapping:strongMapping];
                [strongMapping addRelationship:rel];
                weakMapping = strongMapping;
            }
            
            [[weakMapping should] beNil];
        });
    });
});

SPEC_END
