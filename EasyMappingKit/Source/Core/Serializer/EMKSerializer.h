//
//  EMKSerializer.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 25/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMKMapping.h"
#import "EMKSerializer.h"

@interface EMKSerializer : NSObject

+ (NSDictionary *)serializeObject:(id)object usingMapping:(EMKMapping *)mapping;
+ (id)serializeCollection:(NSArray *)collection usingMapping:(EMKMapping *)mapping;

@end
