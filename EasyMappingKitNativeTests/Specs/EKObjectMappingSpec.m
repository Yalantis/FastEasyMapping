//
//  EKObjectMappingSpec.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 22/02/13.
//  Copyright 2013 EasyKit. All rights reserved.
//

#import "Kiwi.h"
#import "EasyMapping.h"
#import "Person.h"
#import "Car.h"
#import "MappingProvider.h"

SPEC_BEGIN(EKObjectMappingSpec)

describe(@"EKObjectMapping", ^{
   
    describe(@"class methods", ^{
        
        specify(^{
            [[EKObjectMapping should] respondToSelector:@selector(mappingForClass:withBlock:)];
        });
        
        specify(^{
            [[EKObjectMapping should] respondToSelector:@selector(mappingForClass:withRootPath:withBlock:)];
        });
        
    });
    
    describe(@"constructors", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] init];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(initWithObjectClass:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(initWithObjectClass:withRootPath:)];
        });
        
    });
    
    describe(@"instance methods", ^{
       
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] init];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapKey:toField:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapKey:toField:withDateFormat:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapFieldsFromArray:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapFieldsFromDictionary:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapKey:toField:withValueBlock:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapKey:toField:withValueBlock:withReverseBlock:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(hasOneMapping:forKey:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(hasOneMapping:forKey:forField:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(hasManyMapping:forKey:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(hasManyMapping:forKey:forField:)];
        });
        
    });
    
    describe(@"properties", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] init];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(objectClass)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(setObjectClass:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(rootPath)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(fieldMappings)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(hasOneMappings)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(hasManyMappings)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(field)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(setField:)];
        });
        
    });
    
    describe(@".mappingForClass:withBlock:", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
           mapping = [EKObjectMapping mappingForClass:[Car class] withBlock:^(EKObjectMapping *mapping) {
               
           }];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.objectClass should] equal:[Car class]];
        });
        
    });
    
    describe(@".mappingForClass:withRootPath:withBlock:", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [EKObjectMapping mappingForClass:[Car class] withRootPath:@"car" withBlock:^(EKObjectMapping *mapping) {
                
            }];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.objectClass should] equal:[Car class]];
        });
        
        specify(^{
            [[mapping.rootPath should] equal:@"car"];
        });
        
    });
        
    describe(@"#initWithObjectClass:", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.objectClass should] equal:[Car class]];
        });
        
    });
    
    describe(@"#initWithObjectClass:withRootPath:", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class] withRootPath:@"car"];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.objectClass should] equal:[Car class]];
        });
        
        specify(^{
            [[mapping.rootPath should] equal:@"car"];
        });
        
    });
    
    describe(@"#mapKey:toField:", ^{
       
        __block EKObjectMapping *mapping;
        __block EKFieldMapping *fieldMapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
            [mapping mapKey:@"created_at" toField:@"createdAt"];
            fieldMapping = [mapping.fieldMappings objectForKey:@"createdAt"];
        });
        
        specify(^{
            [[fieldMapping.keyPath should] equal:@"created_at"];
        });
        
        specify(^{
            [[fieldMapping.field should] equal:@"createdAt"];
        });
        
    });
    
    describe(@"#mapKeyFieldsFromArray", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
            [mapping mapFieldsFromArray:@[@"name", @"email"]];
        });
        
        describe(@"name field", ^{
            
            __block EKFieldMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping.fieldMappings objectForKey:@"name"];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"name"];
            });
            
            specify(^{
                [[fieldMapping.field should] equal:@"name"];
            });
        });
        
        describe(@"email field", ^{
            
            __block EKFieldMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping.fieldMappings objectForKey:@"email"];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"email"];
            });
            
            specify(^{
                [[fieldMapping.field should] equal:@"email"];
            });
            
        });
        
    });
    
    describe(@"#mapKeyFieldsFromDictionary", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
            [mapping mapFieldsFromDictionary:@{
                @"id" : @"identifier",
                @"contact.email" : @"email"
            }];
        });
        
        describe(@"identifier field", ^{
            
            __block EKFieldMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping.fieldMappings objectForKey:@"identifier"];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"id"];
            });
            
            specify(^{
                [[fieldMapping.field should] equal:@"identifier"];
            });
        });
        
        describe(@"email field", ^{
            
            __block EKFieldMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping.fieldMappings objectForKey:@"email"];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"contact.email"];
            });
            
            specify(^{
                [[fieldMapping.field should] equal:@"email"];
            });
            
        });
        
    });
    
    describe(@"#mapKey:toField:withDateFormat", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
            [mapping mapKey:@"birthdate" toField:@"birthdate" withDateFormat:@"yyyy-MM-dd"];
            
        });
        
        specify(^{
            [[mapping.fieldMappings objectForKey:@"birthdate"] shouldNotBeNil];
        });
        
        specify(^{
            [[[mapping.fieldMappings objectForKey:@"birthdate"] should] beKindOfClass:[EKFieldMapping class]];
        });
        
        specify(^{
            EKFieldMapping *fieldMapping = [mapping.fieldMappings objectForKey:@"birthdate"];
            [[fieldMapping.dateFormat should] equal:@"yyyy-MM-dd"];
        });
        
    });
    
    describe(@"#mapKey:toField:withValueBlock:", ^{
        
        __block EKObjectMapping *mapping;
        __block EKFieldMapping *fieldMapping;
        
        beforeEach(^{
            
            NSDictionary *genders = @{
                                     @"male": @(GenderMale),
                                     @"female": @(GenderFemale)
                                     };
            
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
            [mapping mapKey:@"gender" toField:@"gender" withValueBlock:^id(NSString *key, id value) {
                return genders[key];
            }];
            
            fieldMapping = [mapping.fieldMappings objectForKey:@"gender"];
            
        });
        
        specify(^{
            [fieldMapping shouldNotBeNil];
        });
        
        specify(^{
            [fieldMapping.valueBlock shouldNotBeNil];
        });
        
    });

    
    describe(@"#mapKey:toField:withValueBlock:withReverseBlock:", ^{
       
        __block EKObjectMapping *mapping;
        __block EKFieldMapping *fieldMapping;
        
        beforeEach(^{
            
            NSDictionary *genders = @{
                                      @"male": @(GenderMale),
                                      @"female": @(GenderFemale)
                                      };
            
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
            [mapping mapKey:@"gender" toField:@"gender" withValueBlock:^id(NSString *key, id value) {
                return genders[key];
            } withReverseBlock:^id(id value) {
                return [genders allKeysForObject:value].lastObject;
            }];
            
            fieldMapping = [mapping.fieldMappings objectForKey:@"gender"];
            
        });
        
        specify(^{
            [fieldMapping shouldNotBeNil];
        });
        
        specify(^{
            [fieldMapping.valueBlock shouldNotBeNil];
        });
        
        specify(^{
            [fieldMapping.valueBlock shouldNotBeNil];
        });
        
    });
    
    describe(@"#hasOneMapping:forKey:", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [MappingProvider personMapping];
        });
        
        specify(^{
            [[mapping hasOneMappings] shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.hasOneMappings objectForKey:@"car"] shouldNotBeNil];
        });
        
        specify(^{
            [[[[mapping.hasOneMappings objectForKey:@"car"] field] should] equal:@"car"];
        });
        
        specify(^{
            [mapping.hasManyMappings shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.hasManyMappings objectForKey:@"phones"] shouldNotBeNil];
        });
        
        specify(^{
            [[[[mapping.hasManyMappings objectForKey:@"phones"] field] should] equal:@"phones"];
        });
        
    });
    
    describe(@"#hasOneMapping:forKey:forField:", ^{
        __block EKObjectMapping * mapping;
       
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
            [mapping hasOneMapping:[MappingProvider carMapping] forKey:@"car" forField:@"personCar"];
        
            [mapping hasManyMapping:[MappingProvider phoneMapping] forKey:@"phones" forField:@"personPhones"];
        });
        
        specify(^{
            [[[[mapping.hasOneMappings objectForKey:@"car"] field] should] equal:@"personCar"];
        });
        
        specify(^{
            [[[[mapping.hasOneMappings objectForKey:@"car"] keyPath] should] equal:@"car"];
        });
        
        specify(^{
            [[[[mapping.hasManyMappings objectForKey:@"phones"] field] should] equal:@"personPhones"];
        });
        
        specify(^{
            [[[[mapping.hasManyMappings objectForKey:@"phones"] keyPath] should] equal:@"phones"];
        });
    });
    
    describe(@"#hasManyMapping:forKey:", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [MappingProvider personMapping];
        });
        
        specify(^{
            [mapping.hasManyMappings shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.hasManyMappings objectForKey:@"phones"] shouldNotBeNil];
        });
        
    });
    
});

SPEC_END


