//
// Created by zen on 09/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

@import Foundation;

#import <Realm/RLMObject.h>

@class FEMMapping;

@interface ChildRealmObject : RLMObject

@property (nonatomic) NSInteger identifier;

@end

@interface ChildRealmObject (Mapping)

+ (FEMMapping *)defaultMapping;

@end

RLM_ARRAY_TYPE(ChildRealmObject)