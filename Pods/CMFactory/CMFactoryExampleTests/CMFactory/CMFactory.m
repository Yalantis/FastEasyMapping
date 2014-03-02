//
//  CMFactory.m
//  CMFactoryExample
//
//  Created by Lucas Medeiros on 21/01/13.
//  Copyright (c) 2013 Codeminer42. All rights reserved.
//

#import "CMFactory.h"
#import <objc/runtime.h>

@interface CMFactory(){
    Class _factoryClass;
}

@end

@implementation CMFactory

+ (CMFactory *)forClass:(Class)objectClass
{
    CMFactory *factory = [[CMFactory alloc] initWithFactoryClass:objectClass];
    return factory;
}

- (id)initWithFactoryClass:(Class)objectClass
{
    self = [super init];
    if (self) {
        _factoryClass = objectClass;
        _fields = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addToField:(NSString *)field value:(CMValueBlock)valueBlock
{
    if (![self containsFieldNamed:field]) {
        @throw ([NSException exceptionWithName:@"CMFieldNotFoundException" reason:@"The field passed was not found" userInfo:nil]);
    }
    [_fields setObject:valueBlock() forKey:field];
}

- (void)addToField:(NSString *)field sequenceValue:(CMSequenceValueBlock)sequenceBlock
{
    if (![self containsFieldNamed:field]) {
        @throw ([NSException exceptionWithName:@"CMFieldNotFoundException" reason:@"The field passed was not found" userInfo:nil]);
    }
    [_fields setObject:sequenceBlock forKey:field];
}

- (NSArray *)buildWithCapacity:(NSUInteger)capacity
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:capacity];
    for (NSUInteger i = 0 ; i < capacity; i++) {
        
        id instance = [[_factoryClass alloc] init];
        
        for (NSString *key in [self.fields allKeys]) {
            
            id fieldValue = [self.fields objectForKey:key];
            
            if ([fieldValue isKindOfClass:NSClassFromString(@"NSBlock")]) {
                CMSequenceValueBlock block = (CMSequenceValueBlock) fieldValue;
                [instance setValue:block(i) forKey:key];
            } else {
                [instance setValue:fieldValue forKey:key];
            }
            
        }
        
        [array addObject:instance];
    }
    return array;
}

- (id)build
{
    id instance = [[_factoryClass alloc] init];
    
    for (NSString *key in [self.fields allKeys]) {
        [instance setValue:[self.fields objectForKey:key] forKey:key];
    }
    return instance;
}

- (BOOL)containsFieldNamed:(NSString *)fieldName
{
    objc_property_t property = class_getProperty(_factoryClass, [fieldName UTF8String]);
    return property != NULL;
}

@end
