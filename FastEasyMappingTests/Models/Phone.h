// For License please refer to LICENSE file in the root of FastEasyMapping project

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
