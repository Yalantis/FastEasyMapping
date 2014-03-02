//
//  Phone.h
//  EasyMappingCoreDataExample
//
//  Created by Alejandro Isaza on 2013-03-14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface Phone : NSManagedObject

@property (nonatomic, retain) NSNumber * phoneID;
@property (nonatomic, retain) NSString * ddi;
@property (nonatomic, retain) NSString * ddd;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) Person *person;

@end
