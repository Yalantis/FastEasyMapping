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
#import "EasyMapping.h"
#import "MappingProvider.h"
#import "Person.h"
#import "Car.h"
#import "Phone.h"
#import "Address.h"
#import "Native.h"
#import "Plane.h"
#import "Seaplane.h"
#import "Alien.h"
#import "Finger.h"
#import "Cat.h"

SPEC_BEGIN(EKMapperSpec)

describe(@"EKMapper", ^{
    
    describe(@"class methods", ^{
       
        specify(^{
            [[EKMapper should] respondToSelector:@selector(objectFromExternalRepresentation:withMapping:)];
        });
        
        specify(^{
            [[EKMapper should] respondToSelector:@selector(arrayOfObjectsFromExternalRepresentation:withMapping:)];
        });
        
    });
    
    describe(@".objectFromExternalRepresentation:withMapping:", ^{
       
        context(@"a simple object", ^{
        
            __block Car *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                externalRepresentation = [CMFixture buildUsingFixture:@"Car"];
                car = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider carMapping]];
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
            
            __block Car *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithRoot"];
                car = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider carWithRootKeyMapping]];
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
            
            __block Car *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithNestedAttributes"];
                car = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider carNestedAttributesMapping]];
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
            
            __block Car *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithDate"];
                car = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider carWithDateMapping]];
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
            
                __block Person *person;
                __block NSDictionary *externalRepresentation;
                
                beforeEach(^{
                    externalRepresentation = [CMFixture buildUsingFixture:@"Male"];
                    person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personWithOnlyValueBlockMapping]];
                });
                
                specify(^{
                    [[theValue(person.gender) should] equal:theValue(GenderMale)];
                });
                
            });
            
            context(@"when female", ^{
                
                __block Person *person;
                __block NSDictionary *externalRepresentation;
                
                beforeEach(^{
                    externalRepresentation = [CMFixture buildUsingFixture:@"Female"];
                    person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personWithOnlyValueBlockMapping]];
                });
                
                specify(^{
                    [[theValue(person.gender) should] equal:theValue(GenderFemale)];
                });
                
            });
            
            context(@"with custom object returned", ^{
                
                __block Address *address;
                __block NSDictionary *externalRepresentation;
                
                beforeEach(^{
                    externalRepresentation = [CMFixture buildUsingFixture:@"Address"];
                    address = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider addressMapping]];
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
            
            __block Person *person;
            __block Car *expectedCar;
            
            beforeEach(^{
               
                CMFactory *carFactory = [CMFactory forClass:[Car class]];
                [carFactory addToField:@"model" value:^{
                    return @"i30";
                }];
                [carFactory addToField:@"year" value:^{
                    return @"2013";
                }];
                expectedCar = [carFactory build];
                
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personMapping]];
                
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
            __block Car * expectedCar;
            __block Person * person;
            beforeEach(^{
                expectedCar = [[Car alloc] init];
                expectedCar.model = @"i30";
                expectedCar.year = @"2013";
                EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
                [mapping hasOneMapping:[MappingProvider carMapping] forKey:@"vehicle" forField:@"car"];
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithDifferentNaming"];
                person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
            });
            
            specify(^{
                [person.car shouldNotBeNil];
            });

            specify(^{
                [[person.car should] beMemberOfClass:[Car class]];
            });
            
            specify(^{
                [[person.car.model should] equal:@"i30"];
            });
            
            specify(^{
                [[person.car.year should] equal:@"2013"];
            });

        });
        
        context(@"with hasMany mapping", ^{
            
            __block Person *person;
            
            beforeEach(^{
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personMapping]];
            });
            
            specify(^{
                [person.phones shouldNotBeNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:2];
            });
            
        });
        
        context(@"with hasMany mapping with different names", ^{
            
            __block Person * person;
            
            beforeEach(^{
                EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
                [mapping hasManyMapping:[MappingProvider phoneMapping] forKey:@"cellphones" forField:@"phones"];
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithDifferentNaming"];
                person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
            });
            
            specify(^{
                [person.phones shouldNotBeNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:2];
            });
            
            specify(^{
                [[person.phones.lastObject should] beMemberOfClass:[Phone class]];
            });
            
            specify(^{
                Phone * lastPhone = person.phones.lastObject;
                
                [[lastPhone.number should] equal:@"2222-222"];
            });
        });
        
        context(@"with native properties", ^{
            
            __block Native *native;
            
            beforeEach(^{
                EKObjectMapping * mapping = [MappingProvider nativeMapping];
                NSDictionary * externalRepresentation = [CMFixture buildUsingFixture:@"Native"];
                native = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
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
                
                __block Cat *cat;
                
                beforeEach(^{
                    EKObjectMapping *catMapping = [MappingProvider nativeMappingWithNullPropertie];
                    NSDictionary *values = @{ @"age": [NSNull null] };
                    cat = [EKMapper objectFromExternalRepresentation:values withMapping:catMapping];
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
            carsArray = [EKMapper arrayOfObjectsFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider carMapping]];
        });
        
        specify(^{
            [carsArray shouldNotBeNil];
        });
        
        specify(^{
            [[carsArray should] haveCountOf:[externalRepresentation count]];
        });
        
    });
    
    context(@"with hasMany mapping with set", ^{
        
        __block Plane * plane;
        
        beforeEach(^{
            NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Plane"];
            EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithObjectClass:[Plane class]];
            [mapping hasManyMapping:[MappingProvider personMapping] forKey:@"persons" forField:@"persons"];
            [mapping hasManyMapping:[MappingProvider personMapping] forKey:@"pilots" forField:@"pilots"];
            [mapping hasManyMapping:[MappingProvider personMapping] forKey:@"stewardess" forField:@"stewardess"];
            [mapping hasManyMapping:[MappingProvider personMapping] forKey:@"stars" forField:@"stars"];
            plane = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
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
        
        __block Seaplane * seaplane;
        
        beforeEach(^{
            NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Plane"];
            EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithObjectClass:[Seaplane class]];
            [mapping hasManyMapping:[MappingProvider personMapping] forKey:@"persons" forField:@"passengers"];
            seaplane = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
        });
        
        specify(^{
            [seaplane.passengers shouldNotBeNil];
        });

        specify(^{
            [[seaplane.passengers should] beKindOfClass:[NSSet class]];
        });
        
    });
    
    context(@"with hasMany mapping with NSMutableArray", ^{
        
        __block Alien *alien;
        
        beforeEach(^{
            NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Alien"];
            alien = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider alienMapping]];
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


