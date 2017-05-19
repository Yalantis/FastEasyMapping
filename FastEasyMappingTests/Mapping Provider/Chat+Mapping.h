// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "Chat+CoreDataClass.h"

@class FEMMapping;

@interface Chat (Mapping)

+ (FEMMapping *)defaultMapping;
+ (FEMMapping *)chatLastMessageMapping;
+ (FEMMapping *)chatMessagesMapping;

@end
