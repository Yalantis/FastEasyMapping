//
//  EMKAttributeMapping.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 22/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMKTypes.h"
#import "EMKPropertyMapping.h"

@interface EMKAttributeMapping : NSObject <EMKPropertyMapping>

- (id)mapValue:(id)value;
- (id)reverseMapValue:(id)value;

- (id)initWithProperty:(NSString *)property keyPath:(NSString *)keyPath map:(EMKMapBlock)map reverseMap:(EMKMapBlock)reverseMap;
+ (instancetype)mappingOfProperty:(NSString *)field keyPath:(NSString *)keyPath map:(EMKMapBlock)map reverseMap:(EMKMapBlock)reverseMap;

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath map:(EMKMapBlock)map;
+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath;
+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath dateFormat:(NSString *)dateFormat;

@end