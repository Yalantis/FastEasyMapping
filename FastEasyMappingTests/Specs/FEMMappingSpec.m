// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Kiwi/Kiwi.h>

#import "PersonNative.h"
#import "CarNative.h"
#import "MappingProviderNative.h"
#import "FEMMapping.h"
#import "FEMAttribute.h"
#import "FEMRelationship.h"
#import "PhoneNative.h"

SPEC_BEGIN(FEMObjectMappingSpec)

describe(@"FEMMapping", ^{
    describe(@"-initWithObjectClass:", ^{
        __block FEMMapping *mapping;

        beforeEach(^{
            mapping = [[FEMMapping alloc] initWithObjectClass:[CarNative class]];
        });

        specify(^{
            [mapping shouldNotBeNil];
        });

        specify(^{
            [[mapping.objectClass should] equal:[CarNative class]];
        });
    });

    describe(@"-initWithObjectClass:rootPath:", ^{

        __block FEMMapping *mapping;

        beforeEach(^{
            mapping = [[FEMMapping alloc] initWithObjectClass:[CarNative class] rootPath:@"car"];
        });

        specify(^{
            [mapping shouldNotBeNil];
        });

        specify(^{
            [[mapping.objectClass should] equal:[CarNative class]];
        });

        specify(^{
            [[mapping.rootPath should] equal:@"car"];
        });

    });

    describe(@"-addAttributeWithProperty:keyPath:", ^{
        __block FEMMapping *mapping;
        __block FEMAttribute *fieldMapping;

        beforeEach(^{
            mapping = [[FEMMapping alloc] initWithObjectClass:[CarNative class]];
            [mapping addAttributeWithProperty:@"createdAt" keyPath:@"created_at"];
            fieldMapping = [mapping attributeForProperty:@"createdAt"];
        });

        specify(^{
            [[fieldMapping.keyPath should] equal:@"created_at"];
        });

        specify(^{
            [[fieldMapping.property should] equal:@"createdAt"];
        });

    });

    describe(@"-addAttributesFromArray:", ^{
        __block FEMMapping *mapping;

        beforeEach(^{
            mapping = [[FEMMapping alloc] initWithObjectClass:[CarNative class]];
            [mapping addAttributesFromArray:@[@"name", @"email"]];
        });

        describe(@"name field", ^{
            __block FEMAttribute *fieldMapping;

            beforeEach(^{
                fieldMapping = [mapping attributeForProperty:@"name"];
            });

            specify(^{
                [[fieldMapping.keyPath should] equal:@"name"];
            });

            specify(^{
                [[fieldMapping.property should] equal:@"name"];
            });
        });

        describe(@"email field", ^{
            __block FEMAttribute *fieldMapping;

            beforeEach(^{
                fieldMapping = [mapping attributeForProperty:@"email"];
            });

            specify(^{
                [[fieldMapping.keyPath should] equal:@"email"];
            });

            specify(^{
                [[fieldMapping.property should] equal:@"email"];
            });
        });
    });

    describe(@"-addAttributesFromDictionary:", ^{
        __block FEMMapping *mapping;

        beforeEach(^{
            mapping = [[FEMMapping alloc] initWithObjectClass:[CarNative class]];
            [mapping addAttributesFromDictionary:@{
                @"identifier" : @"id",
                @"email" : @"contact.email"
            }];
        });

        describe(@"identifier field", ^{
            __block FEMAttribute *fieldMapping;

            beforeEach(^{
                fieldMapping = [mapping attributeForProperty:@"identifier"];
            });

            specify(^{
                [[fieldMapping.keyPath should] equal:@"id"];
            });

            specify(^{
                [[fieldMapping.property should] equal:@"identifier"];
            });
        });

        describe(@"email field", ^{
            __block FEMAttribute *fieldMapping;

            beforeEach(^{
                fieldMapping = [mapping attributeForProperty:@"email"];
            });

            specify(^{
                [[fieldMapping.keyPath should] equal:@"contact.email"];
            });

            specify(^{
                [[fieldMapping.property should] equal:@"email"];
            });
        });
    });

    describe(@"-addAttribute:", ^{

        __block FEMMapping *mapping;

        beforeEach(^{
            mapping = [[FEMMapping alloc] initWithObjectClass:[CarNative class]];
            [mapping addAttribute:[FEMAttribute mappingOfProperty:@"birthday"
                                                        toKeyPath:@"birthday"
                                                       dateFormat:@"yyyy-MM-dd"]];
        });

        specify(^{
            [[mapping attributeForProperty:@"birthday"] shouldNotBeNil];
        });

        specify(^{
            [[[mapping attributeForProperty:@"birthday"] should] beKindOfClass:[FEMAttribute class]];
        });
    });

    describe(@"relationships", ^{
        __block FEMMapping *mapping;

        beforeEach(^{
            mapping = [MappingProviderNative personMapping];
        });

        specify(^{
            [[mapping relationships] shouldNotBeNil];
        });

        specify(^{
            [[mapping relationshipForProperty:@"car"] shouldNotBeNil];
        });

        specify(^{
            [[[[mapping relationshipForProperty:@"car"] property] should] equal:@"car"];
        });

        specify(^{
            [[mapping relationshipForProperty:@"phones"] shouldNotBeNil];
        });

        specify(^{
            [[[[mapping relationshipForProperty:@"phones"] property] should] equal:@"phones"];
        });

    });

    describe(@"-add(ToMany)RelationshipMapping:", ^{
        __block FEMMapping *mapping;

        beforeEach(^{
            mapping = [[FEMMapping alloc] initWithObjectClass:[PersonNative class]];
            [mapping addRelationshipMapping:[MappingProviderNative carMapping] forProperty:@"personCar" keyPath:@"car"];
            [mapping addToManyRelationshipMapping:[MappingProviderNative phoneMapping] forProperty:@"personPhones" keyPath:@"phones"];
        });

        specify(^{
            [[[[mapping relationshipForProperty:@"personCar"] property] should] equal:@"personCar"];
        });

        specify(^{
            [[[[mapping relationshipForProperty:@"personCar"] keyPath] should] equal:@"car"];
        });

        specify(^{
            [[[[mapping relationshipForProperty:@"personPhones"] property] should] equal:@"personPhones"];
        });

        specify(^{
            [[[[mapping relationshipForProperty:@"personPhones"] keyPath] should] equal:@"phones"];
        });
    });

    describe(@"flattening", ^{
        __block FEMMapping *mapping;
        beforeEach(^{
            mapping = [[FEMMapping alloc] initWithObjectClass:[NSObject class]];
        });

        context(@"when no relationships", ^{
            it(@"should return receiver", ^{
                NSSet *flatten = [mapping flatten];
                [[flatten should] haveCountOf:1];
                [[flatten should] contain:mapping];
            });
        });

        context(@"when has relationships", ^{
           it(@"should return receiver and relationships", ^{
               FEMMapping *child = [mapping copy];
               [mapping addRelationshipMapping:child forProperty:@"property" keyPath:@"keyPath"];

               NSSet *flatten = [mapping flatten];
               [[flatten should] haveCountOf:2];
               [[flatten should] contain:mapping];
               [[flatten should] contain:child];
           });

            it(@"should return nested relationships", ^{
                FEMMapping *child = [mapping copy];
                [mapping addRelationshipMapping:child forProperty:@"property" keyPath:@"keyPath"];
                FEMMapping *nestedChild = [child copy];
                [child addRelationshipMapping:nestedChild forProperty:@"property" keyPath:@"keyPath"];

                NSSet *flatten = [mapping flatten];
                [[flatten should] haveCountOf:3];
                [[flatten should] contain:mapping];
                [[flatten should] contain:child];
                [[flatten should] contain:nestedChild];
            });

            it(@"should not return recursive relationships", ^{
                [mapping addRecursiveRelationshipMappingForProperty:@"property" keypath:@"keyPath"];
                NSSet *flatten = [mapping flatten];
                [[flatten should] haveCountOf:1];
                [[flatten should] contain:mapping];
            });
        });
    });
});

describe(@"unique identifier", ^{
    context(@"objectClass", ^{
        it(@"should be non-nil", ^{
            FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[NSObject class]];
            [[mapping.uniqueIdentifier shouldNot] beNil];
            [[mapping.uniqueIdentifier shouldNot] beZero];
        });
        
        it(@"should be unique for different classes", ^{
            FEMMapping *a = [[FEMMapping alloc] initWithObjectClass:[NSObject class]];
            FEMMapping *b = [[FEMMapping alloc] initWithObjectClass:[NSString class]];
            
            [[a.uniqueIdentifier shouldNot] equal:b.uniqueIdentifier];
        });
        
        it(@"should be equal for same class", ^{
            FEMMapping *a = [[FEMMapping alloc] initWithObjectClass:[NSObject class]];
            FEMMapping *b = [[FEMMapping alloc] initWithObjectClass:[NSObject class]];
            
            [[a.uniqueIdentifier should] equal:b.uniqueIdentifier];
        });
    });
    
    context(@"entityName", ^{
        it(@"should be non-nil", ^{
            FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"A"];
            [[mapping.uniqueIdentifier shouldNot] beNil];
            [[mapping.uniqueIdentifier shouldNot] beZero];
        });
        
        it(@"should be unique for different classes", ^{
            FEMMapping *a = [[FEMMapping alloc] initWithEntityName:@"A"];
            FEMMapping *b = [[FEMMapping alloc] initWithEntityName:@"B"];
            
            [[a.uniqueIdentifier shouldNot] equal:b.uniqueIdentifier];
        });
        
        it(@"should be equal for same class", ^{
            FEMMapping *a = [[FEMMapping alloc] initWithEntityName:@"A"];
            FEMMapping *b = [[FEMMapping alloc] initWithEntityName:@"A"];
            
            [[a.uniqueIdentifier should] equal:b.uniqueIdentifier];
        });
    });
});


SPEC_END


