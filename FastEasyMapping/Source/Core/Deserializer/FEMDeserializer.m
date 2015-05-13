// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMDeserializer.h"

@import CoreData;

#import "FEMManagedObjectMapping.h"
#import "FEMTypeIntrospection.h"
#import "NSArray+FEMPropertyRepresentation.h"
#import "FEMAttribute+Extension.h"
#import "FEMObjectStore.h"
#import "FEMRelationshipAssignmentContext+Internal.h"
#import "FEMRepresentationUtility.h"

@implementation FEMDeserializer

- (id)initWithStore:(FEMObjectStore *)store {
    NSParameterAssert(store != nil);
    self = [super init];
    if (self) {
        _store = store;
    }

    return self;
}

#pragma mark - Deserialization IMP

- (void)fulfillObjectRelationships:(id)object fromRepresentation:(NSDictionary *)representation usingMapping:(FEMMapping *)mapping {
    for (FEMRelationship *relationship in mapping.relationships) {
        @autoreleasepool {
            id relationshipRepresentation = FEMRepresentationRootForKeyPath(representation, relationship.keyPath);
            if (relationshipRepresentation == nil) continue;

            id targetValue = nil;
            if (relationshipRepresentation != NSNull.null) {
                if (relationship.isToMany) {
                    targetValue = [self collectionFromRepresentation:relationshipRepresentation mapping:relationship.objectMapping];

                    objc_property_t property = class_getProperty([object class], [relationship.property UTF8String]);
                    targetValue = [targetValue fem_propertyRepresentation:property];
                } else {
                    targetValue = [self objectFromRepresentation:relationshipRepresentation mapping:relationship.objectMapping];
                }
            }

            FEMRelationshipAssignmentContext *context = [self.store newAssignmentContext];
            context.destinationObject = object;
            context.relationship = relationship;
            context.sourceRelationshipValue = [object valueForKey:relationship.property];
            context.targetRelationshipValue = targetValue;

            id assignmentValue = relationship.assignmentPolicy(context);
            [object setValue:assignmentValue forKey:relationship.property];
        }
    }
}

- (id)fulfillObject:(id)object fromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping {
    for (FEMAttributeMapping *attributeMapping in mapping.attributes) {
        [attributeMapping setMappedValueToObject:object fromRepresentation:representation];
    }

    [self fulfillObjectRelationships:object fromRepresentation:representation usingMapping:mapping];

    return object;
}

- (id)objectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping {
    id object = [self.store registeredObjectForRepresentation:representation mapping:mapping];
    if (!object) {
        object = [self.store newObjectForMapping:mapping];
    }

    [self fulfillObject:object fromRepresentation:representation mapping:mapping];

    if ([self.store canRegisterObject:object forMapping:mapping]) {
        [self.store registerObject:object forMapping:mapping];
    }

    return object;
}

- (NSArray *)collectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping {
    NSMutableArray *output = [[NSMutableArray alloc] initWithCapacity:representation.count];
    for (id objectRepresentation in representation) {
        @autoreleasepool {
            id object = [self objectFromRepresentation:objectRepresentation mapping:mapping];
            [output addObject:object];
        }
    }
    return [output copy];
}

#pragma mark - Public


- (id)deserializeObjectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping {
    __block id object = nil;
    [self.store performMappingTransaction:@[representation] mapping:mapping transaction:^{
        id root = FEMRepresentationRootForKeyPath(representation, mapping.rootPath);
        object = [self objectFromRepresentation:root mapping:mapping];
    }];

    return object;
}

- (id)fillObject:(id)object fromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping {
    [self.store performMappingTransaction:@[representation] mapping:mapping transaction:^{
        id root = FEMRepresentationRootForKeyPath(representation, mapping.rootPath);
        [self fulfillObject:object fromRepresentation:root mapping:mapping];
    }];

    return object;
}

- (NSArray *)deserializeCollectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping {
    __block NSArray *objects = nil;
    [self.store performMappingTransaction:representation mapping:mapping transaction:^{
        id root = FEMRepresentationRootForKeyPath(representation, mapping.rootPath);
        objects = [self collectionFromRepresentation:root mapping:mapping];
    }];

    return objects;
}

@end

@implementation FEMDeserializer (Shortcut)

//+ (id)deserializeObjectFromRepresentation:(NSDictionary *)representation
//                                  mapping:(FEMMapping *)mapping
//                                  context:(NSManagedObjectContext *)context {
//    FEMManagedObjectStore *source = [[FEMManagedObjectStore alloc] initWithContext:context];
//    FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithStore:source];
//
//    return [deserializer deserializeObject];
//}
//
//+ (id)fillObject:(NSManagedObject *)object fromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping {
//    FEMManagedObjectStore *source = [[FEMManagedObjectStore alloc] initWithContext:object.managedObjectContext];
//    FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithStore:source];
//
//    return [deserializer fulfillObject:object];
//}
//
//+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation
//                                            usingMapping:(FEMManagedObjectMapping *)mapping
//                                                 context:(NSManagedObjectContext *)context {
//    FEMManagedObjectStore *source = [[FEMManagedObjectStore alloc] initWithContext:context];
//    FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithStore:source];
//
//    return [deserializer deserializeCollection];
//}
//
//+ (NSArray *)synchronizeCollectionExternalRepresentation:(NSArray *)externalRepresentation
//                                            usingMapping:(FEMManagedObjectMapping *)mapping
//                                               predicate:(NSPredicate *)predicate
//                                                 context:(NSManagedObjectContext *)context {
////    NSParameterAssert(mapping.primaryKey != nil);
////
////    FEMAttributeMapping *primaryKeyMapping = [mapping primaryKeyMapping];
////
////    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:mapping.entityName];
////    [request setPredicate:predicate];
////
////    NSArray *initialObjects = [context executeFetchRequest:request error:NULL];
////    NSArray *initialObjectsKeys = [initialObjects valueForKey:primaryKeyMapping.property];
////    NSMutableDictionary *initialObjectsMap = [[NSMutableDictionary alloc] initWithObjects:initialObjects
////                                                                                  forKeys:initialObjectsKeys];
////
////    FEMManagedObjectCache *cache = [[FEMManagedObjectCache alloc] initWithMapping:mapping externalRepresentation:externalRepresentation context:context];
////    FEMCacheSetCurrent(cache);
////    NSArray *output = [self _deserializeCollectionExternalRepresentation:externalRepresentation
////                                                            usingMapping:mapping
////                                                                 context:context];
////    FEMCacheRemoveCurrent();
////
////    NSDictionary *existingObjectsMap = [cache existingObjectsForMapping:mapping];
////    [initialObjectsMap removeObjectsForKeys:existingObjectsMap.allKeys];
////
////    for (NSManagedObject *object in initialObjectsMap.allValues) {
////        [context deleteObject:object];
////    }
////
////    return output;
//    return nil;
//}

@end