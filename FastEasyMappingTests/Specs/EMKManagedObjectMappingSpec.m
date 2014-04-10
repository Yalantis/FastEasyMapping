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
