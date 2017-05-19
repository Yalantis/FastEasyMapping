// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Kiwi/Kiwi.h>

#import "FEMAttribute.h"

SPEC_BEGIN(FEMAttributeSpec)

describe(@"FEMAttribute", ^{
    FEMMapBlock map = ^id (id value) {
        return @10;
    };
    FEMMapBlock reverseMap = ^id (id value) {
        return @20;
    };

    context(@"init", ^{
        __block FEMAttribute *mapping = nil;

        afterEach(^{
            mapping = nil;
        });

        describe(@"property can't be nil", ^{
            [[theBlock(^{
                mapping = [[FEMAttribute alloc] initWithProperty:@"" keyPath:nil map:NULL reverseMap:NULL];
            }) should] raise];
        });
 
        describe(@"keyPath can be nil", ^{
            [[theBlock(^{
                mapping = [[FEMAttribute alloc] initWithProperty:@"property" keyPath:nil map:NULL reverseMap:NULL];
            }) shouldNot] raise];
        });

        describe(@"property should be equal to initial", ^{
            specify(^{
                mapping = [[FEMAttribute alloc] initWithProperty:@"property" keyPath:nil map:NULL reverseMap:NULL];

                [[mapping.property should] equal:@"property"];
            });
        });

        describe(@"keyPath should be equal to initial", ^{
            specify(^{
                mapping = [[FEMAttribute alloc] initWithProperty:@"property" keyPath:@"keyPath" map:NULL reverseMap:NULL];

                [[mapping.keyPath should] equal:@"keyPath"];
            });
        });

        describe(@"map should behave equal to initial", ^{
            specify(^{
                mapping = [[FEMAttribute alloc] initWithProperty:@"property" keyPath:@"keyPath" map:map reverseMap:NULL];

                [[[mapping mapValue:@"value"] should] equal:map(@"value")];
            });
        });

        describe(@"reverse map should behave equal to initial", ^{
            specify(^{
                mapping = [[FEMAttribute alloc] initWithProperty:@"property" keyPath:@"keyPath" map:NULL reverseMap:reverseMap];

                [[[mapping reverseMapValue:@"value"] should] equal:reverseMap(@"value")];
            });
        });

        describe(@"default map", ^{
            it(@"NULL map should behave as passthrough map", ^{
                mapping = [[FEMAttribute alloc] initWithProperty:@"property" keyPath:nil map:NULL reverseMap:NULL];

                [[[mapping mapValue:@1] should] equal:@1];
            });

            it(@"NULL reverseMap should behave as passthrough map", ^{
                mapping = [[FEMAttribute alloc] initWithProperty:@"property" keyPath:nil map:NULL reverseMap:NULL];
                
                [[[mapping reverseMapValue:@2] should] equal:@2];
            });
        });
    });

    context(@"shortcuts", ^{
        __block FEMAttribute *mapping = nil;
        
        afterEach(^{
            mapping = nil;
        });

        describe(@"+mappingOfProperty:", ^{
            specify(^{
                mapping = [FEMAttribute mappingOfProperty:@"property"];

                [[mapping.property should] equal:@"property"];
                [[mapping.keyPath should] beNil];
                [[[mapping mapValue:@1] should] equal:@1];
                [[[mapping reverseMapValue:@2] should] equal:@2];
            });
        });

        describe(@"+mappingOfProperty:toKeyPath:", ^{
            specify(^{
                mapping = [FEMAttribute mappingOfProperty:@"property" toKeyPath:@"keyPath"];

                [[mapping.property should] equal:@"property"];
                [[mapping.keyPath should] equal:@"keyPath"];
                [[[mapping mapValue:@1] should] equal:@1];
                [[[mapping reverseMapValue:@2] should] equal:@2];
            });
        });

        describe(@"+mappingOfProperty:toKeyPath:map:", ^{
            specify(^{
                mapping = [FEMAttribute mappingOfProperty:@"property" toKeyPath:@"keyPath" map:map];

                [[mapping.property should] equal:@"property"];
                [[mapping.keyPath should] equal:@"keyPath"];
                [[[mapping mapValue:@1] should] equal:map(@1)];
                [[[mapping reverseMapValue:@2] should] equal:@2];
            });
        });

        describe(@"+mappingOfProperty:toKeyPath:map:reverseMap:", ^{
            specify(^{
                mapping = [FEMAttribute mappingOfProperty:@"property" toKeyPath:@"keyPath" map:map reverseMap:reverseMap];

                [[mapping.property should] equal:@"property"];
                [[mapping.keyPath should] equal:@"keyPath"];
                [[[mapping mapValue:@1] should] equal:map(@1)];
                [[[mapping reverseMapValue:@2] should] equal:reverseMap(@2)];
            });
        });

        describe(@"+mappingOfProperty:toKeyPath:dateFormat: should use UTC timezone", ^{
            __block NSDateFormatter *formatter = nil;
            beforeEach(^{
                formatter = [[NSDateFormatter alloc] init];
                formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                formatter.dateFormat = @"yyyy-MM-dd";

                mapping = [FEMAttribute mappingOfProperty:@"property" toKeyPath:@"keyPath" dateFormat:formatter.dateFormat];
            });

            afterEach(^{
                formatter = nil;
            });

            specify(^{
                NSString *dateString = @"2014-10-10";
                NSDate *date = [formatter dateFromString:dateString];

                [[[mapping mapValue:dateString] should] equal:date];
                [[[mapping reverseMapValue:date] should] equal:dateString];
            });

            it(@"should return NSNull for map if value not an NSString", ^{
                [[[mapping mapValue:@10] should] equal:NSNull.null];
            });
        });

        describe(@"+mappingOfURLProperty:toKeyPath:", ^{
            beforeEach(^{
                mapping = [FEMAttribute mappingOfURLProperty:@"property" toKeyPath:@"keyPath"];
            });

            specify(^{
                NSString *urlString = @"http://google.com";
                NSURL *url = [NSURL URLWithString:urlString];

                [[[mapping mapValue:urlString] should] equal:url];
                [[[mapping reverseMapValue:url] should] equal:urlString];
            });

            it(@"should return NSNull for map if value not an NSString", ^{
                [[[mapping mapValue:@10] should] equal:NSNull.null];
            });
        });
    });
});

SPEC_END
