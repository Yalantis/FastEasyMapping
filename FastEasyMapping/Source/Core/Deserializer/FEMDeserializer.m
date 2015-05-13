// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMDeserializer.h"

#import <CoreData/CoreData.h>

#import "FEMManagedObjectMapping.h"
#import "FEMTypeIntrospection.h"
#import "NSArray+FEMPropertyRepresentation.h"
#import "FEMAttribute+Extension.h"
#import "FEMObjectStore.h"
#import "FEMRelationshipAssignmentContext+Internal.h"
#import "FEMRepresentationUtility.h"
#import "FEMManagedObjectStore.h"
#import "FEMObjectMapping.h"

@implementation FEMDeserializer

- (id)initWithStore:(FEMObjectStore *)store {
    NSParameterAssert(store != nil);
    self = [super init];
    if (self) {
        _store = store;
    }

    return self;
}

#pragma mark - Deserialization

- (void)fulfillObjectRelationships:(id)object fromRepresentation:(NSDictionary *)representation usingMapping:(FEMMapping *)mapping {
    for (FEMRelationship *relationship in mapping.relationships) {
        @autoreleasepool {
            id relationshipRepresentation = FEMRepresentationRootForKeyPath(representation, relationship.keyPath);
            if (relationshipRepresentation == nil) continue;

            id targetValue = nil;
            if (relationshipRepresentation != NSNull.null) {
                if (relationship.isToMany) {
                    targetValue = [self _collectionFromRepresentation:relationshipRepresentation mapping:relationship.objectMapping];

                    objc_property_t property = class_getProperty([object class], [relationship.property UTF8String]);
                    targetValue = [targetValue fem_propertyRepresentation:property];
                } else {
                    targetValue = [self _objectFromRepresentation:relationshipRepresentation mapping:relationship.objectMapping];
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

- (id)_fillObject:(id)object fromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping {
    for (FEMAttribute *attribute in mapping.attributes) {
        [attribute setMappedValueToObject:object fromRepresentation:representation];
    }

    [self fulfillObjectRelationships:object fromRepresentation:representation usingMapping:mapping];

    return object;
}

- (id)_objectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping {
    id object = [self.store registeredObjectForRepresentation:representation mapping:mapping];
    if (!object) {
        object = [self.store newObjectForMapping:mapping];
    }

    [self _fillObject:object fromRepresentation:representation mapping:mapping];

    if ([self.store canRegisterObject:object forMapping:mapping]) {
        [self.store registerObject:object forMapping:mapping];
    }

    return object;
}

- (NSArray *)_collectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping {
    NSMutableArray *output = [[NSMutableArray alloc] initWithCapacity:representation.count];
    for (id objectRepresentation in representation) {
        @autoreleasepool {
            id object = [self _objectFromRepresentation:objectRepresentation mapping:mapping];
            [output addObject:object];
        }
    }
    return [output copy];
}

#pragma mark - Public


- (id)objectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping {
    __block id object = nil;
    [self.store performMappingTransaction:@[representation] mapping:mapping transaction:^{
        id root = FEMRepresentationRootForKeyPath(representation, mapping.rootPath);
        object = [self _objectFromRepresentation:root mapping:mapping];
    }];

    return object;
}

- (id)fillObject:(id)object fromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping {
    [self.store performMappingTransaction:@[representation] mapping:mapping transaction:^{
        id root = FEMRepresentationRootForKeyPath(representation, mapping.rootPath);
        [self _fillObject:object fromRepresentation:root mapping:mapping];
    }];

    return object;
}

- (NSArray *)collectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping {
    __block NSArray *objects = nil;
    [self.store performMappingTransaction:representation mapping:mapping transaction:^{
        id root = FEMRepresentationRootForKeyPath(representation, mapping.rootPath);
        objects = [self _collectionFromRepresentation:root mapping:mapping];
    }];

    return objects;
}

@end

@implementation FEMDeserializer (Extension)

+ (id)objectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping context:(NSManagedObjectContext *)context {
    FEMManagedObjectStore *store = [[FEMManagedObjectStore alloc] initWithContext:context];
    FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithStore:store];
    return [deserializer objectFromRepresentation:representation mapping:mapping];
}

+ (id)objectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping {
    FEMObjectStore *store = [[FEMObjectStore alloc] init];
    FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithStore:store];
    return [deserializer objectFromRepresentation:representation mapping:mapping];
}

+ (id)fillObject:(id)object fromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping {
    FEMObjectStore *store = nil;
    if ([object isKindOfClass:NSManagedObject.class]) {
        store = [[FEMManagedObjectStore alloc] initWithContext:[(NSManagedObject *)object managedObjectContext]];
    } else {
        store = [[FEMObjectStore alloc] init];
    }

    FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithStore:store];
    return [deserializer _fillObject:object fromRepresentation:representation mapping:mapping];
};

+ (NSArray *)collectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping context:(NSManagedObjectContext *)context {
    FEMManagedObjectStore *store = [[FEMManagedObjectStore alloc] initWithContext:context];
    FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithStore:store];
    return [deserializer collectionFromRepresentation:representation mapping:mapping];
}

+ (NSArray *)collectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping {
    FEMObjectStore *store = [[FEMObjectStore alloc] init];
    FEMDeserializer *deserializer = [[FEMDeserializer alloc] initWithStore:store];
    return [deserializer collectionFromRepresentation:representation mapping:mapping];
}

@end

@implementation FEMDeserializer (FEMManagedObjectDeserializer_Deprecated)

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMMapping *)mapping context:(NSManagedObjectContext *)context {
    return [self objectFromRepresentation:externalRepresentation mapping:mapping context:context];
}

+ (id)fillObject:(NSManagedObject *)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMMapping *)mapping {
    return [self fillObject:object fromRepresentation:externalRepresentation mapping:mapping];
}

+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation usingMapping:(FEMMapping *)mapping context:(NSManagedObjectContext *)context {
    return [self collectionFromRepresentation:externalRepresentation mapping:mapping context:context];
}

@end

@implementation FEMDeserializer (FEMObjectDeserializer_Deprecated)

+ (id)deserializeObjectExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMMapping *)mapping {
    return [self objectFromRepresentation:externalRepresentation mapping:mapping];
}

+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation usingMapping:(FEMMapping *)mapping {
    return [self fillObject:object fromRepresentation:externalRepresentation mapping:mapping];
}

+ (NSArray *)deserializeCollectionExternalRepresentation:(NSArray *)externalRepresentation usingMapping:(FEMMapping *)mapping {
    return [self collectionFromRepresentation:externalRepresentation mapping:mapping];
}

@end