//
//  PersonNative.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 21/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CarNative;

typedef enum {
    GenderMale,
    GenderFemale
} Gender;

@interface PersonNative : NSObject

@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *email;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, strong) CarNative *car;
@property (nonatomic, strong) NSArray *phones;

@end
