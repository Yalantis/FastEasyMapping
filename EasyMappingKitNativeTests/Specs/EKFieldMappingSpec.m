//
//  EKFieldMappingSpec.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 22/02/13.
//  Copyright 2013 EasyKit. All rights reserved.
//

#import "Kiwi.h"
#import "EKFieldMapping.h"

SPEC_BEGIN(EKFieldMappingSpec)

describe(@"EKFieldMapping", ^{
   
    __block EKFieldMapping *fieldMapping;
    
    beforeEach(^{
        fieldMapping = [[EKFieldMapping alloc] init];
    });
    
    specify(^{
        [[fieldMapping should] respondToSelector:@selector(keyPath)];
    });
    
    specify(^{
        [[fieldMapping should] respondToSelector:@selector(field)];
    });
    
    specify(^{
        [[fieldMapping should] respondToSelector:@selector(dateFormat)];
    });
    
    specify(^{
        [[fieldMapping should] respondToSelector:@selector(valueBlock)];
    });
    
    specify(^{
        [[fieldMapping should] respondToSelector:@selector(reverseBlock)];
    });
    
});

SPEC_END


