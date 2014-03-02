//
//  CMFactory.h
//  CMFactoryExample
//
//  Created by Lucas Medeiros on 18/01/13.
//  Copyright (c) 2013 Codeminer42. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMFixture : NSObject

+ (id) buildUsingMantleClass:(Class) objectClass fromFixture:(NSString *)fileName;
+ (id) buildUsingFixture:(NSString *)fileName;
+ (NSData *)dataFromFixtureNamed:(NSString *)fixtureName ofType:(NSString *)fixtureType;
+ (NSString *)contentFromFixtureNamed:(NSString *)fixtureName ofType:(NSString *)fixtureType;

@end
