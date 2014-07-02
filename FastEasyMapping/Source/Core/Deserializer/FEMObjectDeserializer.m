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

#import "FEMObjectDeserializer.h"

#import "FEMTypeIntrospection.h"
#import "FEMAttributeMapping.h"
#import <objc/runtime.h>
#import "FEMManagedObjectDeserializer.h"
#import "NSArray+FEMPropertyRepresentation.h"
#import "FEMAttributeMapping+Extension.h"
#import "FEMObjectMapping.h"
#import "FEMRelationshipMapping.h"

@implementation FEMObjectDeserializer

+ (id)deserializeObjectRepresentation:(NSDictionary *)representation usingMapping:(FEMObjectMapping *)mapping {
	id object = [[mapping.objectClass alloc] init];
	return [self fillObject:object fromRepresentation:representation usingMapping:mapping];
}

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMObjectMapping *)mapping {
	NSDictionary *representation = [mapping extractRootFromExternalRepresentation:externalRepresentation];
	return [self deserializeObjectRepresentation:representation usingMapping:mapping];
}

+ (id)fillObject:(id)object fromRepresentation:(NSDictionary *)representation usingMapping:(FEMObjectMapping *)mapping {
	for (FEMAttributeMapping *attributeMapping in mapping.attributeMappings) {
		[attributeMapping mapValueToObject:object fromRepresentation:representation];
	}

	for (FEMRelationshipMapping *relationshipMapping in mapping.relationshipMappings) {
		id deserializedRelationship = nil;
		id relationshipRepresentation = [relationshipMapping extractRootFromExternalRepresentation:representation];
        FEMObjectMapping *objectMapping = (FEMObjectMapping *)relationshipMapping.objectMapping;
        NSAssert(
            [objectMapping isKindOfClass:FEMObjectMapping.class],
            @"%@ expect %@ for %@.objectMapping",
            NSStringFromClass(self),
            NSStringFromClass(FEMObjectMapping.class),
            NSStringFromClass(FEMRelationshipMapping.class)
         );
        
		if (relationshipMapping.isToMany) {
			deserializedRelationship = [self deserializeCollectionRepresentation:relationshipRepresentation
			                                                        usingMapping:objectMapping];

			objc_property_t property = class_getProperty([object class], [relationshipMapping.property UTF8String]);
			deserializedRelationship = [deserializedRelationship fem_propertyRepresentation:property];
		} else {
			deserializedRelationship = [self deserializeObjectRepresentation:relationshipRepresentation
			                                                    usingMapping:objectMapping];
		}

		if (deserializedRelationship) {
			[object setValue:deserializedRelationship forKeyPath:relationshipMapping.property];
		}
	}

	return object;
}

+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMObjectMapping *)mapping {
	NSDictionary *representation = [mapping extractRootFromExternalRepresentation:externalRepresentation];
	return [self fillObject:object fromRepresentation:representation usingMapping:mapping];
}

+ (NSArray *)deserializeCollectionRepresentation:(NSArray *)representation usingMapping:(FEMObjectMapping *)mapping {
	NSMutableArray *output = [NSMutableArray array];
	for (NSDictionary *objectRepresentation in representation) {
		@autoreleasepool {
			[output addObject:[self deserializeObjectRepresentation:objectRepresentation usingMapping:mapping]];
		}
	}
	return [output copy];
}

+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation usingMapping:(FEMObjectMapping *)mapping {
	NSArray *representation = [mapping extractRootFromExternalRepresentation:externalRepresentation];
	return [self deserializeCollectionRepresentation:representation usingMapping:mapping];
}

@end