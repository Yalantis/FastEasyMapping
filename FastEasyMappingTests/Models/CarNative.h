// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

@interface CarNative : NSObject

@property (nonatomic, copy)   NSString *model;
@property (nonatomic, copy)   NSString *year;
@property (nonatomic, strong) NSDate *createdAt;

@end
