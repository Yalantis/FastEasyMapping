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

#import "NSObject+FEMKVC.h"
#import <objc/runtime.h>

@implementation NSObject (FEMKVC)

- (char *)emk_classNameForProperty:(NSString *)key {
    char *className = "";
    objc_property_t property = class_getProperty(object_getClass(self), [key UTF8String]);
    char *type = property_copyAttributeValue(property, "T");
    if (strlen(type)>3) {
        className = strndup(type+2, strlen(type)-3);
    }
    free(type);
    return className;
}

static char * const classTypeString = "NSString";
static char * const classTypeNumber = "NSNumber";

- (BOOL)emk_propertyIsString:(NSString *)key {
    return (strcmp([self emk_classNameForProperty:key],classTypeString) == 0);
}

- (BOOL)emk_propertyIsNumber:(NSString *)key {
    return (strcmp([self emk_classNameForProperty:key],classTypeNumber) == 0);
}

- (void)emk_setValueIfDifferent:(id)value forKey:(NSString *)key {
    
	id _value = [self valueForKey:key];
    
    if ([value isKindOfClass:NSNumber.class] && [self emk_propertyIsString:key]) {
        value = [(NSNumber *)value stringValue];
    } else if ([value isKindOfClass:NSString.class] && [self emk_propertyIsNumber:key]) {
        //value = [[NSNumberFormatter new] numberFromString:value];
        value = @([(NSString *)value floatValue]);
    }

	if (_value != value && ![_value isEqual:value]) {
		[self setValue:value forKey:key];
	}
}

@end
