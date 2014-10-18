// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Native : NSObject

@property (nonatomic, readwrite) char charProperty;
@property (nonatomic, readwrite) unsigned char unsignedCharProperty;
@property (nonatomic, readwrite) short shortProperty;
@property (nonatomic, readwrite) unsigned short unsignedShortProperty;
@property (nonatomic, readwrite) int intProperty;
@property (nonatomic, readwrite) unsigned int unsignedIntProperty;
@property (nonatomic, readwrite) NSInteger integerProperty;
@property (nonatomic, readwrite) NSUInteger unsignedIntegerProperty;
@property (nonatomic, readwrite) long longProperty;
@property (nonatomic, readwrite) unsigned long unsignedLongProperty;
@property (nonatomic, readwrite) long long longLongProperty;
@property (nonatomic, readwrite) unsigned long long unsignedLongLongProperty;
@property (nonatomic, readwrite) float floatProperty;
@property (nonatomic, readwrite) CGFloat cgFloatProperty;
@property (nonatomic, readwrite) double doubleProperty;
@property (nonatomic, readwrite) BOOL boolProperty;

@end
