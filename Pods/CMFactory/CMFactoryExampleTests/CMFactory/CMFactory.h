//
//  CMFactory.h
//  CMFactoryExample
//
//  Created by Lucas Medeiros on 21/01/13.
//  Copyright (c) 2013 Codeminer42. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMFactory;

typedef id(^CMValueBlock)(void);
typedef id(^CMSequenceValueBlock)(NSUInteger sequence);

@interface CMFactory : NSObject

@property (nonatomic, strong) NSMutableDictionary *fields;

+ (CMFactory *)forClass:(Class) objectClass;

- (void)addToField:(NSString *)field value:(CMValueBlock)valueBlock;
- (void)addToField:(NSString *)field sequenceValue:(CMSequenceValueBlock)valueBlock;
- (id)build;
- (NSArray *)buildWithCapacity:(NSUInteger)capacity;

@end
