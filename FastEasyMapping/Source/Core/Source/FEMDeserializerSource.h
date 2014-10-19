//
// Created by zen on 19/10/14.
// Copyright (c) 2014 Yalantis. All rights reserved.
//

@import Foundation;

@class FEMMapping, FEMDeserializer;

@protocol FEMDeserializerSource <NSObject>

@required
- (id)registeredObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping;
- (void)registerObject:(id)object forMapping:(FEMMapping *)mapping;
- (NSDictionary *)registeredObjectsForMapping:(FEMMapping *)mapping;

@optional
- (void)prepareForDeserializationOfExternalRepresentation:(id)externalRepresentation deserializer:(FEMDeserializer *)deserializer;

@end