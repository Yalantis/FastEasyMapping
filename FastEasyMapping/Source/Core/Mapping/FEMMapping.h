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

@class FEMAttributeMapping, FEMRelationshipMapping;

@interface FEMMapping : NSObject {
    @protected
	NSMutableDictionary *_attributesMap;
	NSMutableDictionary *_relationshipsMap;
}

@property (nonatomic, copy) NSString *rootPath;
- (id)initWithRootPath:(NSString *)rootPath;

@property (nonatomic, strong, readonly) NSArray *attributeMappings;
- (void)addAttributeMapping:(FEMAttributeMapping *)attributeMapping;

- (FEMAttributeMapping *)attributeMappingForProperty:(NSString *)property;

@property (nonatomic, strong, readonly) NSArray *relationshipMappings;
- (void)addRelationshipMapping:(FEMRelationshipMapping *)relationshipMapping;

- (FEMRelationshipMapping *)relationshipMappingForProperty:(NSString *)property;

@end

@interface FEMMapping (Shortcut)

- (void)addAttributeMappingFromArray:(NSArray *)attributes;
- (void)addAttributeMappingDictionary:(NSDictionary *)attributesToKeyPath;
- (void)addAttributeMappingOfProperty:(NSString *)property atKeypath:(NSString *)keypath;

- (void)addRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath;
- (void)addToManyRelationshipMapping:(FEMMapping *)mapping forProperty:(NSString *)property keyPath:(NSString *)keyPath;

- (id)extractRootFromExternalRepresentation:(id)externalRepresentation;

@end