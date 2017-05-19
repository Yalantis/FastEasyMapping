// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "Chat+Mapping.h"
#import "ChatMessage+Mapping.h"

@import FastEasyMapping;

@implementation Chat (Mapping)

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:NSStringFromClass(self)];
    mapping.primaryKey = @"primaryKey";
    [mapping addAttributesFromArray:@[@"primaryKey"]];
    
    return mapping;
}

+ (FEMMapping *)recursiveMapping {
    FEMMapping *chat = [self defaultMapping];
    
    FEMMapping *message = [ChatMessage defaultMapping];
    [message addRelationshipMapping:[Chat defaultMapping] forProperty:@"chat" keyPath:@"chat"];
    
    [chat addToManyRelationshipMapping:message forProperty:@"messages" keyPath:@"messages"];
    
    return chat;
}

@end
