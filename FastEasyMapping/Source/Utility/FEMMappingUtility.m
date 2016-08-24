// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "FEMMappingUtility.h"
#import "FEMMapping.h"

void FEMMappingApply(FEMMapping *mapping, void (^apply)(FEMMapping *object)) {
    apply(mapping);

    for (FEMRelationship *relationship in mapping.relationships) {
        if (![relationship.mapping isEqual:mapping]) {
            FEMMappingApply(relationship.mapping, apply);
        }
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