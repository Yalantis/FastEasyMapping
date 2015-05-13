// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMObjectDeserializer.h"

#import "FEMTypeIntrospection.h"
#import "FEMAttribute.h"
#import <objc/runtime.h>
#import "FEMManagedObjectDeserializer.h"
#import "NSArray+FEMPropertyRepresentation.h"
#import "FEMAttribute+Extension.h"
#import "FEMObjectMapping.h"
#import "FEMRelationship.h"

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
	for (FEMAttribute *attributeMapping in mapping.attributes) {
        [attributeMapping setMappedValueToObject:object fromRepresentation:representation];
	}

	for (FEMRelationship *relationshipMapping in mapping.relationships) {
		id relationshipRepresentation = [relationshipMapping extractRootFromExternalRepresentation:representation];
        if (relationshipRepresentation == nil) continue;

        FEMObjectMapping *objectMapping = (FEMObjectMapping *)relationshipMapping.objectMapping;
        NSAssert(
            [objectMapping isKindOfClass:FEMObjectMapping.class],
            @"%@ expect %@ for %@.objectMapping",
            NSStringFromClass(self),
            NSStringFromClass(FEMObjectMapping.class),
            NSStringFromClass(FEMRelationship.class)
         );

        id targetValue = nil;
        if (relationshipRepresentation != NSNull.null) {
            if (relationshipMapping.isToMany) {
                targetValue = [self deserializeCollectionRepresentation:relationshipRepresentation
                                                                        usingMapping:objectMapping];

                objc_property_t property = class_getProperty([object class], [relationshipMapping.property UTF8String]);
                targetValue = [targetValue fem_propertyRepresentation:property];
            } else {
                targetValue = [self deserializeObjectRepresentation:relationshipRepresentation
                                                                    usingMapping:objectMapping];
            }

        }

        [object setValue:targetValue forKeyPath:relationshipMapping.property];
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