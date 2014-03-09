//
//  EKSerializerSpec.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 25/02/13.
//  Copyright 2013 EasyKit. All rights reserved.
//

#import "Kiwi.h"
#import "CMFactory.h"
#import "CMFixture.h"
#import "EasyMapping.h"
#import "MappingProvider.h"
#import "Person.h"
#import "Car.h"
#import "Phone.h"
#import "Address.h"
#import "Native.h"
#import "NativeChild.h"
#import <CoreLocation/CoreLocation.h>

SPEC_BEGIN(EKSerializerSpec)

describe(@"EKSerializer", ^{
    
    describe(@"class methods", ^{
        
        specify(^{
            [[EKSerializer should] respondToSelector:@selector(serializeObject:withMapping:)];
        });
        
        specify(^{
            [[EKSerializer should] respondToSelector:@selector(serializeCollection:withMapping:)];
        });
        
    });
   
    describe(@".serializeObject:withMapping:", ^{
       
        context(@"a simple object", ^{
           
            __block Car *car;
            __block NSDictionary *representation;
            
            beforeEach(^{
               
                CMFactory *factory = [CMFactory forClass:[Car class]];
                [factory addToField:@"model" value:^{
                   return @"i30";
                }];
                [factory addToField:@"year" value:^{
                   return @"2013";
                }];
                car = [factory build];
                representation = [EKSerializer serializeObject:car withMapping:[MappingProvider carMapping]];
            });
            
            specify(^{
                [representation shouldNotBeNil];
            });
            
            specify(^{
                [[[representation objectForKey:@"model"] should]equal:[car.model description]];
            });
            
            specify(^{
                [[[representation objectForKey:@"year"] should] equal:[car.year description]];
            });
            
        });
        
        context(@"a simple object with root path", ^{
            
            __block Car *car;
            __block NSDictionary *representation;
            
            beforeEach(^{
                
                CMFactory *factory = [CMFactory forClass:[Car class]];
                [factory addToField:@"model" value:^{
                    return @"i30";
                }];
                [factory addToField:@"year" value:^{
                    return @"2013";
                }];
                car = [factory build];
                representation = [EKSerializer serializeObject:car withMapping:[MappingProvider carWithRootKeyMapping]];
            });
            
            specify(^{
                [representation shouldNotBeNil];
            });
            
            specify(^{
                [[representation objectForKey:@"car"] shouldNotBeNil];
            });
            
            specify(^{
                [[[[representation objectForKey:@"car"] objectForKey:@"model"] should] equal:[car.model description]];
            });
            
            specify(^{
                [[[[representation objectForKey:@"car"] objectForKey:@"year"] should] equal:[car.year description]];
            });
            
        });

        context(@"nested keypaths", ^{

            __block Car *car;
            __block NSDictionary *representation;

            beforeEach(^{

                CMFactory *factory = [CMFactory forClass:[Car class]];
                [factory addToField:@"model" value:^{
                    return @"i30";
                }];
                [factory addToField:@"year" value:^{
                    return @"2013";
                }];
                car = [factory build];
                representation = [EKSerializer serializeObject:car withMapping:[MappingProvider carNestedAttributesMapping]];
            });

            specify(^{
                [representation shouldNotBeNil];
            });

            specify(^{
                [[[representation objectForKey:@"model"] should]equal:[car.model description]];
            });

            specify(^{
                [[[[representation objectForKey:@"information"] objectForKey:@"year"] should] equal:[car.year description]];
            });
        });

        context(@"serialization of dates", ^{

            __block Car *car;
            __block NSDictionary *representation;
            __block NSDate *date = [NSDate date];

            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            __block NSString *dateString = [formatter stringFromDate:date];

            beforeEach(^{

                CMFactory *factory = [CMFactory forClass:[Car class]];
                [factory addToField:@"model" value:^{
                    return @"i30";
                }];
                [factory addToField:@"createdAt" value:^{
                    return date;
                }];
                car = [factory build];
                representation = [EKSerializer serializeObject:car withMapping:[MappingProvider carWithDateMapping]];
            });

            specify(^{
                [representation shouldNotBeNil];
            });

            specify(^{
                [[[representation objectForKey:@"model"] should]equal:[car.model description]];
            });

            specify(^{
                [[[representation objectForKey:@"created_at"] should] equal:dateString];
            });
        });
        
        context(@"with reverse block", ^{
           
            context(@"when male", ^{
                
                __block Person *person;
                __block NSDictionary *representation;
                
                beforeEach(^{
                    
                    CMFactory *factory = [CMFactory forClass:[Person class]];
                    [factory addToField:@"name" value:^{
                        return @"Lucas";
                    }];
                    [factory addToField:@"email" value:^{
                        return @"lucastoc@gmail.com";
                    }];
                    [factory addToField:@"gender" value:^{
                        return @(GenderMale);
                    }];
                    person = [factory build];
                    representation = [EKSerializer serializeObject:person withMapping:[MappingProvider personWithOnlyValueBlockMapping]];
                    
                });
                
                specify(^{
                    [representation shouldNotBeNil];
                });
                
                specify(^{
                    [[[representation objectForKey:@"gender"] should] equal:@"male"];
                });

            });
            
            context(@"when female", ^{
                
                __block Person *person;
                __block NSDictionary *representation;
                
                beforeEach(^{
                    
                    CMFactory *factory = [CMFactory forClass:[Person class]];
                    [factory addToField:@"name" value:^{
                        return @"A woman";
                    }];
                    [factory addToField:@"email" value:^{
                        return @"woman@gmail.com";
                    }];
                    [factory addToField:@"gender" value:^{
                        return @(GenderFemale);
                    }];
                    person = [factory build];
                    representation = [EKSerializer serializeObject:person withMapping:[MappingProvider personWithOnlyValueBlockMapping]];
                    
                });
                
                specify(^{
                    [[[representation objectForKey:@"gender"] should] equal:@"female"];
                });
                
            });
            
            context(@"reverse block with custom object", ^{
                
                __block Address *address;
                __block NSDictionary *representation;
                
                beforeEach(^{
                   
                    CMFactory *factory = [CMFactory forClass:[Address class]];
                    [factory addToField:@"street" value:^{
                        return @"A street";
                    }];
                    [factory addToField:@"location" value:^{
                        return [[CLLocation alloc] initWithLatitude:-30.12345 longitude:-3.12345];
                    }];
                    address = [factory build];
                    representation = [EKSerializer serializeObject:address withMapping:[MappingProvider addressMapping]];
                    
                });
                
                specify(^{
                    [representation shouldNotBeNil];
                });
                
                specify(^{
                    [[representation objectForKey:@"location"] shouldNotBeNil];
                });
                
                specify(^{
                    [[[representation objectForKey:@"location"] should] beKindOfClass:[NSArray class]];
                });
                
            });
            
            context(@"with hasOneRelation", ^{
               
                __block Person *person;
                __block NSDictionary *representation;
               
                beforeEach(^{
                    
                    CMFactory *factory = [CMFactory forClass:[Person class]];
                    [factory addToField:@"name" value:^{
                        return @"Lucas";
                    }];
                    [factory addToField:@"email" value:^{
                        return @"lucastoc@gmail.com";
                    }];
                    [factory addToField:@"car" value:^{
                        Car *car = [[Car alloc] init];
                        car.model = @"HB20";
                        car.year = @"2012";
                        return car;
                    }];
                    person = [factory build];
                    representation = [EKSerializer serializeObject:person withMapping:[MappingProvider personWithCarMapping]];
                    
                });
                
                specify(^{
                    [representation shouldNotBeNil];
                });
                
                specify(^{
                    [[[representation objectForKey:@"car"] should] beKindOfClass:[NSDictionary class]];
                });
                
            });
            
            context(@"with hasOneRelation for different naming", ^{
                __block Person * person;
                __block NSDictionary * representation;
                
                beforeEach(^{
                    
                    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
                    [mapping hasOneMapping:[MappingProvider carMapping] forKey:@"vehicle" forField:@"car"];
                    NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithDifferentNaming"];
                    person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
                    
                    representation = [EKSerializer serializeObject:person withMapping:mapping];
                });
                
                specify(^{
                    [representation shouldNotBeNil];
                });
                
                specify(^{
                    [[representation objectForKey:@"vehicle"] shouldNotBeNil];
                });
                
                specify(^{
                    [[[[representation objectForKey:@"vehicle"] objectForKey:@"model"] should] equal:@"i30"];
                });
            });
            
            context(@"with hasManyRelation", ^{
                
                __block Person *person;
                __block NSDictionary *representation;
                
                beforeEach(^{
                    
                    CMFactory *factory = [CMFactory forClass:[Person class]];
                    [factory addToField:@"name" value:^{
                        return @"Lucas";
                    }];
                    [factory addToField:@"email" value:^{
                        return @"lucastoc@gmail.com";
                    }];
                    [factory addToField:@"phones" value:^{
                        Phone *phone1 = [[Phone alloc] init];
                        phone1.DDI = @"55";
                        phone1.DDD = @"85";
                        phone1.number = @"1111-1111";
                        Phone *phone2 = [[Phone alloc] init];
                        phone2.DDI = @"55";
                        phone2.DDD = @"11";
                        phone2.number = @"2222-2222";
                        return @[phone1, phone2];
                    }];
                    person = [factory build];
                    representation = [EKSerializer serializeObject:person withMapping:[MappingProvider personWithPhonesMapping]];
                    
                });
                
                specify(^{
                    [representation shouldNotBeNil];
                });
                
                specify(^{
                    NSLog(@"Person representation: %@", representation);
                    [[[representation objectForKey:@"phones"] should] beKindOfClass:[NSArray class]];
                });
                
            });
            
            context(@"with hasManyRelation for different naming", ^{
                __block Person * person;
                __block NSDictionary * representation;
                
                beforeEach(^{
                    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
                    [mapping hasManyMapping:[MappingProvider phoneMapping] forKey:@"cellphones" forField:@"phones"];
                    NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithDifferentNaming"];
                    person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
                    
                    representation = [EKSerializer serializeObject:person
                                                       withMapping:mapping];
                });
                
                specify(^{
                    [representation shouldNotBeNil];
                });
                
                specify(^{
                    [[representation objectForKey:@"cellphones"] shouldNotBeNil];
                    
                    [[[representation objectForKey:@"cellphones"] should] beKindOfClass:[NSArray class]];
                });
                
                specify(^{
                    NSDictionary * lastPhone = [[representation objectForKey:@"cellphones"] lastObject];
                    
                    [[[lastPhone objectForKey:@"ddd"] should] equal:@"11"];
                    
                    [[[lastPhone objectForKey:@"number"] should] equal:@"2222-222"];
                });
            });
                        
        });
        
        context(@"with native properties", ^{
            
            __block Native *native;
            __block NSDictionary *representation;
            
            beforeEach(^{
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Native"];
                native = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider nativeMapping]];
                representation = [EKSerializer serializeObject:native withMapping:[MappingProvider nativeMapping]];
            });
            
            specify(^{
                [[[representation objectForKey:@"charProperty"] should] equal:@('c')];
            });
            
            specify(^{
                [[[representation objectForKey:@"unsignedCharProperty"] should] equal:@('u')];
            });
            
            specify(^{
                [[[representation objectForKey:@"shortProperty"] should] equal:@(1)];
            });
            
            specify(^{
                [[[representation objectForKey:@"unsignedShortProperty"] should] equal:@(2)];
            });
            
            specify(^{
                [[[representation objectForKey:@"intProperty"] should] equal:@(3)];
            });
            
            specify(^{
                [[[representation objectForKey:@"unsignedIntProperty"] should] equal:@(4)];
            });
            
            specify(^{
                [[[representation objectForKey:@"integerProperty"] should] equal:@(5)];
            });
            
            specify(^{
                [[[representation objectForKey:@"unsignedIntegerProperty"] should] equal:@(6)];
            });
            
            specify(^{
                [[[representation objectForKey:@"longProperty"] should] equal:@(7)];
            });
            
            specify(^{
                [[[representation objectForKey:@"unsignedLongProperty"] should] equal:@(8)];
            });
            
            specify(^{
                [[[representation objectForKey:@"longLongProperty"] should] equal:@(9)];
            });
            
            specify(^{
                [[[representation objectForKey:@"unsignedLongLongProperty"] should] equal:@(10)];
            });
            
            specify(^{
                [[[representation objectForKey:@"floatProperty"] should] equal:@(11.1f)];
            });
            
            specify(^{
                [[[representation objectForKey:@"cgFloatProperty"] should] equal:@(12.2f)];
            });
            
            specify(^{
                [[[representation objectForKey:@"doubleProperty"] should] equal:@(13.3)];
            });
            
            specify(^{
                [[[representation objectForKey:@"boolProperty"] should] equal:@(YES)];
            });
            
        });
        
        context(@"with native properties in superclass", ^{
            
            __block NativeChild *nativeChild;
            __block NSDictionary *representation;
            
            beforeEach(^{
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"NativeChild"];
                nativeChild = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider nativeChildMapping]];
                representation = [EKSerializer serializeObject:nativeChild withMapping:[MappingProvider nativeChildMapping]];
            });
            
            specify(^{
                [[[representation objectForKey:@"intProperty"] should] equal:@(777)];
            });
            
            specify(^{
                [[[representation objectForKey:@"boolProperty"] should] equal:@(YES)];
            });
            
            specify(^{
                [[[representation objectForKey:@"childProperty"] should] equal:@"Hello"];
            });
            
        });
        
    });
    
});

SPEC_END


