//
// Created by zen on 08/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

#import <Realm/RLMObject.h>
#import "ChildRealmObject.h"

@class FEMMapping;
@class RLMArray;

@interface RealmObject : RLMObject

@property (nonatomic) BOOL boolProperty;
@property (nonatomic) bool booleanProperty;
@property (nonatomic) int intProperty;
@property (nonatomic) NSInteger integerProperty;
@property (nonatomic) long longProperty;
@property (nonatomic) long long longLongProperty;
@property (nonatomic) float floatProperty;
@property (nonatomic) double doubleProperty;
@property (nonatomic) CGFloat cgFloatProperty;

@property (nonatomic, copy) NSString *stringProperty;
@property (nonatomic, strong) NSDate *dateProperty;
@property (nonatomic, strong) NSData *dataProperty;

@property (nonatomic, strong) ChildRealmObject *toOneRelationship;
@property RLMArray<ChildRealmObject> *toManyRelationship;

@end


@interface RealmObject (Mapping)

+ (FEMMapping *)supportedTypesMapping;
+ (FEMMapping *)supportedNullableTypesMapping;
+ (FEMMapping *)toOneRelationshipMapping;
+ (FEMMapping *)toManyRelationshipMapping;

@end


//Realm supports the following property types: BOOL, bool, int, NSInteger, long, long long, float, double, CGFloat, NSString, NSDate truncated to the second, and NSData.
//
//You can use RLMArray<Object *><Object> and RLMObject subclasses to model relationships such as to-many and to-one.