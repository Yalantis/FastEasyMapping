//
//  CMFactory.m
//  CMFactoryExample
//
//  Created by Lucas Medeiros on 18/01/13.
//  Copyright (c) 2013 Codeminer42. All rights reserved.
//

#import "CMFixture.h"
#import "Mantle.h"
#import "SBJSON.h"

@implementation CMFixture

+ (id)buildUsingMantleClass:(Class)objectClass fromFixture:(NSString *)fileName
{
    [self checkIfClassIsSubclassOfMTlModel:objectClass];
    [self checkIfAnyFileWithNameExists:fileName];
    return [self instanceOfClass:objectClass fromFileName:fileName];
}

+ (id)buildUsingFixture:(NSString *)fileName
{
    [self checkIfAnyFileWithNameExists:fileName];
    return [self contentObjectFromFileNamed:fileName];
}

+ (void)checkIfAnyFileWithNameExists:(NSString *)fileName
{
    if (![self isJSONFilePresent:fileName] && ![self isPlistFilePresent:fileName]) {
        @throw ([NSException exceptionWithName:@"NoFileFound"
                                        reason:@"Neither .plist nor .json files were found with factory name"
                                      userInfo:nil]);
    }
}

+ (void)checkIfClassIsSubclassOfMTlModel:(Class) objectClass
{
    if (![objectClass instancesRespondToSelector:@selector(mergeValuesForKeysFromModel:)]) {
        @throw ([NSException exceptionWithName:@"NoMantleClassException"
                                        reason:@"This class is not a subclass of MTLModel"
                                      userInfo:nil]);
    }

}

+ (id)instanceOfClass:(Class) objectClass fromFileName:(NSString *)fileName
{
    if ([self isJSONFilePresent:fileName]) {
        return [self instanceOfClass:objectClass fromJSONNamed:fileName];
    } else {
        return [self instanceOfClass:objectClass fromPlistNamed:fileName];
    }
}

+ (id)instanceOfClass:(Class) objectClass fromPlistNamed:(NSString *)fileName
{
    id content = [self contentObjectFromPlistFileNamed:fileName];
    if ([content isKindOfClass:[NSDictionary class]]) {
        return [MTLJSONAdapter modelOfClass:objectClass fromJSONDictionary:content error:nil];
    }
    return [self initArrayFromPlistContent:content withClass:objectClass];
}

+ (id)instanceOfClass:(Class) objectClass fromJSONNamed:(NSString *)fileName
{
    id jsonValue = [self contentObjectFromFileNamed:fileName];
    if ([jsonValue isKindOfClass:[NSArray class]]) {
        return [self initArrayFromContent:jsonValue withClass:objectClass];
    }
    return [MTLJSONAdapter modelOfClass:objectClass fromJSONDictionary:jsonValue error:nil];
}

+ (id)contentObjectFromFileNamed:(NSString *)fileName
{
    if ([self isJSONFilePresent:fileName]) {
        return [self contentObjectFromJSONFileNamed:fileName];
    } else {
        return [self contentObjectFromPlistFileNamed:fileName];
    }
}

+ (id)contentObjectFromJSONFileNamed:(NSString *)fileName
{
    id result = [self contentFromFixtureNamed:fileName ofType:@"json"];
    return [result JSONValue];
}

+ (id)contentObjectFromPlistFileNamed:(NSString *)fileName
{
    NSString *path = [self pathOfFileNamed:fileName withExtension:@"plist"];
    NSDictionary *content = [NSDictionary dictionaryWithContentsOfFile:path];
    if (content) {
        return content;
    }
    return [NSArray arrayWithContentsOfFile:path];
}

+ (NSArray *)initArrayFromContent:(NSArray *)jsonArray withClass:(Class) objectClass
{
    NSMutableArray *array = [NSMutableArray array];
    for (id json in jsonArray) {
        id convertedObject = [MTLJSONAdapter modelOfClass:objectClass fromJSONDictionary:json error:nil];
        [array addObject:convertedObject];
    }
    return array;
}

+ (NSArray *)initArrayFromPlistContent:(NSArray *)plistContentArray withClass:(Class) objectClass
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dictionary in plistContentArray) {
        id convertedObject = [MTLJSONAdapter modelOfClass:objectClass fromJSONDictionary:dictionary error:nil];
        [array addObject:convertedObject];
    }
    return array;
}

+ (BOOL)isJSONFilePresent:(NSString *)fileName
{
    return [[self pathOfFileNamed:fileName withExtension:@"json"] length] > 0;
}

+ (BOOL)isPlistFilePresent:(NSString *)fileName
{
    return [[self pathOfFileNamed:fileName withExtension:@"plist"] length] > 0;
}

+ (NSString *)contentFromFixtureNamed:(NSString *)fileName ofType:(NSString *)fileType
{
    return [[NSString alloc] initWithData:[self dataFromFixtureNamed:fileName ofType:fileType] encoding:NSUTF8StringEncoding];
}

+ (NSData *)dataFromFixtureNamed:(NSString *)fileName ofType:(NSString *)fileType
{
    return [NSData dataWithContentsOfFile:[self pathOfFileNamed:fileName withExtension:fileType]];
}

+ (NSString *)pathOfFileNamed:(NSString *)fileName withExtension:(NSString *)extension
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:extension];
    return filePath;
}

@end
