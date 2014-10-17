//
// Created by zen on 17/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "FEMAttributeMapping.h"

SPEC_BEGIN(FEMAttributeMappingSpec)

describe(@"FEMAttributeMapping", ^{
    context(@"init", ^{
        describe(@"property can't be nil", ^{
            [[theBlock(^{
                FEMAttributeMapping *mapping = [[FEMAttributeMapping alloc] initWithProperty:nil keyPath:nil map:NULL reverseMap:NULL];
            }) should] raise];
        });

        describe(@"keyPath can be nil", ^{
            [[theBlock(^{
                FEMAttributeMapping *mapping = [[FEMAttributeMapping alloc] initWithProperty:@"property" keyPath:nil map:NULL reverseMap:NULL];
            }) shouldNot] raise];
        });

        describe(@"property should be equal to initial", ^{
            specify(^{
                FEMAttributeMapping *mapping = [[FEMAttributeMapping alloc] initWithProperty:@"property" keyPath:nil map:NULL reverseMap:NULL];
                [[mapping.property should] equal:@"property"];
            });
        });

        describe(@"keyPath should be equal to initial", ^{
            FEMAttributeMapping *mapping = [[FEMAttributeMapping alloc] initWithProperty:@"property" keyPath:@"keyPath" map:NULL reverseMap:NULL];
            [[mapping.keyPath should] equal:@"keyPath"];
        });

        describe(@"map should behave equal to initial", ^{
            FEMMapBlock map = ^id (id value) {
                return @(10);
            };
            FEMAttributeMapping *mapping = [[FEMAttributeMapping alloc] initWithProperty:@"property" keyPath:@"keyPath" map:map reverseMap:NULL];

            specify(^{
                [[[mapping mapValue:@"value"] should] equal:map(@"value")];
            });
        });

        describe(@"reverse map should behave equal to initial", ^{
            FEMMapBlock reverseMap = ^id (id value) {
                return @(10);
            };
            FEMAttributeMapping *mapping = [[FEMAttributeMapping alloc] initWithProperty:@"property" keyPath:@"keyPath" map:NULL reverseMap:reverseMap];

            specify(^{
                [[[mapping reverseMapValue:@"value"] should] equal:map(@"value")];
            });
        });
    });
});

SPEC_END