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

#import "EMKObjectDeserializer.h"

#import "EMKPropertyHelper.h"
#import "EMKAttributeMapping.h"
#import <objc/runtime.h>
#import "EMKManagedObjectDeserializer.h"
#import "NSArray+EMKExtension.h"
#import "EMKAttributeMapping+Extension.h"
#import "EMKObjectMapping.h"
#import "EMKRelationshipMapping.h"

@implementation EMKObjectDeserializer

+ (id)deserializeObjectRepresentation:(NSDictionary *)representation usingMapping:(EMKObjectMapping *)mapping {
	id object = [[mapping.objectClass alloc] init];
	return [self fillObject:object fromRepresentation:representation usingMapping:mapping];
}

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(EMKObjectMapping *)mapping {
	NSDictionary *representation = [mapping extractRootFromExternalRepresentation:externalRepresentation];
	return [self deserializeObjectRepresentation:representation usingMapping:mapping];
}

+ (id)fillObject:(id)object fromRepresentation:(NSDictionary *)representation usingMapping:(EMKObjectMapping *)mapping {
	for (EMKAttributeMapping *attributeMapping in mapping.attributeMappings) {
		[attributeMapping mapValueToObject:object fromRepresentation:representation];
	}

	for (EMKRelationshipMapping *relationshipMapping in mapping.relationshipMappings) {
		id deserializedRelationship = nil;
		id relationshipRepresentation = [relationshipMapping extractRootFromExternalRepresentation:representation];

		if (relationshipMapping.isToMany) {
			deserializedRelationship = [self deserializeCollectionRepresentation:relationshipRepresentation
			                                                        usingMapping:relationshipMapping.objectMapping];

			objc_property_t property = class_getProperty([object class], [relationshipMapping.property UTF8String]);
			deserializedRelationship = [deserializedRelationship ek_propertyRepresentation:property];
		} else {
			deserializedRelationship = [self deserializeObjectRepresentation:relationshipRepresentation
			                                                    usingMapping:relationshipMapping.objectMapping];
		}

		if (deserializedRelationship) {
			[object setValue:deserializedRelationship forKeyPath:relationshipMapping.property];
		}
	}

	return object;
}

+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(EMKObjectMapping *)mapping {
	NSDictionary *representation = [mapping extractRootFromExternalRepresentation:externalRepresentation];
	return [self fillObject:object fromRepresentation:representation usingMapping:mapping];
}

+ (NSArray *)deserializeCollectionRepresentation:(NSArray *)representation usingMapping:(EMKObjectMapping *)mapping {
	NSMutableArray *output = [NSMutableArray array];
	for (NSDictionary *objectRepresentation in representation) {
		@autoreleasepool {
			[output addObject:[self deserializeObjectRepresentation:objectRepresentation usingMapping:mapping]];
		}
	}
	return [output copy];
}

+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation usingMapping:(EMKObjectMapping *)mapping {
	NSArray *representation = [mapping extractRootFromExternalRepresentation:externalRepresentation];
	return [self deserializeCollectionRepresentation:representation usingMapping:mapping];
}

@end