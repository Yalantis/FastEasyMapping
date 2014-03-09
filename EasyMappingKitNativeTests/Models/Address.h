//
//  Address.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 26/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Address : NSObject

@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) CLLocation *location;

@end
