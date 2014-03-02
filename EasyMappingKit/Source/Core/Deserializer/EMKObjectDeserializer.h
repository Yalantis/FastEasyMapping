//
//  EMKObjectDeserializer.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 21/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "EMKDeserializer.h"

@class EMKObjectMapping;

@interface EMKObjectDeserializer : EMKDeserializer

+ (id)deserializeObjectRepresentation:(NSDictionary *)externalRepresentation
                         usingMapping:(EMKObjectMapping *)mapping;

+ (id)fillObject:(id)object fromRepresentation:(NSDictionary *)representation usingMapping:(EMKObjectMapping *)mapping;

+ (NSArray *)deserializeCollectionRepresentation:(NSArray *)externalRepresentation usingMapping:(EMKObjectMapping *)mapping;


@end