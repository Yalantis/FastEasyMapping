// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Car : NSManagedObject

@property (nonatomic, retain) NSNumber * carID;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSManagedObject *person;

@end
