// For License please refer to LICENSE file in the root of FastEasyMapping project

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
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) PersonNative *partner;

@end
