// Copyright (c) 2014 Yalantis.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "Kiwi.h"
#import "CMFixture.h"
#import "CMFactory.h"
#import "MappingProvider.h"
#import "Person.h"
#import "Car.h"
#import "Phone.h"
#import "MagicalRecord.h"
#import "MagicalRecord+Setup.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "EMKManagedObjectDeserializer.h"
#import "NSManagedObjectContext+MagicalSaves.h"
#import "EMKObjectDeserializer.h"
#import "NSManagedObject+MagicalFinders.h"
#import "NSManagedObject+MagicalRecord.h"
#import "NSManagedObject+MagicalDataImport.h"

SPEC_BEGIN(EKManagedObjectDeserializerSpec)

describe(@"EKManagedObjectDeserializer", ^{
    
    beforeEach(^{
        [MagicalRecord setDefaultModelFromClass:[self class]];
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
    });
    
    describe(@".objectFromExternalRepresentation:usingMapping:", ^{
        
        context(@"a simple object", ^{
            
            __block NSManagedObjectContext* moc;
            __block Car *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                externalRepresentation = [CMFixture buildUsingFixture:@"Car"];
	            car = [EMKManagedObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
                                                                               usingMapping:[MappingProvider carMapping]
                                                                                    context:moc];
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
        
        context(@"with existing object", ^{
            
            __block NSManagedObjectContext* moc;
            __block Car *oldCar;
            __block Car *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                
                oldCar = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:moc];
                oldCar.carID = @(1);
                oldCar.year = @"1980";
                oldCar.model = @"";
                [moc MR_saveToPersistentStoreAndWait];
                
                externalRepresentation = @{
                    @"id": @(1),
                    @"model": @"i30",
                    @"year": @"2013"
                };

	            car = [EMKManagedObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
                                                                               usingMapping:[MappingProvider carMappingWithPrimaryKey]
                                                                                    context:moc];
            });
            
            specify(^{
                [car shouldNotBeNil];
            });
            
            specify(^{
                [[car should] equal:oldCar];
            });
            
            specify(^{
                [[car.carID should] equal:oldCar.carID];
            });
            
            specify(^{
                [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
            });
            
            specify(^{
                [[car.year should] equal:[externalRepresentation objectForKey:@"year"]];
            });
            
            specify(^{
                [[[Car MR_findAll] should] haveCountOf:1];
            });
        });
        
        context(@"don't clear missing values", ^{
            
            __block NSManagedObjectContext* moc;
            __block Car *oldCar;
            __block Car *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                
                oldCar = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:moc];
                oldCar.carID = @(1);
                oldCar.year = @"1980";
                oldCar.model = @"";
                
                externalRepresentation = @{ @"id": @(1), @"model": @"i30", };
	            car = [EMKManagedObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
                                                                               usingMapping:[MappingProvider carMappingWithPrimaryKey]
                                                                                    context:moc];
            });
            
            specify(^{
                [[car.carID should] equal:oldCar.carID];
            });
            
            specify(^{
                [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
            });
            
            specify(^{
                [[car.year should] equal:oldCar.year];
            });
            
            specify(^{
                [[[Car MR_findAll] should] haveCountOf:1];
            });
            
        });
        
        context(@"with root key", ^{
            
            __block NSManagedObjectContext* moc;
            __block Car *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithRoot"];
	            car = [EMKManagedObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
                                                                               usingMapping:[MappingProvider carWithRootKeyMapping]
                                                                                    context:moc];
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
            
            __block NSManagedObjectContext* moc;
            __block Car *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithNestedAttributes"];
	            car = [EMKManagedObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
                                                                               usingMapping:[MappingProvider carNestedAttributesMapping]
                                                                                    context:moc];
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
            
            __block NSManagedObjectContext* moc;
            __block Car *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithDate"];
	            car = [EMKManagedObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
                                                                               usingMapping:[MappingProvider carWithDateMapping]
                                                                                    context:moc];
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
            
            it(@"should populate createdAt property with a NSDate", ^{
                
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                format.timeZone = [NSTimeZone timeZoneWithName:@"Europe/London"];
                format.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                format.dateFormat = @"yyyy-MM-dd";
                NSDate *expectedDate = [format dateFromString:[externalRepresentation objectForKey:@"created_at"]];
                [[car.createdAt should] equal:expectedDate];
                
            });
            
        });
        
        context(@"with hasOne objectMapping", ^{
            
            __block NSManagedObjectContext* moc;
            __block Person *person;
            __block Car *expectedCar;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                
                expectedCar = [Car MR_createEntity];
                expectedCar.model = @"i30";
                expectedCar.year = @"2013";
                
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
	            person = [EMKManagedObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
                                                                                  usingMapping:[MappingProvider personMapping]
                                                                                       context:moc];
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
        
        context(@"with hasMany objectMapping", ^{
            
            __block NSManagedObjectContext* moc;
            __block Person *person;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
	            person = [EMKManagedObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
                                                                                  usingMapping:[MappingProvider personMapping]
                                                                                       context:moc];
            });
            
            specify(^{
                [person.phones shouldNotBeNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:2];
            });
            
        });
        
    });
    
    describe(@".deserializeCollectionExternalRepresentation:usingMapping:", ^{
        
        __block NSManagedObjectContext* moc;
        __block NSArray *carsArray;
        __block NSArray *externalRepresentation;
        
        beforeEach(^{
            moc = [NSManagedObjectContext MR_defaultContext];
            externalRepresentation = [CMFixture buildUsingFixture:@"Cars"];
	        carsArray = [EMKManagedObjectDeserializer deserializeCollectionExternalRepresentation:externalRepresentation
                                                                                     usingMapping:[MappingProvider carMapping]
                                                                                          context:moc];
        });
        
        specify(^{
            [carsArray shouldNotBeNil];
        });
        
        specify(^{
            [[carsArray should] haveCountOf:[externalRepresentation count]];
        });
        
    });
});

SPEC_END
