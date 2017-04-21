// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMTypeIntrospection.h"
#import <objc/runtime.h>

BOOL FEMObjectPropertyTypeIsScalar(id object, NSString *propertyName) {
	objc_property_t property = class_getProperty(object_getClass(object), [propertyName UTF8String]);
	NSString *type = property ? FEMPropertyTypeStringRepresentation(property) : nil;

	if (type.length == 1) {
		switch ([type UTF8String][0]) {
			case _C_ID:
				return NO;

			case _C_BOOL:
			case _C_BFLD:          // BOOL
			case _C_CHR:
			case _C_UCHR:           // char, unsigned char
			case _C_SHT:
			case _C_USHT:           // short, unsigned short
			case _C_INT:
			case _C_UINT:           // int, unsigned int, NSInteger, NSUInteger
			case _C_LNG:
			case _C_ULNG:           // long, unsigned long
			case _C_LNG_LNG:
			case _C_ULNG_LNG:   // long long, unsigned long long
			case _C_FLT:
			case _C_DBL:            // float, CGFloat, double
				return YES;

			default:
				break;
		}
	}

	return NO;
}

NSString * FEMPropertyTypeStringRepresentation(objc_property_t property) {
	const char *TypeAttribute = "T";
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