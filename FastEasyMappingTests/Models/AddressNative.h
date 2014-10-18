// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AddressNative : NSObject

@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) CLLocation *location;

@end
