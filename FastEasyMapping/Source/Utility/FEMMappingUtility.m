//
// Created by zen on 14/05/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "FEMMappingUtility.h"
#import "FEMMapping.h"
#import "FEMRepresentationUtility.h"

void FEMMappingApply(FEMMapping *mapping, void (^apply)(FEMMapping *object)) {
    apply(mapping);

    for (FEMRelationship *relationship in mapping.relationships) {
        FEMMappingApply(relationship.objectMapping, apply);
    }
}

NSSet * FEMMappingCollectUsedEntityNames(FEMMapping *mapping) {
    NSMutableSet *output = [[NSMutableSet alloc] init];
    FEMMappingApply(mapping, ^(FEMMapping *object) {
        NSCParameterAssert(mapping.entityName != nil);

        [output addObject:mapping.entityName];
    });

    return output;
}

@implementation FEMMappingUtility

#pragma mark - Primary Keys

- (void)inspectObjectRepresentation:(id)objectRepresentation mapping:(FEMMapping *)mapping {
    if (mapping.primaryKey) {
        FEMAttribute *primaryKeyMapping = mapping.primaryKeyAttribute;
        NSParameterAssert(primaryKeyMapping);

        id primaryKeyValue = [primaryKeyMapping mappedValueFromRepresentation:objectRepresentation];
        if (primaryKeyValue && primaryKeyValue != NSNull.null) {
            [_lookupKeysMap[mapping.entityName] addObject:primaryKeyValue];
        }
    }

    for (FEMRelationship *relationshipMapping in mapping.relationships) {
        id relationshipRepresentation = FEMRepresentationRootForKeyPath(objectRepresentation, relationshipMapping.keyPath);
        if (relationshipRepresentation && relationshipRepresentation != NSNull.null) {
            [self inspectRepresentation:relationshipRepresentation mapping:relationshipMapping.objectMapping];
        }
    }
}

- (void)inspectRepresentation:(id)representation mapping:(FEMMapping *)mapping {
    if ([representation isKindOfClass:NSArray.class]) {
        for (id objectRepresentation in representation) {
            [self inspectObjectRepresentation:objectRepresentation mapping:mapping];
        }
    } else if ([representation isKindOfClass:NSDictionary.class]) {
        [self inspectObjectRepresentation:representation mapping:mapping];
    } else {
        NSAssert(
            NO,
            @"Expected container classes: NSArray, NSDictionary. Got:%@",
            NSStringFromClass([representation class])
        );
    }
}

+ (NSDictionary *)inspectPrimaryKeysFromRepresentation:(NSArray *)representation mapping:(FEMMapping *)mapping {
    NSSet *entityNames = FEMMappingCollectUsedEntityNames(mapping);
    NSMutableDictionary *output = [[NSMutableDictionary alloc] initWithCapacity:entityNames.count];

    for (NSString *name in entityNames) {
        output[name] = [[NSMutableSet alloc] init];
    }

    id root = FEMRepresentationRootForKeyPath(representation, mapping.rootPath);
    [self inspectRepresentation:representation mapping:mapping];

    return output;
}

@end