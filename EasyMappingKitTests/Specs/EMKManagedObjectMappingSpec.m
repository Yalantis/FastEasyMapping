//
//  EMKManagedObjectMappingSpec.m
//  EasyMappingCoreDataExample
//
//  Created by Alejandro Isaza on 2013-03-16.
//
//

#import "Kiwi.h"
#import "Person.h"
#import "Car.h"
#import "MappingProvider.h"
#import "EMKManagedObjectMapping.h"

SPEC_BEGIN(EMKManagedObjectMappingSpec)

describe(@"EMKManagedObjectMapping", ^{
    
    describe(@"class methods", ^{
        
        specify(^{
	        [[EMKManagedObjectMapping should] respondToSelector:@selector(mappingForEntityName:configuration:)];
        });
        
        specify(^{
	        [[EMKManagedObjectMapping should] respondToSelector:@selector(mappingForEntityName:rootPath:configuration:)];
        });
        
    });
    
    describe(@"constructors", ^{
        
        __block EMKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EMKManagedObjectMapping alloc] init];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(initWithEntityName:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(initWithEntityName:rootPath:)];
        });
        
    });

    describe(@"properties", ^{
        
        __block EMKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EMKManagedObjectMapping alloc] init];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(entityName)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(rootPath)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(attributeMappings)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(relationshipMappings)];
        });
    });
    
    describe(@".mappingForClass:configuration:", ^{
        
        __block EMKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [EMKManagedObjectMapping mappingForEntityName:@"Car"
                                                     configuration:^(EMKManagedObjectMapping *mapping) {

                                                     }];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.entityName should] equal:@"Car"];
        });
        
    });
    
    describe(@".mappingForClass:rootPath:configuration:", ^{
        
        __block EMKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [EMKManagedObjectMapping mappingForEntityName:@"Car"
                                                          rootPath:@"car"
		                                             configuration:^(EMKManagedObjectMapping *mapping) {

		                                             }];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.entityName should] equal:@"Car"];
        });
        
        specify(^{
            [[mapping.rootPath should] equal:@"car"];
        });
        
    });
    
    describe(@"#initWithObjectClass:", ^{
        
        __block EMKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EMKManagedObjectMapping alloc] initWithEntityName:@"Car"];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.entityName should] equal:@"Car"];
        });
    });
    
    describe(@"#initWithObjectClass:rootPath:", ^{
        
        __block EMKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EMKManagedObjectMapping alloc] initWithEntityName:@"Car" rootPath:@"car"];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.entityName should] equal:@"Car"];
        });
        
        specify(^{
            [[mapping.rootPath should] equal:@"car"];
        });
        
    });
    

});

SPEC_END
