// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSNumber * personID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) Car *car;
@property (nonatomic, retain) NSSet *phones;
@property (nonatomic, retain) NSSet<Person *> *friends;
@property (nonatomic, retain) Person *partner;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addPhonesObject:(NSManagedObject *)value;
- (void)removePhonesObject:(NSManagedObject *)value;
- (void)addPhones:(NSSet *)values;
- (void)removePhones:(NSSet *)values;

- (void)addFriendsObject:(Person *)value;
- (void)removeFriendsObject:(Person *)value;
- (void)addFriends:(NSSet<Person *> *)values;
- (void)removeFriends:(NSSet<Person *> *)values;

@end
