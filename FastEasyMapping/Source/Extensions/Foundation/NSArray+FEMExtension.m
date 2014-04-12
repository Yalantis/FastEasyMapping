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

#import "NSArray+FEMExtension.h"

@implementation NSArray (FEMExtension)

- (id)ek_propertyRepresentation:(objc_property_t)property {
	id convertedObject = self;
	if (property) {
		NSString *propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
		if ([propertyAttributes length] > 0) {
			if (!NSEqualRanges([propertyAttributes rangeOfString:@"NSSet"], NSMakeRange(NSNotFound, 0))) {
				convertedObject = [NSSet setWithArray:self];
			}
			else if (!NSEqualRanges([propertyAttributes rangeOfString:@"NSMutableSet"], NSMakeRange(NSNotFound, 0))) {
				convertedObject = [[NSSet setWithArray:self] mutableCopy];
			}
			else if (!NSEqualRanges([propertyAttributes rangeOfString:@"NSOrderedSet"], NSMakeRange(NSNotFound, 0))) {
				convertedObject = [NSOrderedSet orderedSetWithArray:self];
			}
			else if (!NSEqualRanges([propertyAttributes rangeOfString:@"NSMutableOrderedSet"], NSMakeRange(NSNotFound, 0))) {
				convertedObject = [[NSOrderedSet orderedSetWithArray:self] mutableCopy];
			}
			else if (!NSEqualRanges([propertyAttributes rangeOfString:@"NSMutableArray"], NSMakeRange(NSNotFound, 0))) {
				convertedObject = [NSMutableArray arrayWithArray:self];
			}
		}
	}
	return convertedObject;
}

@end