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

#import <Foundation/Foundation.h>

#import "FEMPropertyMapping.h"
#import "FEMTypes.h"

@interface FEMAttributeMapping : NSObject <FEMPropertyMapping>

- (id)mapValue:(id)value;
- (id)reverseMapValue:(id)value;

- (id)initWithProperty:(NSString *)property keyPath:(NSString *)keyPath map:(FEMMapBlock)map reverseMap:(FEMMapBlock)reverseMap;
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath map:(FEMMapBlock)map reverseMap:(FEMMapBlock)reverseMap;

/**
* same as +[FEMAttributeMapping mappingOfProperty:property toKeyPath:property];
*/
+ (instancetype)mappingOfProperty:(NSString *)property;

/**
* same as +[FEMAttributeMapping mappingOfProperty:property toKeyPath:nil map:NULL];
*/
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath;

/**
* same as +[FEMAttributeMapping mappingOfProperty:property toKeyPath:nil map:NULL reverseMap:NULL];
*/
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath map:(FEMMapBlock)map;

/**
* create mapping object, based on NSDateFormatter.
* NSDateFormatter instance uses en_US_POSIX locale and Timezone with name "Europe/London"
*/
+ (instancetype)mappingOfProperty:(NSString *)property toKeyPath:(NSString *)keyPath dateFormat:(NSString *)dateFormat;

@end

@interface FEMAttributeMapping (Deprecated)

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath __attribute__((deprecated("use +[FEMAttributeMapping mappingOfProperty:toKeyPath: instead")));
+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath map:(FEMMapBlock)map __attribute__((deprecated("use +[FEMAttributeMapping mappingOfProperty:toKeyPath:map: instead")));
+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath dateFormat:(NSString *)dateFormat __attribute__((deprecated("use +[FEMAttributeMapping mappingOfProperty:toKeyPath:dateFormat: instead")));
+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath map:(FEMMapBlock)map reverseMap:(FEMMapBlock)reverseMap __attribute__((deprecated("use +[FEMAttributeMapping mappingOfProperty:toKeyPath:reverseMap: instead")));

@end