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
#import "FEMAssignmentPolicy.h"

@class FEMMapping;

@interface FEMRelationshipMapping : NSObject <FEMPropertyMapping>

@property (nonatomic, copy) FEMAssignmentPolicy assignmentPolicy;

@property (nonatomic, strong) FEMMapping *objectMapping;
@property (nonatomic, getter=isToMany) BOOL toMany;

- (void)setObjectMapping:(FEMMapping *)objectMapping forKeyPath:(NSString *)keyPath;

- (instancetype)initWithProperty:(NSString *)property
                         keyPath:(NSString *)keyPath
                assignmentPolicy:(FEMAssignmentPolicy)policy
                   objectMapping:(FEMMapping *)objectMapping;

+ (instancetype)mappingOfProperty:(NSString *)property
                    configuration:(void (^)(FEMRelationshipMapping *mapping))configuration;
+ (instancetype)mappingOfProperty:(NSString *)property
                        toKeyPath:(NSString *)keyPath
                    configuration:(void (^)(FEMRelationshipMapping *mapping))configuration;

/**
* same as + [FEMRelationshipMapping mappingOfProperty:property toKeyPath:nil objectMapping:objectMapping];
*/
+ (instancetype)mappingOfProperty:(NSString *)property objectMapping:(FEMMapping *)objectMapping;
+ (instancetype)mappingOfProperty:(NSString *)property
                        toKeyPath:(NSString *)keyPath
                    objectMapping:(FEMMapping *)objectMapping;

@end

@interface FEMRelationshipMapping (Deprecated)

+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath configuration:(void (^)(FEMRelationshipMapping *mapping))configuration __attribute__((deprecated("use + [FEMRelationshipMapping mappingOfProperty:toKeyPath:configuration:] instead")));
+ (instancetype)mappingOfProperty:(NSString *)property keyPath:(NSString *)keyPath objectMapping:(FEMMapping *)objectMapping __attribute__((deprecated("use + [FEMRelationshipMapping mappingOfProperty:toKeyPath:objectMapping:] instead")));

@end

@interface FEMRelationshipMapping (Extension)

- (id)extractRootFromExternalRepresentation:(id)externalRepresentation;

@end