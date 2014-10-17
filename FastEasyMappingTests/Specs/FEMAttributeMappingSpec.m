//
// Created by zen on 17/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "FEMAttributeMapping.h"

SPEC_BEGIN(FEMAttributeMappingSpec)

describe(@"FEMAttributeMapping", ^{
    __block FEMAttributeMapping *mapping = nil;
    FEMMapBlock map = ^id (id value) {
        return @10;
    };
    FEMMapBlock reverseMap = ^id (id value) {
        return @20;
    };

    context(@"init", ^{
        afterEach(^{
            mapping = nil;
        });

        describe(@"property can't be nil", ^{
            [[theBlock(^{
                mapping = [[FEMAttributeMapping alloc] initWithProperty:nil keyPath:nil map:NULL reverseMap:NULL];
            }) should] raise];
        });

        describe(@"keyPath can be nil", ^{
            [[theBlock(^{
                mapping = [[FEMAttributeMapping alloc] initWithProperty:@"property" keyPath:nil map:NULL reverseMap:NULL];
            }) shouldNot] raise];
        });

        describe(@"property should be equal to initial", ^{
            specify(^{
                mapping = [[FEMAttributeMapping alloc] initWithProperty:@"property" keyPath:nil map:NULL reverseMap:NULL];

                [[mapping.property should] equal:@"property"];
            });
        });

        describe(@"keyPath should be equal to initial", ^{
            specify(^{
                mapping = [[FEMAttributeMapping alloc] initWithProperty:@"property" keyPath:@"keyPath" map:NULL reverseMap:NULL];

                [[mapping.keyPath should] equal:@"keyPath"];
            });
        });

        describe(@"map should behave equal to initial", ^{
            specify(^{
                mapping = [[FEMAttributeMapping alloc] initWithProperty:@"property" keyPath:@"keyPath" map:map reverseMap:NULL];

                [[[mapping mapValue:@"value"] should] equal:map(@"value")];
            });
        });

        describe(@"reverse map should behave equal to initial", ^{
            specify(^{
                mapping = [[FEMAttributeMapping alloc] initWithProperty:@"property" keyPath:@"keyPath" map:NULL reverseMap:reverseMap];

                [[[mapping reverseMapValue:@"value"] should] equal:map(@"value")];
            });
        });

        describe(@"default map", ^{
            beforeEach(^{
                mapping = [[FEMAttributeMapping alloc] initWithProperty:@"property" keyPath:nil map:NULL reverseMap:NULL];
            });

            describe(@"NULL map should behave as passthrough map", ^{
                [[[mapping mapValue:@1] should] equal:@1];
            });

            describe(@"NULL reverseMap should behave as passthrough map", ^{
                [[[mapping reverseMapValue:@2] should] equal:@2];
            });
        });
    });

    context(@"shortcuts", ^{
        afterEach(^{
            mapping = nil;
        });

        describe(@"+mappingOfProperty:", ^{
            specify(^{
                mapping = [FEMAttributeMapping mappingOfProperty:@"property"];

                [[mapping.property should] equal:@"property"];
                [[mapping.keyPath should] beNil];
                [[[mapping mapValue:@1] should] equal:@1];
                [[[mapping reverseMapValue:@2] should] equal:@2];
            });
        });

        describe(@"+mappingOfProperty:toKeyPath:", ^{
            specify(^{
                mapping = [FEMAttributeMapping mappingOfProperty:@"property" toKeyPath:@"keyPath"];

                [[mapping.property should] equal:@"property"];
                [[mapping.keyPath should] equal:@"keyPath"];
                [[[mapping mapValue:@1] should] equal:@1];
                [[[mapping reverseMapValue:@2] should] equal:@2];
            });
        });

        describe(@"+mappingOfProperty:toKeyPath:map:", ^{
            specify(^{
                mapping = [FEMAttributeMapping mappingOfProperty:@"property" toKeyPath:@"keyPath" map:map];

                [[mapping.property should] equal:@"property"];
                [[mapping.keyPath should] equal:@"keyPath"];
                [[[mapping mapValue:@1] should] equal:map(@1)];
                [[[mapping reverseMapValue:@2] should] equal:@2];
            });
        });

        describe(@"+mappingOfProperty:toKeyPath:map:reverseMap:", ^{
            specify(^{
                mapping = [FEMAttributeMapping mappingOfProperty:@"property" toKeyPath:@"keyPath" map:map reverseMap:reverseMap];

                [[mapping.property should] equal:@"property"];
                [[mapping.keyPath should] equal:@"keyPath"];
                [[[mapping mapValue:@1] should] equal:map(@1)];
                [[[mapping reverseMapValue:@2] should] equal:reverseMap(@2)];
            });
        });

        describe(@"+mappingOfProperty:toKeyPath:dateFormat: should use UTC timezone", ^{
            specify(^{
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                formatter.dateFormat = @"yyyy-MM-dd";

                mapping = [FEMAttributeMapping mappingOfProperty:@"property" toKeyPath:@"keyPath" dateFormat:formatter.dateFormat];

                NSString *dateString = @"2014-10-10";
                NSDate *date = [formatter dateFromString:dateString];

                [[[mapping mapValue:dateString] should] equal:date];
                [[[mapping reverseMapValue:date] should] equal:dateString];
            });
        });

        describe(@"+mappingOfURLProperty:toKeyPath:", ^{
            specify(^{
                mapping = [FEMAttributeMapping mappingOfURLProperty:@"property" toKeyPath:@"keyPath"];

                NSString *urlString = @"http://google.com";
                NSURL *url = [NSURL URLWithString:urlString];

                [[mapping mapValue:urlString] equal:url];
                [[mapping reverseMapValue:url] equal:urlString];
            });
        });
    });
});

SPEC_END