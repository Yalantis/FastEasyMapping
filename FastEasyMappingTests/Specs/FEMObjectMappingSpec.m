// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "Kiwi.h"
#import "PersonNative.h"
#import "CarNative.h"
#import "MappingProviderNative.h"
#import "FEMObjectMapping.h"
#import "FEMAttributeMapping.h"
#import "FEMRelationshipMapping.h"
#import "PhoneNative.h"

SPEC_BEGIN(FEMObjectMappingSpec)

describe(@"FEMObjectMapping", ^{
   
    describe(@".mappingForClass:withBlock:", ^{
        
        __block FEMObjectMapping *mapping;
        
        beforeEach(^{
           mapping = [FEMObjectMapping mappingForClass:[CarNative class] configuration:^(FEMObjectMapping *mapping) {

           }];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.objectClass should] equal:[CarNative class]];
        });
        
    });
    
    describe(@".mappingForClass:rootPath:configuration:", ^{
        
        __block FEMObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [FEMObjectMapping mappingForClass:[CarNative class]
                                               rootPath:@"car"
		                                  configuration:^(FEMObjectMapping *mapping) {

		                                  }];
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
        
    describe(@"#initWithObjectClass:", ^{
        
        __block FEMObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[FEMObjectMapping alloc] initWithObjectClass:[CarNative class]];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.objectClass should] equal:[CarNative class]];
        });
        
    });
    
    describe(@"#initWithObjectClass:rootPath:", ^{
        
        __block FEMObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[FEMObjectMapping alloc] initWithObjectClass:[CarNative class] rootPath:@"car"];
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
    
    describe(@"#mapKey:toField:", ^{
       
        __block FEMObjectMapping *mapping;
        __block FEMAttributeMapping *fieldMapping;
        
        beforeEach(^{
            mapping = [[FEMObjectMapping alloc] initWithObjectClass:[CarNative class]];
	        [mapping addAttributeMappingOfProperty:@"createdAt" atKeypath:@"created_at"];
	        fieldMapping = [mapping attributeMappingForProperty:@"createdAt"];
        });
        
        specify(^{
            [[fieldMapping.keyPath should] equal:@"created_at"];
        });
        
        specify(^{
            [[fieldMapping.property should] equal:@"createdAt"];
        });
        
    });
    
    describe(@"#mapKeyFieldsFromArray", ^{
        
        __block FEMObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[FEMObjectMapping alloc] initWithObjectClass:[CarNative class]];
	        [mapping addAttributeMappingFromArray:@[@"name", @"email"]];
        });
        
        describe(@"name field", ^{
            
            __block FEMAttributeMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping attributeMappingForProperty:@"name"];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"name"];
            });
            
            specify(^{
                [[fieldMapping.property should] equal:@"name"];
            });
        });
        
        describe(@"email field", ^{
            
            __block FEMAttributeMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping attributeMappingForProperty:@"email"];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"email"];
            });
            
            specify(^{
                [[fieldMapping.property should] equal:@"email"];
            });
            
        });
        
    });
    
    describe(@"#mapKeyFieldsFromDictionary", ^{
        
        __block FEMObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[FEMObjectMapping alloc] initWithObjectClass:[CarNative class]];
	        [mapping addAttributeMappingDictionary:@{
                @"identifier": @"id",
                @"email": @"contact.email"
            }];
        });
        
        describe(@"identifier field", ^{
            
            __block FEMAttributeMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping attributeMappingForProperty:@"identifier"];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"id"];
            });
            
            specify(^{
                [[fieldMapping.property should] equal:@"identifier"];
            });
        });
        
        describe(@"email field", ^{
            
            __block FEMAttributeMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping attributeMappingForProperty:@"email"];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"contact.email"];
            });
            
            specify(^{
                [[fieldMapping.property should] equal:@"email"];
            });
            
        });
        
    });
    
    describe(@"#mapKey:toField:withDateFormat", ^{
        
        __block FEMObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[FEMObjectMapping alloc] initWithObjectClass:[CarNative class]];
	        [mapping addAttributeMapping:[FEMAttributeMapping mappingOfProperty:@"birthday"
                                                                      toKeyPath:@"birthday"
                                                                     dateFormat:@"yyyy-MM-dd"]];
        });
        
        specify(^{
            [[mapping attributeMappingForProperty:@"birthday"] shouldNotBeNil];
        });
        
        specify(^{
            [[[mapping attributeMappingForProperty:@"birthday"] should] beKindOfClass:[FEMAttributeMapping class]];
        });
        
//        specify(^{
//            FEMAttributeMapping *fieldMapping = [mapping attributeMappingForProperty:@"birthdate"];
//            [[fieldMapping.dateFormat should] equal:@"yyyy-MM-dd"];
//        });
        
    });
    
    describe(@"#mapKey:toField:withValueBlock:", ^{
        
        __block FEMObjectMapping *mapping;
        __block FEMAttributeMapping *fieldMapping;
        
        beforeEach(^{
            
            NSDictionary *genders = @{
                                     @"male": @(GenderMale),
                                     @"female": @(GenderFemale)
                                     };
            
            mapping = [[FEMObjectMapping alloc] initWithObjectClass:[PersonNative class]];
	        [mapping addAttributeMapping:[FEMAttributeMapping mappingOfProperty:@"gender"
                                                                      toKeyPath:@"gender"
                                                                            map:^id(id value) {
                        return genders[value];
                    }]];

            fieldMapping = [mapping attributeMappingForProperty:@"gender"];
            
        });
        
        specify(^{
            [fieldMapping shouldNotBeNil];
        });
    });

    
    describe(@"#mapKey:toField:withValueBlock:withReverseBlock:", ^{
       
        __block FEMObjectMapping *mapping;
        __block FEMAttributeMapping *fieldMapping;
        
        beforeEach(^{
            
            NSDictionary *genders = @{
                                      @"male": @(GenderMale),
                                      @"female": @(GenderFemale)
                                      };
            
            mapping = [[FEMObjectMapping alloc] initWithObjectClass:[PersonNative class]];
	        [mapping addAttributeMapping:[FEMAttributeMapping mappingOfProperty:@"gender"
                                                                      toKeyPath:@"gender"
                                                                            map:^id(id value) {
                        return genders[value];
                    }
                                                                     reverseMap:^id(id value) {
                        return [genders allKeysForObject:value].lastObject;
                    }]];
	        
            fieldMapping = [mapping attributeMappingForProperty:@"gender"];
        });
        
        specify(^{
            [fieldMapping shouldNotBeNil];
        });
    });
    
    describe(@"#hasOneMapping:forKey:", ^{
        
        __block FEMObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [MappingProviderNative personMapping];
        });
        
        specify(^{
	        [[mapping relationshipMappings] shouldNotBeNil];
        });
        
        specify(^{
            [[mapping relationshipMappingForProperty:@"car"] shouldNotBeNil];
        });
        
        specify(^{
            [[[[mapping relationshipMappingForProperty:@"car"] property] should] equal:@"car"];
        });
        
        specify(^{
            [[mapping relationshipMappingForProperty:@"phones"] shouldNotBeNil];
        });
        
        specify(^{
            [[[[mapping relationshipMappingForProperty:@"phones"] property] should] equal:@"phones"];
        });
        
    });
    
    describe(@"#hasOneMapping:forKey:forField:", ^{
        __block FEMObjectMapping * mapping;
       
        beforeEach(^{
            mapping = [[FEMObjectMapping alloc] initWithObjectClass:[PersonNative class]];
	        [mapping addRelationshipMapping:[MappingProviderNative carMapping] forProperty:@"personCar" keyPath:@"car"];

	        [mapping addToManyRelationshipMapping:[MappingProviderNative phoneMapping] forProperty:@"personPhones" keyPath:@"phones"];
        });

        specify(^{
            [[[[mapping relationshipMappingForProperty:@"personCar"] property] should] equal:@"personCar"];
        });
        
        specify(^{
            [[[[mapping relationshipMappingForProperty:@"personCar"] keyPath] should] equal:@"car"];
        });
        
        specify(^{
            [[[[mapping relationshipMappingForProperty:@"personPhones"] property] should] equal:@"personPhones"];
        });
        
        specify(^{
            [[[[mapping relationshipMappingForProperty:@"personPhones"] keyPath] should] equal:@"phones"];
        });
    });
    
    describe(@"#hasManyMapping:forKey:", ^{
        
        __block FEMObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [MappingProviderNative personMapping];
        });
        
        specify(^{
	        [[mapping relationshipMappings] shouldNotBeNil];
        });
        
        specify(^{
            [[mapping relationshipMappingForProperty:@"phones"] shouldNotBeNil];
        });
        
    });

//    describe(@"description", ^{
//        __block FEMObjectMapping *mapping = nil;
//
//        beforeEach(^{
//            mapping = [MappingProviderNative personWithPhonesMapping];
//        });
//
//        specify(^{
//            NSString *description = [mapping description];
//            NSLog(@"%@", description);
//        });
//    });
    
});

SPEC_END


