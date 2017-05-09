// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMRepresentationUtility.h"
#import "FEMMapping.h"
#import "FEMAttribute.h"

id FEMRepresentationRootForKeyPath(id representation, NSString *keyPath) {
    if (keyPath.length > 0) {
        return [representation valueForKeyPath:keyPath];
    }

    return representation;
}

void _FEMRepresentationCollectPresentedPrimaryKeys(id, FEMMapping *, NSMapTable<FEMMapping *, NSMutableSet<id> *> *);

void _FEMRepresentationCollectObjectPrimaryKeys(id object, FEMMapping *mapping, NSMapTable<FEMMapping *, NSMutableSet<id> *> *container) {
    if (mapping.primaryKeyAttribute) {
        id value = FEMRepresentationValueForAttribute(object, mapping.primaryKeyAttribute);
        if (value && value != NSNull.null) {
            [[container objectForKey:mapping] addObject:value];
        }
    }

    for (FEMRelationship *relationship in mapping.relationships) {
        id relationshipRepresentation = FEMRepresentationRootForKeyPath(object, relationship.keyPath);
        if (relationshipRepresentation && relationshipRepresentation != NSNull.null) {
            _FEMRepresentationCollectPresentedPrimaryKeys(relationshipRepresentation, relationship.mapping, container);
        }
    }
}

void _FEMRepresentationCollectPresentedPrimaryKeys(id representation, FEMMapping *mapping, NSMapTable<FEMMapping *, NSMutableSet<id> *> *container) {
    if ([representation isKindOfClass:[NSArray class]]) {
        for (id object in (id<NSFastEnumeration>)representation) {
            _FEMRepresentationCollectObjectPrimaryKeys(object, mapping, container);
        }
    } else if ([representation isKindOfClass:[NSDictionary class]] || [representation isKindOfClass:[NSNumber class]] || [representation isKindOfClass:[NSString class]]) {
        _FEMRepresentationCollectObjectPrimaryKeys(representation, mapping, container);
    } else {
        NSCAssert(
            NO,
            @"Can not collect primary keys for a given representation.\n"
            "Expected container classes: NSArray, NSDictionary, NSNumber or NSString. Got: %@.\n"
            "Mapping: %@\nRepresentation:%@",
            NSStringFromClass([representation class]), mapping, representation
        );
    }
};

NSMapTable<FEMMapping *, NSSet<id> *> *FEMRepresentationCollectPresentedPrimaryKeys(id representation, FEMMapping *mapping) {
    NSSet<FEMMapping *> *flattenMappings = [mapping flatten];

    NSPointerFunctionsOptions options = NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPointerPersonality;
    NSMapTable *map = [[NSMapTable alloc] initWithKeyOptions:options valueOptions:options capacity:flattenMappings.count];

    for (FEMMapping *key in flattenMappings) {
        [map setObject:[NSMutableSet new] forKey:key];
    }

    id root = FEMRepresentationRootForKeyPath(representation, mapping.rootPath);
    _FEMRepresentationCollectPresentedPrimaryKeys(root, mapping, map);

    return map;
}

id FEMRepresentationValueForAttribute(id representation, FEMAttribute *attribute) {
    id value = attribute.keyPath ? [representation valueForKeyPath:attribute.keyPath] : representation;
    // nil is a valid value for missing keys. therefore attribute is discarded
    if (value != nil) {
        // if by mistake nil returned we still have to map it to the NSNull to indicate missing value
        return [attribute mapValue:value] ?: [NSNull null];
    }

    return value;
}
