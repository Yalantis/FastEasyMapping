// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMManagedObjectDeserializer.h"

#import <CoreData/CoreData.h>

#import "FEMManagedObjectMapping.h"
#import "FEMAttribute.h"
#import "FEMTypeIntrospection.h"
#import "NSArray+FEMPropertyRepresentation.h"
#import "FEMAttribute+Extension.h"
#import "FEMRelationship.h"
#import "FEMCache.h"
#import "FEMAssignmentPolicyMetadata.h"

@implementation FEMManagedObjectDeserializer

#pragma mark - Deserialization

+ (id)_deserializeObjectRepresentation:(NSDictionary *)representation usingMapping:(FEMManagedObjectMapping *)mapping context:(NSManagedObjectContext *)context {
    id object = [FEMCacheGetCurrent() existingObjectForRepresentation:representation mapping:mapping];
    if (!object) {
        object = [NSEntityDescription insertNewObjectForEntityForName:mapping.entityName inManagedObjectContext:context];
    }

    [self _fillObject:object fromRepresentation:representation usingMapping:mapping];

    if ([object isInserted] && mapping.primaryKey) {
        [FEMCacheGetCurrent() addExistingObject:object usingMapping:mapping];
    }

    return object;
}

+ (id)_deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation
                                  usingMapping:(FEMManagedObjectMapping *)mapping
                                       context:(NSManagedObjectContext *)context {
    id objectRepresentation = [mapping extractRootFromExternalRepresentation:externalRepresentation];
    return [self _deserializeObjectRepresentation:objectRepresentation usingMapping:mapping context:context];
}


+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation
                                 usingMapping:(FEMManagedObjectMapping *)mapping
                                      context:(NSManagedObjectContext *)context {
    FEMCache *cache = [[FEMCache alloc] initWithMapping:mapping
                                 externalRepresentation:externalRepresentation
                                                context:context];
    FEMCacheSetCurrent(cache);
    id object = [self _deserializeObjectExternalRepresentation:externalRepresentation usingMapping:mapping context:context];
    FEMCacheRemoveCurrent();

    return object;
}

+ (id)_fillObject:(NSManagedObject *)object fromRepresentation:(NSDictionary *)representation usingMapping:(FEMManagedObjectMapping *)mapping {
    for (FEMAttribute *attributeMapping in mapping.attributes) {
        [attributeMapping setMappedValueToObject:object fromRepresentation:representation];
    }

    NSManagedObjectContext *context = object.managedObjectContext;
    for (FEMRelationship *relationshipMapping in mapping.relationships) {
        id relationshipRepresentation = [relationshipMapping extractRootFromExternalRepresentation:representation];
        // skip missing key
        if (relationshipRepresentation == nil) continue;

        FEMManagedObjectMapping *objectMapping = (FEMManagedObjectMapping *)relationshipMapping.objectMapping;
        NSAssert(
            [objectMapping isKindOfClass:FEMManagedObjectMapping.class],
            @"%@ expect %@ for %@.objectMapping",
            NSStringFromClass(self),
            NSStringFromClass(FEMManagedObjectMapping.class),
            NSStringFromClass(FEMRelationship.class)
        );

        FEMAssignmentPolicyMetadata *metadata = [FEMAssignmentPolicyMetadata new];
        [metadata setContext:context];
        [metadata setExistingValue:[object valueForKey:relationshipMapping.property]];

        if (relationshipRepresentation != NSNull.null) {
            if (relationshipMapping.isToMany) {
                NSArray *targetValue = [self _deserializeCollectionRepresentation:relationshipRepresentation
                                                                     usingMapping:objectMapping
                                                                          context:context];

                objc_property_t property = class_getProperty([object class], [relationshipMapping.property UTF8String]);
                [metadata setTargetValue:[targetValue fem_propertyRepresentation:property]];
            } else {
                id targetValue = [self _deserializeObjectRepresentation:relationshipRepresentation
                                                           usingMapping:objectMapping
                                                                context:context];
                metadata.targetValue = targetValue;
            }
        } else {
            metadata.targetValue = nil;
        }

        [object setValue:relationshipMapping.assignmentPolicy(metadata) forKey:relationshipMapping.property];
    }

    return object;
}

+ (id)fillObject:(NSManagedObject *)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMManagedObjectMapping *)mapping {
    FEMCache *cache = [[FEMCache alloc] initWithMapping:mapping
                                 externalRepresentation:externalRepresentation
                                                context:object.managedObjectContext];
    FEMCacheSetCurrent(cache);

    id objectRepresentation = [mapping extractRootFromExternalRepresentation:externalRepresentation];
    id output = [self _fillObject:object fromRepresentation:objectRepresentation usingMapping:mapping];
    FEMCacheRemoveCurrent();

    return output;
}

+ (NSArray *)_deserializeCollectionRepresentation:(NSArray *)representation
                                     usingMapping:(FEMManagedObjectMapping *)mapping
                                          context:(NSManagedObjectContext *)context {
    NSMutableArray *output = [NSMutableArray array];
    for (id objectRepresentation in representation) {
        @autoreleasepool {
            [output addObject:[self _deserializeObjectRepresentation:objectRepresentation
                                                        usingMapping:mapping
                                                             context:context]];
        }
    }
    return [output copy];
}

+ (NSArray *)_deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                             usingMapping:(FEMManagedObjectMapping *)mapping
                                                  context:(NSManagedObjectContext *)context {
    id representation = [mapping extractRootFromExternalRepresentation:externalRepresentation];
    return [self _deserializeCollectionRepresentation:representation usingMapping:mapping context:context];
}

+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                            usingMapping:(FEMManagedObjectMapping *)mapping
                                                 context:(NSManagedObjectContext *)context {
    FEMCache *cache = [[FEMCache alloc] initWithMapping:mapping
                                 externalRepresentation:externalRepresentation
                                                context:context];
    FEMCacheSetCurrent(cache);
    NSArray *output = [self _deserializeCollectionExternalRepresentation:externalRepresentation
                                                            usingMapping:mapping
                                                                 context:context];
    FEMCacheRemoveCurrent();

    return output;
}

+ (NSArray *)synchronizeCollectionExternalRepresentation:(NSArray *)externalRepresentation
                                            usingMapping:(FEMManagedObjectMapping *)mapping
                                               predicate:(NSPredicate *)predicate
                                                 context:(NSManagedObjectContext *)context {
    NSParameterAssert(mapping.primaryKey != nil);

    FEMAttribute *primaryKeyMapping = [mapping primaryKeyAttribute];

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:mapping.entityName];
    [request setPredicate:predicate];

    NSArray *initialObjects = [context executeFetchRequest:request error:NULL];
    NSArray *initialObjectsKeys = [initialObjects valueForKey:primaryKeyMapping.property];
    NSMutableDictionary *initialObjectsMap = [[NSMutableDictionary alloc] initWithObjects:initialObjects
                                                                                  forKeys:initialObjectsKeys];

    FEMCache *cache = [[FEMCache alloc] initWithMapping:mapping externalRepresentation:externalRepresentation context:context];
    FEMCacheSetCurrent(cache);
    NSArray *output = [self _deserializeCollectionExternalRepresentation:externalRepresentation
                                                            usingMapping:mapping
                                                                 context:context];
    FEMCacheRemoveCurrent();

    NSDictionary *existingObjectsMap = [cache existingObjectsForMapping:mapping];
    [initialObjectsMap removeObjectsForKeys:existingObjectsMap.allKeys];

    for (NSManagedObject *object in initialObjectsMap.allValues) {
        [context deleteObject:object];
    }

    return output;
}

@end