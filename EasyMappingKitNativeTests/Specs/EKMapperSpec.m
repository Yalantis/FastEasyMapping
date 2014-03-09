//
//  EKMapperSpec.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 23/02/13.
//  Copyright 2013 EasyKit. All rights reserved.
//

#import "Kiwi.h"
#import "CMFixture.h"
#import "CMFactory.h"
#import "MappingProviderNative.h"
#import "PersonNative.h"
#import "CarNative.h"
#import "PhoneNative.h"
#import "AddressNative.h"
#import "Native.h"
#import "PlaneNative.h"
#import "SeaplaneNative.h"
#import "AlienNative.h"
#import "FingerNative.h"
#import "CatNative.h"
#import "EMKObjectDeserializer.h"
#import "EMKObjectMapping.h"

SPEC_BEGIN(EKMapperSpec)

describe(@"EKMapper", ^{
    
    describe(@".objectFromExternalRepresentation:withMapping:", ^{
       
        context(@"a simple object", ^{
        
            __block CarNative *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                externalRepresentation = [CMFixture buildUsingFixture:@"Car"];
	            car = [EMKObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
	                                                                    usingMapping:[MappingProviderNative carMapping]];
            });
            
            specify(^{
                [car shouldNotBeNil];
            });
            
            specify(^{
                [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
            });
            
            specify(^{
                [[car.year should] equal:[externalRepresentation objectForKey:@"year"]];
            });
            
        });
        
        context(@"with root key", ^{
            
            __block CarNative *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithRoot"];
	            car = [EMKObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
	                                                                    usingMapping:[MappingProviderNative carWithRootKeyMapping]];
                externalRepresentation = [externalRepresentation objectForKey:@"car"];
            });
            
            specify(^{
                [car shouldNotBeNil];
            });
            
            specify(^{
                [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
            });
            
            specify(^{
                [[car.year should] equal:[externalRepresentation objectForKey:@"year"]];
            });
            
        });
        
        context(@"with nested information", ^{
            
            __block CarNative *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithNestedAttributes"];
	            car = [EMKObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
	                                                                    usingMapping:[MappingProviderNative carNestedAttributesMapping]];
            });
            
            specify(^{
                [car shouldNotBeNil];
            });
            
            specify(^{
                [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
            });
            
            specify(^{
                [[car.year should] equal:[[externalRepresentation objectForKey:@"information"] objectForKey:@"year"]];
            });
            
        });
        
        context(@"with dateformat", ^{
            
            __block CarNative *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithDate"];
	            car = [EMKObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
	                                                                    usingMapping:[MappingProviderNative carWithDateMapping]];
            });
            
            specify(^{
                [car shouldNotBeNil];
            });
            
            specify(^{
                [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
            });
            
            specify(^{
                [[car.year should] equal:[externalRepresentation objectForKey:@"year"]];
            });
            
            it(@"should populate createdAt field with a NSDate", ^{
                
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                format.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                format.dateFormat = @"yyyy-MM-dd";
                NSDate *expectedDate = [format dateFromString:[externalRepresentation objectForKey:@"created_at"]];
                [[car.createdAt should] equal:expectedDate];
                
            });
            
        });
        
        context(@"with valueBlock", ^{
            
            context(@"when male", ^{
            
                __block PersonNative *person;
                __block NSDictionary *externalRepresentation;
                
                beforeEach(^{
                    externalRepresentation = [CMFixture buildUsingFixture:@"Male"];
	                person = [EMKObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
	                                                                           usingMapping:[MappingProviderNative personWithOnlyValueBlockMapping]];
                });
                
                specify(^{
                    [[theValue(person.gender) should] equal:theValue(GenderMale)];
                });
                
            });
            
            context(@"when female", ^{
                
                __block PersonNative *person;
                __block NSDictionary *externalRepresentation;
                
                beforeEach(^{
                    externalRepresentation = [CMFixture buildUsingFixture:@"Female"];
	                person = [EMKObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
	                                                                           usingMapping:[MappingProviderNative personWithOnlyValueBlockMapping]];
                });
                
                specify(^{
                    [[theValue(person.gender) should] equal:theValue(GenderFemale)];
                });
                
            });
            
            context(@"with custom object returned", ^{
                
                __block AddressNative *address;
                __block NSDictionary *externalRepresentation;
                
                beforeEach(^{
                    externalRepresentation = [CMFixture buildUsingFixture:@"Address"];
	                address = [EMKObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
	                                                                            usingMapping:[MappingProviderNative addressMapping]];
                });
                
                specify(^{
                    [address shouldNotBeNil];
                });
                
                specify(^{
                    [address.location shouldNotBeNil];
                });
                
            });
            
        });
        
        context(@"with hasOne mapping", ^{
            
            __block PersonNative *person;
            __block CarNative *expectedCar;
            
            beforeEach(^{
               
                CMFactory *carFactory = [CMFactory forClass:[CarNative class]];
                [carFactory addToField:@"model" value:^{
                    return @"i30";
                }];
                [carFactory addToField:@"year" value:^{
                    return @"2013";
                }];
                expectedCar = [carFactory build];
                
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
	            person = [EMKObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
	                                                                       usingMapping:[MappingProviderNative personMapping]];
            });
            
            specify(^{
                [person.car shouldNotBeNil];
            });
            
            specify(^{
                [[person.car.model should] equal:expectedCar.model];
            });
            
            specify(^{
                [[person.car.year should] equal:expectedCar.year];
            });
            
        });
        
        context(@"with hasOne mapping with different names", ^{
            __block CarNative * expectedCar;
            __block PersonNative * person;
            beforeEach(^{
                expectedCar = [[CarNative alloc] init];
                expectedCar.model = @"i30";
                expectedCar.year = @"2013";
                EMKObjectMapping *mapping = [[EMKObjectMapping alloc] initWithObjectClass:[PersonNative class]];
	            [mapping addRelationshipMapping:[MappingProviderNative carMapping] forProperty:@"car" keyPath:@"vehicle"];

	            NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithDifferentNaming"];
	            person = [EMKObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
	                                                                       usingMapping:mapping];
            });
            
            specify(^{
                [person.car shouldNotBeNil];
            });

            specify(^{
                [[person.car should] beMemberOfClass:[CarNative class]];
            });
            
            specify(^{
                [[person.car.model should] equal:@"i30"];
            });
            
            specify(^{
                [[person.car.year should] equal:@"2013"];
            });

        });
        
        context(@"with hasMany mapping", ^{
            
            __block PersonNative *person;
            
            beforeEach(^{
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
	            person = [EMKObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
	                                                                       usingMapping:[MappingProviderNative personMapping]];
            });
            
            specify(^{
                [person.phones shouldNotBeNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:2];
            });
            
        });
        
        context(@"with hasMany mapping with different names", ^{
            
            __block PersonNative * person;
            
            beforeEach(^{
                EMKObjectMapping * mapping = [[EMKObjectMapping alloc] initWithObjectClass:[PersonNative class]];
	            [mapping addToManyRelationshipMapping:[MappingProviderNative phoneMapping]
	                                      forProperty:@"phones"
			                                  keyPath:@"cellphones"];
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithDifferentNaming"];
	            person = [EMKObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
	                                                                       usingMapping:mapping];
            });
            
            specify(^{
                [person.phones shouldNotBeNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:2];
            });
            
            specify(^{
                [[person.phones.lastObject should] beMemberOfClass:[PhoneNative class]];
            });
            
            specify(^{
                PhoneNative * lastPhone = person.phones.lastObject;
                
                [[lastPhone.number should] equal:@"2222-222"];
            });
        });
        
        context(@"with native properties", ^{
            
            __block Native *native;
            
            beforeEach(^{
                EMKObjectMapping * mapping = [MappingProviderNative nativeMapping];
                NSDictionary * externalRepresentation = [CMFixture buildUsingFixture:@"Native"];
	            native = [EMKObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
	                                                                       usingMapping:mapping];
            });
            
            specify(^{
                [[@(native.charProperty) should] equal:@('c')];
            });
            
            specify(^{
                [[@(native.unsignedCharProperty) should] equal:@('u')];
            });
            
            specify(^{
                [[@(native.shortProperty) should] equal:@(1)];
            });
            
            specify(^{
                [[@(native.unsignedShortProperty) should] equal:@(2)];
            });
            
            specify(^{
                [[@(native.intProperty) should] equal:@(3)];
            });
            
            specify(^{
                [[@(native.unsignedIntProperty) should] equal:@(4)];
            });
            
            specify(^{
                [[@(native.integerProperty) should] equal:@(5)];
            });
            
            specify(^{
                [[@(native.unsignedIntegerProperty) should] equal:@(6)];
            });
            
            specify(^{
                [[@(native.longProperty) should] equal:@(7)];
            });
            
            specify(^{
                [[@(native.unsignedLongProperty) should] equal:@(8)];
            });
            
            specify(^{
                [[@(native.longLongProperty) should] equal:@(9)];
            });
            
            specify(^{
                [[@(native.unsignedLongLongProperty) should] equal:@(10)];
            });
            
            specify(^{
                [[@(native.floatProperty) should] equal:@(11.1f)];
            });
            
            specify(^{
                [[@(native.cgFloatProperty) should] equal:@(12.2f)];
            });
            
            specify(^{
                [[@(native.doubleProperty) should] equal:@(13.3)];
            });
            
            specify(^{
                [[@(native.boolProperty) should] beYes];
            });
            
            context(@"with a native propertie that is null", ^{
                
                __block CatNative *cat;
                
                beforeEach(^{
                    EMKObjectMapping *catMapping = [MappingProviderNative nativeMappingWithNullPropertie];
                    NSDictionary *values = @{ @"age": [NSNull null] };
	                cat = [EMKObjectDeserializer deserializeObjectExternalRepresentation:values
	                                                                        usingMapping:catMapping];
                });
                
                specify(^{
                    [[cat shouldNot] beNil];
                });
                
                specify(^{
                    [[theValue(cat.age) should] equal:theValue(0)];
                });
                
            });
            
        });
        
    });
    
    describe(@".arrayOfObjectsFromExternalRepresentation:withMapping:", ^{
       
        __block NSArray *carsArray;
        __block NSArray *externalRepresentation;
        
        beforeEach(^{
            externalRepresentation = [CMFixture buildUsingFixture:@"Cars"];
	        carsArray = [EMKObjectDeserializer deserializeCollectionExternalRepresentation:externalRepresentation
	                                                                          usingMapping:[MappingProviderNative carMapping]];
        });
        
        specify(^{
            [carsArray shouldNotBeNil];
        });
        
        specify(^{
            [[carsArray should] haveCountOf:[externalRepresentation count]];
        });
        
    });
    
    context(@"with hasMany mapping with set", ^{
        
        __block PlaneNative * plane;
        
        beforeEach(^{
            NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Plane"];
            EMKObjectMapping * mapping = [[EMKObjectMapping alloc] initWithObjectClass:[PlaneNative class]];
	        [mapping addToManyRelationshipMapping:[MappingProviderNative personMapping] forProperty:@"persons" keyPath:@"persons"];
	        [mapping addToManyRelationshipMapping:[MappingProviderNative personMapping] forProperty:@"pilots" keyPath:@"pilots"];
	        [mapping addToManyRelationshipMapping:[MappingProviderNative personMapping] forProperty:@"stewardess" keyPath:@"stewardess"];
	        [mapping addToManyRelationshipMapping:[MappingProviderNative personMapping] forProperty:@"stars" keyPath:@"stars"];

	        plane = [EMKObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
	                                                                  usingMapping:mapping];
        });
        
        specify(^{
            [plane.persons shouldNotBeNil];
        });
        
        specify(^{
            [[plane.persons should] beKindOfClass:[NSSet class]];
        });
        
        specify(^{
            [[plane.pilots should] beKindOfClass:[NSMutableSet class]];
        });

        specify(^{
            [[plane.stewardess should] beKindOfClass:[NSOrderedSet class]];
        });

        specify(^{
            [[plane.stars should] beKindOfClass:[NSMutableOrderedSet class]];
        });

    });
    
    context(@"with hasMany mapping with set and different key name", ^{
        
        __block SeaplaneNative * seaplane;
        
        beforeEach(^{
            NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Plane"];
            EMKObjectMapping * mapping = [[EMKObjectMapping alloc] initWithObjectClass:[SeaplaneNative class]];
	        [mapping addToManyRelationshipMapping:[MappingProviderNative personMapping] forProperty:@"passengers" keyPath:@"persons"];

	        seaplane = [EMKObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
	                                                                     usingMapping:mapping];
        });
        
        specify(^{
            [seaplane.passengers shouldNotBeNil];
        });

        specify(^{
            [[seaplane.passengers should] beKindOfClass:[NSSet class]];
        });
        
    });
    
    context(@"with hasMany mapping with NSMutableArray", ^{
        
        __block AlienNative *alien;
        
        beforeEach(^{
            NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Alien"];
	        alien = [EMKObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
	                                                                  usingMapping:[MappingProviderNative alienMapping]];
        });
        
        specify(^{
            [alien.fingers shouldNotBeNil];
        });
        
        specify(^{
            [[alien.fingers should] beKindOfClass:[NSMutableArray class]];
        });
    
    });
    
});

SPEC_END


