// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMDeserializer.h"

#import <CoreData/CoreData.h>

#import "FEMManagedObjectMapping.h"
#import "FEMAttributeMapping.h"
#import "FEMTypeIntrospection.h"
#import "NSArray+FEMPropertyRepresentation.h"
#import "FEMDeserializerSource.h"
#import "FEMAttribute+Extension.h"
#import "FEMRelationship.h"
#import "FEMDefaultAssignmentContext.h"
#import "FEMManagedObjectStore.h"

@implementation FEMDeserializer

- (id)initWithDeserializerSource:(id<FEMDeserializerSource>)deserializerSource {
    NSParameterAssert(deserializerSource != nil);
    self = [super init];
    if (self) {
        _source = deserializerSource;
    }

    return self;
}

#pragma mark - Utility

- (id)extractRelationshipRepresentation:(FEMRelationship *)relationship fromExternalRepresentation:(id)externalRepresentation {
    if (relationship.keyPath) return [externalRepresentation valueForKeyPath:relationship.keyPath];
    
    return externalRepresentation;
}

#pragma mark - IMP

- (void)fulfillObjectRelationships:(id)object fromRepresentation:(NSDictionary *)representation usingMapping:(FEMMapping *)mapping {
    for (FEMRelationship *relationship in mapping.relationships) {
        @autoreleasepool {
            id relationshipRepresentation = [self extractRelationshipRepresentation:relationship fromExternalRepresentation:representation];
            if (relationshipRepresentation == nil) continue;

            id targetValue = nil;
            if (relationshipRepresentation != NSNull.null) {
                if (relationship.isToMany) {
                    targetValue = [self collectionFromRepresentation:relationshipRepresentation
                                                        usingMapping:relationship.objectMapping];

                    objc_property_t property = class_getProperty([object class], [relationship.property UTF8String]);
                    targetValue = [targetValue fem_propertyRepresentation:property];
                } else {
                    targetValue = [self objectFromRepresentation:relationshipRepresentation
                                                    usingMapping:relationship.objectMapping];
                }
            }

            id<FEMAssignmentContextPrivate> context = [self.source newAssignmentContext];
            context.destinationObject = object;
            context.relationship = relationship;
            context.sourceRelationshipValue = [object valueForKey:relationship.property];
            context.targetRelationshipValue = targetValue;

            id assignmentValue = relationship.assignmentPolicy(context);
            [object setValue:assignmentValue forKey:relationship.property];
        }
    }
}

- (id)fulfillObject:(id)object fromRepresentation:(NSDictionary *)representation usingMapping:(FEMMapping *)mapping {
    for (FEMAttributeMapping *attributeMapping in mapping.attributes) {
        [attributeMapping setMappedValueToObject:object fromRepresentation:representation];
    }

    [self fulfillObjectRelationships:object fromRepresentation:representation usingMapping:mapping];

    return object;
}

- (id)objectFromRepresentation:(NSDictionary *)representation usingMapping:(FEMMapping *)mapping {
    id object = [self.source registeredObjectForRepresentation:representation mapping:mapping];
    if (!object) {
        object = [self.source newObjectForMapping:mapping];
    }

    [self fulfillObject:object fromRepresentation:representation usingMapping:mapping];

    if ([self.source shouldRegisterObject:object forMapping:mapping]) {
        [self.source registerObject:object forMapping:mapping];
    }

    return object;
}

- (NSArray *)collectionFromRepresentation:(id)representation usingMapping:(FEMMapping *)mapping {
    NSMutableArray *output = [NSMutableArray array];
    for (id objectRepresentation in representation) {
        @autoreleasepool {
            id object = [self objectFromRepresentation:objectRepresentation usingMapping:mapping];
            [output addObject:object];
        }
    }
    return [output copy];
}

#pragma mark - Public

- (id)deserializeObject {
    id representation = [self.source.mapping representationFromExternalRepresentation:self.source.externalRepresentation];
    return [self objectFromRepresentation:representation usingMapping:self.source.mapping];
}

- (id)fulfillObject:(id)object {
    id representation = [self.source.mapping representationFromExternalRepresentation:self.source.externalRepresentation];
    return [self fulfillObject:object fromRepresentation:representation usingMapping:self.source.mapping];
}

- (NSArray *)deserializeCollection {
    id representation = [self.source.mapping representationFromExternalRepresentation:self.source.externalRepresentation];
    return [self collectionFromRepresentation:representation usingMapping:self.source.mapping];
}

#pragma mark - Deserialization

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation
                                 usingMapping:(FEMManagedObjectMapping *)mapping
                                      context:(NSManagedObjectContext *)context {
    FEMManagedObjectStore *source = [[FEMManagedObjectStore alloc] initWithMapping:mapping
                                                                                      externalRepresentation:externalRepresentation
                                                                                        managedObjectContext:context];
    FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithDeserializerSource:source];

    return [deserializer deserializeObject];
}

+ (id)fillObject:(NSManagedObject *)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMManagedObjectMapping *)mapping {
    FEMManagedObjectStore *source = [[FEMManagedObjectStore alloc] initWithMapping:mapping
                                                                                      externalRepresentation:externalRepresentation
                                                                                        managedObjectContext:object.managedObjectContext];
    FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithDeserializerSource:source];

    return [deserializer fulfillObject:object];
}

+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                            usingMapping:(FEMManagedObjectMapping *)mapping
                                                 context:(NSManagedObjectContext *)context {
    FEMManagedObjectStore *source = [[FEMManagedObjectStore alloc] initWithMapping:mapping
                                                                                      externalRepresentation:externalRepresentation
                                                                                        managedObjectContext:context];
    FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithDeserializerSource:source];

    return [deserializer deserializeCollection];
}

+ (NSArray *)synchronizeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                            usingMapping:(FEMManagedObjectMapping *)mapping
                                               predicate:(NSPredicate *)predicate
                                                 context:(NSManagedObjectContext *)context {
//    NSParameterAssert(mapping.primaryKey != nil);
//
//    FEMAttributeMapping *primaryKeyMapping = [mapping primaryKeyMapping];
//
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:mapping.entityName];
//    [request setPredicate:predicate];
//
//    NSArray *initialObjects = [context executeFetchRequest:request error:NULL];
//    NSArray *initialObjectsKeys = [initialObjects valueForKey:primaryKeyMapping.property];
//    NSMutableDictionary *initialObjectsMap = [[NSMutableDictionary alloc] initWithObjects:initialObjects
//                                                                                  forKeys:initialObjectsKeys];
//
//    FEMCache *cache = [[FEMCache alloc] initWithMapping:mapping externalRepresentation:externalRepresentation context:context];
//    FEMCacheSetCurrent(cache);
//    NSArray *output = [self _deserializeCollectionExternalRepresentation:externalRepresentation
//                                                            usingMapping:mapping
//                                                                 context:context];
//    FEMCacheRemoveCurrent();
//
//    NSDictionary *existingObjectsMap = [cache existingObjectsForMapping:mapping];
//    [initialObjectsMap removeObjectsForKeys:existingObjectsMap.allKeys];
//
//    for (NSManagedObject *object in initialObjectsMap.allValues) {
//        [context deleteObject:object];
//    }
//
//    return output;
    return nil;
}

@end