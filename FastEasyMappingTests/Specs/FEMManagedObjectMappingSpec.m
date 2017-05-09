// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "Kiwi.h"
#import "Person.h"
#import "FEMMapping.h"

SPEC_BEGIN(FEMMappingSpec)

describe(@"FEMMapping", ^{
        
    describe(@"constructors", ^{
        
        __block FEMMapping *mapping;
        
        beforeEach(^{
            mapping = [[FEMMapping alloc] initWithEntityName:@"Temp"];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(initWithEntityName:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(initWithEntityName:rootPath:)];
        });
        
    });

    describe(@"properties", ^{
        
        __block FEMMapping *mapping;
        
        beforeEach(^{
            mapping = [[FEMMapping alloc] initWithEntityName:@"Temp"];
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
        
        __block FEMMapping *mapping;
        
        beforeEach(^{
            mapping = [[FEMMapping alloc] initWithEntityName:@"Car"];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.entityName should] equal:@"Car"];
        });
        
    });
    
    describe(@".mappingForClass:rootPath:configuration:", ^{
        
        __block FEMMapping *mapping;
        
        beforeEach(^{
            mapping = [[FEMMapping alloc] initWithEntityName:@"Car" rootPath:@"car"];
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
        
        __block FEMMapping *mapping;
        
        beforeEach(^{
            mapping = [[FEMMapping alloc] initWithEntityName:@"Car"];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.entityName should] equal:@"Car"];
        });
    });
    
    describe(@"#initWithObjectClass:rootPath:", ^{
        
        __block FEMMapping *mapping;
        
        beforeEach(^{
            mapping = [[FEMMapping alloc] initWithEntityName:@"Car" rootPath:@"car"];
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
