// Copyright (c) 2014 Lucas Medeiros.
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
            mapping = [[FEMManagedObjectMapping alloc] init];
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
            mapping = [[FEMManagedObjectMapping alloc] init];
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
