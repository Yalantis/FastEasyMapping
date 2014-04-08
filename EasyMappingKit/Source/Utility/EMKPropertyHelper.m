//
//  EMKPropertyHelper.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 26/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "EMKPropertyHelper.h"
#import <objc/runtime.h>

static const unichar nativeTypes[] = {
    _C_BOOL, _C_BFLD,          // BOOL
    _C_CHR, _C_UCHR,           // char, unsigned char
    _C_SHT, _C_USHT,           // short, unsigned short
    _C_INT, _C_UINT,           // int, unsigned int, NSInteger, NSUInteger
    _C_LNG, _C_ULNG,           // long, unsigned long
    _C_LNG_LNG, _C_ULNG_LNG,   // long long, unsigned long long
    _C_FLT, _C_DBL             // float, CGFloat, double
};

static NSString * getPropertyType(objc_property_t property);
static id getPrimitiveReturnValueFromInvocation(NSInvocation * invocation);


@implementation EMKPropertyHelper


+ (id)performSelector:(SEL)selector onObject:(id)object
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSString *propertyName = NSStringFromSelector(selector);
    if ([self propertyNameIsNative:propertyName fromObject:object]) {
        return [self performNativeSelector:selector onObject:object];
    } else {
        return [object performSelector:selector];
    }
#pragma clang diagnostic pop
}

+ (id)performNativeSelector:(SEL)selector onObject:(id)object
{
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:object];
    [invocation invoke];
    return getPrimitiveReturnValueFromInvocation(invocation);
}

+ (BOOL)propertyNameIsNative:(NSString *)propertyName fromObject:(id)object
{
    NSString *typeDescription = [self getPropertyTypeFromObject:object withPropertyName:propertyName];
    
    if (typeDescription.length == 1) {
        unichar propertyType = [typeDescription characterAtIndex:0];
        for (int i = 0; i < sizeof(nativeTypes); i++) {
            if (nativeTypes[i] == propertyType) {
                return YES;
            }
        }
    }
    
    return NO;
}

+ (NSString *)getPropertyTypeFromObject:(id)object withPropertyName:(NSString *)propertyString
{
    NSString *propertyType = nil;
    Class baseClass = [NSObject class];
    Class currentClass = [object class];
    
    while (currentClass && currentClass != baseClass && !propertyType) {
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList(currentClass, &outCount);
        
        for (unsigned int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            
            if (propName) {
                NSString *propertyName = [[NSString alloc] initWithCString:propName encoding:NSUTF8StringEncoding];
                if ([propertyName isEqualToString:propertyString]) {
                    propertyType = getPropertyType(property);
                    break;
                }
            }
        }
        
        free(properties);
        currentClass = class_getSuperclass(currentClass);
    }
    
    return propertyType;
}

static NSString * getPropertyType(objc_property_t property) {
	const char * TypeAttribute = "T";
	char *type = property_copyAttributeValue(property, TypeAttribute);
	NSString *propertyType = (type[0] != _C_ID) ? @(type) : ({
		(type[1] == 0) ? @"id" : ({
			// Modern format of a type attribute (e.g. @"NSSet")
			type[strlen(type) - 1] = 0;
			@(type + 2);
		});
	});
	free(type);
	return propertyType;
}

#define EMKInvocationReturnValueOfType(invocation, type) ({         \
	type result;                                                    \
	[invocation getReturnValue:&result];                            \
	@(result);                                                      \
})

static id getPrimitiveReturnValueFromInvocation(NSInvocation * invocation) {
	const char *type = [[invocation methodSignature] methodReturnType];
	switch (type[0]) {
		case _C_CHR:
			return EMKInvocationReturnValueOfType(invocation, char);
		case _C_UCHR:
			return EMKInvocationReturnValueOfType(invocation, unsigned char);
		case _C_BOOL:
			return EMKInvocationReturnValueOfType(invocation, BOOL);
		case _C_SHT:
			return EMKInvocationReturnValueOfType(invocation, short);
		case _C_USHT:
			return EMKInvocationReturnValueOfType(invocation, unsigned short);
		case _C_INT:
			return EMKInvocationReturnValueOfType(invocation, int);
		case _C_UINT:
			return EMKInvocationReturnValueOfType(invocation, unsigned int);
		case _C_LNG:
			return EMKInvocationReturnValueOfType(invocation, long);
		case _C_ULNG:
			return EMKInvocationReturnValueOfType(invocation, unsigned long);
		case _C_LNG_LNG:
			return EMKInvocationReturnValueOfType(invocation, long long);
		case _C_ULNG_LNG:
			return EMKInvocationReturnValueOfType(invocation, unsigned long long);
		case _C_FLT:
			return EMKInvocationReturnValueOfType(invocation, float);
		case _C_DBL:
			return EMKInvocationReturnValueOfType(invocation, double);
		default:
			return nil;
	}
}

@end
