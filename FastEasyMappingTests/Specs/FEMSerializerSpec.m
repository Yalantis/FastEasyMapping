// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "Kiwi.h"
#import "CMFactory.h"
#import "Fixture.h"
#import "MappingProviderNative.h"
#import "PersonNative.h"
#import "CarNative.h"
#import "PhoneNative.h"
#import "AddressNative.h"
#import "Native.h"
#import "NativeChild.h"
#import "FEMSerializer.h"
#import "FEMDeserializer.h"
#import <CoreLocation/CoreLocation.h>

SPEC_BEGIN(FEMSerializerSpec)

	describe(@"FEMSerializer", ^{

		describe(@".serializeObject:withMapping:", ^{

			context(@"a simple object", ^{

				__block CarNative *car;
				__block NSDictionary *representation;

				beforeEach(^{

					CMFactory *factory = [CMFactory forClass:[CarNative class]];
					[factory addToField:@"model" value:^{
						return @"i30";
					}];
					[factory addToField:@"year" value:^{
						return @"2013";
					}];
					car = [factory build];

					representation = [FEMSerializer serializeObject:car usingMapping:[MappingProviderNative carMapping]];
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

				__block CarNative *car;
				__block NSDictionary *representation;

				beforeEach(^{

					CMFactory *factory = [CMFactory forClass:[CarNative class]];
					[factory addToField:@"model" value:^{
						return @"i30";
					}];
					[factory addToField:@"year" value:^{
						return @"2013";
					}];
					car = [factory build];
					representation = [FEMSerializer serializeObject:car
					                                   usingMapping:[MappingProviderNative carWithRootKeyMapping]];
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

				__block CarNative *car;
				__block NSDictionary *representation;

				beforeEach(^{

					CMFactory *factory = [CMFactory forClass:[CarNative class]];
					[factory addToField:@"model" value:^{
						return @"i30";
					}];
					[factory addToField:@"year" value:^{
						return @"2013";
					}];
					car = [factory build];
					representation = [FEMSerializer serializeObject:car
					                                   usingMapping:[MappingProviderNative carNestedAttributesMapping]];
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

				__block CarNative *car;
				__block NSDictionary *representation;
				__block NSDate *referenceDate = [NSDate dateWithTimeIntervalSince1970:0];

                NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
                dayComponent.day = 1;
                NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];

                __block NSDate *date = [calendar dateByAddingComponents:dayComponent toDate:referenceDate options:0];
                __block NSString *dateString = @"1970-01-02";

				beforeEach(^{

					CMFactory *factory = [CMFactory forClass:[CarNative class]];
					[factory addToField:@"model" value:^{
						return @"i30";
					}];
					[factory addToField:@"createdAt" value:^{
						return date;
					}];
					car = [factory build];
					representation = [FEMSerializer serializeObject:car
					                                   usingMapping:[MappingProviderNative carWithDateMapping]];
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

					__block PersonNative *person;
					__block NSDictionary *representation;

					beforeEach(^{

						CMFactory *factory = [CMFactory forClass:[PersonNative class]];
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
						representation = [FEMSerializer serializeObject:person
						                                   usingMapping:[MappingProviderNative personWithOnlyValueBlockMapping]];

					});

					specify(^{
						[representation shouldNotBeNil];
					});

					specify(^{
						[[[representation objectForKey:@"gender"] should] equal:@"male"];
					});

				});

				context(@"when female", ^{

					__block PersonNative *person;
					__block NSDictionary *representation;

					beforeEach(^{

						CMFactory *factory = [CMFactory forClass:[PersonNative class]];
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
						representation = [FEMSerializer serializeObject:person
						                                   usingMapping:[MappingProviderNative personWithOnlyValueBlockMapping]];

					});

					specify(^{
						[[[representation objectForKey:@"gender"] should] equal:@"female"];
					});

				});

				context(@"reverse block with custom object", ^{

					__block AddressNative *address;
					__block NSDictionary *representation;

					beforeEach(^{

						CMFactory *factory = [CMFactory forClass:[AddressNative class]];
						[factory addToField:@"street" value:^{
							return @"A street";
						}];
						[factory addToField:@"location" value:^{
							return [[CLLocation alloc] initWithLatitude:-30.12345 longitude:-3.12345];
						}];
						address = [factory build];
						representation = [FEMSerializer serializeObject:address
						                                   usingMapping:[MappingProviderNative addressMapping]];

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

					__block PersonNative *person;
					__block NSDictionary *representation;

					beforeEach(^{

						CMFactory *factory = [CMFactory forClass:[PersonNative class]];
						[factory addToField:@"name" value:^{
							return @"Lucas";
						}];
						[factory addToField:@"email" value:^{
							return @"lucastoc@gmail.com";
						}];
						[factory addToField:@"car" value:^{
							CarNative *car = [[CarNative alloc] init];
							car.model = @"HB20";
							car.year = @"2012";
							return car;
						}];
						person = [factory build];
						representation = [FEMSerializer serializeObject:person
						                                   usingMapping:[MappingProviderNative personWithCarMapping]];

					});

					specify(^{
						[representation shouldNotBeNil];
					});

					specify(^{
						[[[representation objectForKey:@"car"] should] beKindOfClass:[NSDictionary class]];
					});

				});

				context(@"with hasOneRelation for different naming", ^{
					__block PersonNative * person;
					__block NSDictionary * representation;

					beforeEach(^{

						FEMMapping * mapping = [[FEMMapping alloc] initWithObjectClass:[PersonNative class]];
						[mapping addRelationshipMapping:[MappingProviderNative carMapping]
						                    forProperty:@"car"
								                keyPath:@"vehicle"];

						NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"PersonWithDifferentNaming"];

						person = [FEMDeserializer objectFromRepresentation:externalRepresentation
						                                                           mapping:mapping];

						representation = [FEMSerializer serializeObject:person usingMapping:mapping];
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
                
                context(@"nil relationship for PK mapping", ^{
                    __block PersonNative *person;
					__block NSDictionary *representation;
                    
                    beforeEach(^{
                        person = [[PersonNative alloc] init];
                        person.name = @"Name";
                        representation = [FEMSerializer serializeObject:person usingMapping:[MappingProviderNative personWithCarPKMapping]];
                    });
                    
                    specify(^{
                        [[representation[@"name"] should] equal:person.name];
                        [[representation[@"car"] should] beNil];
                    });
                });

				context(@"with hasManyRelation", ^{

					__block PersonNative *person;
					__block NSDictionary *representation;

					beforeEach(^{

						CMFactory *factory = [CMFactory forClass:[PersonNative class]];
						[factory addToField:@"name" value:^{
							return @"Lucas";
						}];
						[factory addToField:@"email" value:^{
							return @"lucastoc@gmail.com";
						}];
						[factory addToField:@"phones" value:^{
							PhoneNative *phone1 = [[PhoneNative alloc] init];
							phone1.DDI = @"55";
							phone1.DDD = @"85";
							phone1.number = @"1111-1111";
							PhoneNative *phone2 = [[PhoneNative alloc] init];
							phone2.DDI = @"55";
							phone2.DDD = @"11";
							phone2.number = @"2222-2222";
							return @[phone1, phone2];
						}];
						person = [factory build];
						representation = [FEMSerializer serializeObject:person
                                                           usingMapping:[MappingProviderNative personWithPhonesMapping]];

					});

					specify(^{
						[representation shouldNotBeNil];
					});

					specify(^{
						NSLog(@"PersonNative representation: %@", representation);
						[[[representation objectForKey:@"phones"] should] beKindOfClass:[NSArray class]];
					});

				});

				context(@"with hasManyRelation for different naming", ^{
					__block PersonNative * person;
					__block NSDictionary * representation;

					beforeEach(^{
						FEMMapping * mapping = [[FEMMapping alloc] initWithObjectClass:[PersonNative class]];
						[mapping addToManyRelationshipMapping:[MappingProviderNative phoneMapping]
						                          forProperty:@"phones"
								                      keyPath:@"cellphones"];

						NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"PersonWithDifferentNaming"];
						person = [FEMDeserializer objectFromRepresentation:externalRepresentation
						                                                           mapping:mapping];

						representation = [FEMSerializer serializeObject:person usingMapping:mapping];
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
					NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"Native"];
					native = [FEMDeserializer objectFromRepresentation:externalRepresentation
					                                                           mapping:[MappingProviderNative nativeMapping]];
					representation = [FEMSerializer serializeObject:native usingMapping:[MappingProviderNative nativeMapping]];
				});

				specify(^{
					char expected = 'c';
					[[[representation objectForKey:@"charProperty"] should] equal:@(expected)];
				});

				specify(^{
					unsigned char expected = 'u';
					[[[representation objectForKey:@"unsignedCharProperty"] should] equal:@(expected)];
				});

				specify(^{
					short expected = 1;
					[[[representation objectForKey:@"shortProperty"] should] equal:@(expected)];
				});

				specify(^{
					unsigned short expected = 2;
					[[[representation objectForKey:@"unsignedShortProperty"] should] equal:@(expected)];
				});

				specify(^{
					int expected = 3;
					[[[representation objectForKey:@"intProperty"] should] equal:@(expected)];
				});

				specify(^{
					unsigned int expected = 4;
					[[[representation objectForKey:@"unsignedIntProperty"] should] equal:@(expected)];
				});

				specify(^{
					NSInteger expected = 5;
					[[[representation objectForKey:@"integerProperty"] should] equal:@(expected)];
				});

				specify(^{
					NSUInteger expected = 6;
					[[[representation objectForKey:@"unsignedIntegerProperty"] should] equal:@(expected)];
				});

				specify(^{
					long expected = 7;
					[[[representation objectForKey:@"longProperty"] should] equal:@(expected)];
				});

				specify(^{
					unsigned long expected = 8;
					[[[representation objectForKey:@"unsignedLongProperty"] should] equal:@(expected)];
				});

				specify(^{
					long long expected = 9;
					[[[representation objectForKey:@"longLongProperty"] should] equal:@(expected)];
				});

				specify(^{
					unsigned long long expected = 10;
					[[[representation objectForKey:@"unsignedLongLongProperty"] should] equal:@(expected)];
				});

				specify(^{
					float expected = 11.1f;
                    [[[representation objectForKey:@"floatProperty"] should] equal:expected withDelta:0.001];
				});

				specify(^{
                    CGFloat expected = 12.2f;
                    [[[representation objectForKey:@"cgFloatProperty"] should] equal:expected withDelta:0.001];
				});

				specify(^{
					double expected = 13.3;
                    [[[representation objectForKey:@"doubleProperty"] should] equal:expected withDelta:0.001];
				});

				specify(^{
					[[[representation objectForKey:@"boolProperty"] should] equal:@(YES)];
				});

			});

			context(@"with native properties in superclass", ^{

				__block NativeChild *nativeChild;
				__block NSDictionary *representation;

				beforeEach(^{
					NSDictionary *externalRepresentation = [Fixture buildUsingFixture:@"NativeChild"];
					nativeChild = [FEMDeserializer objectFromRepresentation:externalRepresentation
                                                                    mapping:[MappingProviderNative nativeChildMapping]];
					representation = [FEMSerializer serializeObject:nativeChild
					                                   usingMapping:[MappingProviderNative nativeChildMapping]];
				});

				specify(^{
                    int expected = 777;
					[[[representation objectForKey:@"intProperty"] should] equal:@(expected)];
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


