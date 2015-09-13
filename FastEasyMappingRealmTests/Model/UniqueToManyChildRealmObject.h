//
// Created by zen on 13/09/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

@import Foundation;

#import <Realm/RLMObject.h>

@interface UniqueToManyChildRealmObject : RLMObject

@property (nonatomic) NSInteger primaryKey;

@end

RLM_ARRAY_TYPE(UniqueToManyChildRealmObject);