// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMDeserializer.h"

#import <CoreData/CoreData.h>

#import "FEMTypeIntrospection.h"
#import "NSArray+FEMPropertyRepresentation.h"
#import "FEMObjectStore.h"
#import "FEMRelationshipAssignmentContext+Internal.h"
#import "FEMRepresentationUtility.h"
#import "FEMManagedObjectStore.h"

@implementation FEMDeserializer {
    struct {
        BOOL willMapObject: 1;
        BOOL didMapObject: 1;
        BOOL willMapCollection: 1;
        BOOL didMapCollection: 1;
    } _delegateFlags;
}

#pragma mark - Init

- (id)initWithStore:(FEMObjectStore *)store {
    NSParameterAssert(store != nil);
    self = [super init];
    if (self) {
        _store = store;
    }

    return self;
}

- (nonnull instancetype)init {
    return [self initWithStore:[[FEMObjectStore alloc] init]];
}

- (nonnull instancetype)initWithContext:(NSManagedObjectContext *)context {
    return [self initWithStore:[[FEMManagedObjectStore alloc] initWithContext:context]];
}

#pragma mark - Delegate

- (void)setDelegate:(id <FEMDeserializerDelegate>)delegate {
    _delegate = delegate;

    _delegateFlags.willMapObject = [_delegate respondsToSelector:@selector(deserializer:willMapObjectFromRepresentation:mapping:)];
    _delegateFlags.didMapObject = [_delegate respondsToSelector:@selector(deserializer:didMapObject:fromRepresentation:mapping:)];
    _delegateFlags.willMapCollection = [_delegate respondsToSelector:@selector(deserializer:willMapCollectionFromRepresentation:mapping:)];
    _delegateFlags.didMapCollection = [_delegate respondsToSelector:@selector(deserializer:didMapCollection:fromRepresentation:mapping:)];
}

#pragma mark - Deserialization

- (void)applyAttributesToObject:(id)object representation:(NSDictionary *)representation mapping:(FEMMapping *)mapping allocated:(BOOL)allocated {
    for (FEMAttribute *attribute in mapping.attributes) {
        id newValue = FEMRepresentationValueForAttribute(representation, attribute);
        if (newValue == NSNull.null) {
            if (!FEMObjectPropertyTypeIsScalar(object, attribute.property)) {
                [object setValue:nil forKey:attribute.property];
            }
        } else if (allocated && newValue) {
            [object setValue:newValue forKey:attribute.property];
        } else if (newValue) {
            id oldValue = [object valueForKey:attribute.property];
            
            if (oldValue != newValue && ![oldValue isEqual:newValue]) {
                [object setValue:newValue forKey:attribute.property];
            }
        }
    }
}

- (void)applyRelationshipsToObject:(id)object representation:(NSDictionary *)representation mapping:(FEMMapping *)mapping {
    for (FEMRelationship *relationship in mapping.relationships) {
        @autoreleasepool {
            id relationshipRepresentation = FEMRepresentationRootForKeyPath(representation, relationship.keyPath);
            if (relationshipRepresentation == nil) continue;
            
            id targetValue = nil;
            if (relationshipRepresentation != NSNull.null) {
                if (relationship.isToMany) {
                    targetValue = [self _collectionFromRepresentation:relationshipRepresentation
                                                              mapping:relationship.mapping
                                                     allocateIfNeeded:!relationship.weak];
                    
                    objc_property_t property = class_getProperty([object class], [relationship.property UTF8String]);
                    targetValue = [targetValue fem_propertyRepresentation:property];
                } else {
                    targetValue = [self _objectFromRepresentation:relationshipRepresentation
                                                          mapping:relationship.mapping
                                                 allocateIfNeeded:!relationship.weak];
                }
            }
            
            if (relationship.assignmentPolicy != FEMAssignmentPolicyAssign) {
                FEMRelationshipAssignmentContext *context = [self.store newAssignmentContext];
                context.destinationObject = object;
                context.relationship = relationship;
                context.sourceRelationshipValue = [object valueForKey:relationship.property];
                context.targetRelationshipValue = targetValue;
                
                id assignmentValue = relationship.assignmentPolicy(context);
                [object setValue:assignmentValue forKey:relationship.property];
            } else {
                [object setValue:targetValue forKey:relationship.property];
            }
        }
    }
}

- (id)_objectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping allocateIfNeeded:(BOOL)allocateIfNeeded {
    id object = nil;
    id primaryKey = nil;

    FEMAttribute *primaryKeyAttribute = mapping.primaryKeyAttribute;
    if (primaryKeyAttribute) {
        primaryKey = FEMRepresentationValueForAttribute(representation, primaryKeyAttribute);
        if (primaryKey != nil && primaryKey != [NSNull null]) {
            object = [self.store objectForPrimaryKey:primaryKey mapping:mapping];
        }
    }

    BOOL allocated = NO;
    if (!object && allocateIfNeeded) {
        object = [self.store newObjectForMapping:mapping];
        allocated = YES;
    }
    
    if (!object) {
        return nil;
    }

    if (_delegateFlags.willMapObject) {
        [self.delegate deserializer:self willMapObjectFromRepresentation:representation mapping:mapping];
    }

    [self applyAttributesToObject:object representation:representation mapping:mapping allocated:allocated];

    if (allocated) {
        [self.store addObject:object forPrimaryKey:primaryKey mapping:mapping];
    }

    [self applyRelationshipsToObject:object representation:representation mapping:mapping];

    if (_delegateFlags.didMapObject) {
        [self.delegate deserializer:self didMapObject:object fromRepresentation:representation mapping:mapping];
    }

    return object;
}

- (NSArray *)_collectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping allocateIfNeeded:(BOOL)allocateIfNeeded {
    if (_delegateFlags.willMapCollection) {
        [self.delegate deserializer:self willMapCollectionFromRepresentation:representation mapping:mapping];
    }

    NSMutableArray *output = [[NSMutableArray alloc] initWithCapacity:representation.count];
    for (id objectRepresentation in representation) {
        @autoreleasepool {
            id object = [self _objectFromRepresentation:objectRepresentation mapping:mapping allocateIfNeeded:allocateIfNeeded];
            [output addObject:object];
        }
    }

    if (_delegateFlags.didMapCollection) {
        [self.delegate deserializer:self didMapCollection:output fromRepresentation:representation mapping:mapping];
    }

    return output;
}

- (void)beginTransactionForMapping:(FEMMapping *)mapping representation:(NSArray<id> *)representation {
    NSDictionary<NSNumber *, NSSet<id> *> *presentedPrimaryKeys = nil;
    if ([[self.store class] requiresPrefetch]) {
        presentedPrimaryKeys = FEMRepresentationCollectPresentedPrimaryKeys(representation, mapping);
    }

    [self.store beginTransaction:presentedPrimaryKeys];
}

- (void)commitTransaction {
    [self.store commitTransaction];
}

#pragma mark - Public

- (id)objectFromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping {
    [self beginTransactionForMapping:mapping representation:@[representation]];

    id root = FEMRepresentationRootForKeyPath(representation, mapping.rootPath);
    id object = [self _objectFromRepresentation:root mapping:mapping allocateIfNeeded:YES];

    [self.store commitTransaction];

    return object;
}

- (id)fillObject:(id)object fromRepresentation:(NSDictionary *)representation mapping:(FEMMapping *)mapping {
    if (_delegateFlags.willMapObject) {
        [self.delegate deserializer:self willMapObjectFromRepresentation:representation mapping:mapping];
    }

    [self beginTransactionForMapping:mapping representation:@[representation]];

    id root = FEMRepresentationRootForKeyPath(representation, mapping.rootPath);

    [self applyAttributesToObject:object representation:root mapping:mapping allocated:NO];
    [self applyRelationshipsToObject:object representation:root mapping:mapping];

    [self commitTransaction];

    if (_delegateFlags.didMapObject) {
        [self.delegate deserializer:self didMapObject:object fromRepresentation:representation mapping:mapping];
    }

    return object;
}

- (NSArray *)collectionFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping {
    [self beginTransactionForMapping:mapping representation:representation];

    id root = FEMRepresentationRootForKeyPath(representation, mapping.rootPath);
    NSArray *objects = [self _collectionFromRepresentation:root mapping:mapping allocateIfNeeded:YES];

    [self commitTransaction];

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
    return [deserializer fillObject:object fromRepresentation:representation mapping:mapping];
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
