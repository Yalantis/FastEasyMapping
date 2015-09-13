//
// Created by zen on 10/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

@import Foundation;

#import <Realm/RLMObject.h>
#import <Realm/RLMArray.h>
#import <FastEasyMapping/FEMAssignmentPolicy.h>

@protocol UniqueToManyChildRealmObject;
@class UniqueChildRealmObject, FEMMapping;

@interface UniqueRealmObject : RLMObject

@property (nonatomic) int primaryKeyProperty;
@property (nonatomic) long long longLongProperty;
@property (nonatomic, copy) NSString *stringProperty;

@property (nonatomic, strong) UniqueChildRealmObject *toOneRelationship;
@property (nonatomic, strong) RLMArray<UniqueToManyChildRealmObject> *toManyRelationship;

@end

@interface UniqueRealmObject (Mapping)

+ (FEMMapping *)defaultMapping;
+ (FEMMapping *)toOneRelationshipMappingWithPolicy:(FEMAssignmentPolicy)policy;
+ (FEMMapping *)toManyRelationshipMappingWithPolicy:(FEMAssignmentPolicy)policy;

@end