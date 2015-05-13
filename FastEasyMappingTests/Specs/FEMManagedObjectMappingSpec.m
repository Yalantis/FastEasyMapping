// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "Kiwi.h"
#import "Person.h"
#import "FEMManagedObjectMapping.h"

SPEC_BEGIN(FEMManagedObjectMappingSpec)

describe(@"FEMManagedObjectMapping", ^{
    
    describe(@"class methods", ^{
        
        specify(^{
	        [[FEMManagedObjectMapping should] respondToSelector:@selector(mappingForEntityName:configuration:)];
        });
        
        specify(^{
	        [[FEMManagedObjectMapping should] respondToSelector:@selector(mappingForEntityName:rootPath:configuration:)];
        });
        
    });
    
    describe(@"constructors", ^{
        
        __block FEMManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[FEMManagedObjectMapping alloc] initWithEntityName:@"Temp"];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(initWithEntityName:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(initWithEntityName:rootPath:)];
        });
        
    });

    describe(@"properties", ^{
        
        __block FEMManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[FEMManagedObjectMapping alloc] initWithEntityName:@"Temp"];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(entityName)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(rootPath)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(attributes)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(relationships)];
        });
    });
    
    describe(@".mappingForClass:configuration:", ^{
        
        __block FEMManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [FEMManagedObjectMapping mappingForEntityName:@"Car"
                                                      configuration:^(FEMManagedObjectMapping *mapping) {

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
        
        __block FEMManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [FEMManagedObjectMapping mappingForEntityName:@"Car"
                                                           rootPath:@"car"
		                                              configuration:^(FEMManagedObjectMapping *mapping) {

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
        
        __block FEMManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[FEMManagedObjectMapping alloc] initWithEntityName:@"Car"];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.entityName should] equal:@"Car"];
        });
    });
    
    describe(@"#initWithObjectClass:rootPath:", ^{
        
        __block FEMManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[FEMManagedObjectMapping alloc] initWithEntityName:@"Car" rootPath:@"car"];
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
