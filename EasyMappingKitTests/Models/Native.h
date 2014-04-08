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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Native : NSObject

@property (nonatomic, readwrite) char charProperty;
@property (nonatomic, readwrite) unsigned char unsignedCharProperty;
@property (nonatomic, readwrite) short shortProperty;
@property (nonatomic, readwrite) unsigned short unsignedShortProperty;
@property (nonatomic, readwrite) int intProperty;
@property (nonatomic, readwrite) unsigned int unsignedIntProperty;
@property (nonatomic, readwrite) NSInteger integerProperty;
@property (nonatomic, readwrite) NSUInteger unsignedIntegerProperty;
@property (nonatomic, readwrite) long longProperty;
@property (nonatomic, readwrite) unsigned long unsignedLongProperty;
@property (nonatomic, readwrite) long long longLongProperty;
@property (nonatomic, readwrite) unsigned long long unsignedLongLongProperty;
@property (nonatomic, readwrite) float floatProperty;
@property (nonatomic, readwrite) CGFloat cgFloatProperty;
@property (nonatomic, readwrite) double doubleProperty;
@property (nonatomic, readwrite) BOOL boolProperty;

@end
