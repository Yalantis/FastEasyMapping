//
// Created by zen on 14/05/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "FEMMappingUtility.h"
#import "FEMMapping.h"
#import "FEMAttribute.h"

void FEMMappingApply(FEMMapping *mapping, void (^apply)(FEMMapping *object)) {
    apply(mapping);

    for (FEMRelationship *relationship in mapping.relationships) {
        FEMMappingApply(relationship.mapping, apply);
    }
}

NSSet * FEMMappingCollectUsedEntityNames(FEMMapping *mapping) {
    NSMutableSet *output = [[NSMutableSet alloc] init];
    FEMMappingApply(mapping, ^(FEMMapping *object) {
        NSCParameterAssert(object.entityName != nil);

        [output addObject:object.entityName];
    });

    return output;
}

id FEMAttributeMappedValueFromRepresentation(FEMAttribute *attribute, id representation) {
    id value = attribute.keyPath ? [representation valueForKeyPath:attribute.keyPath] : representation;
    return [attribute mapValue:value];
}