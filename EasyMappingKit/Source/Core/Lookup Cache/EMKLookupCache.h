//
// EMKLookupCache.h 
// EasyMappingKit
//
// Created by dmitriy on 3/3/14
// Copyright (c) 2014 Yalantis. All rights reserved. 
//
#import <Foundation/Foundation.h>

@class EMKLookupCache, EMKManagedObjectMapping, NSManagedObjectContext;

OBJC_EXTERN EMKLookupCache *EMKLookupCacheGetCurrent();
OBJC_EXTERN void EMKLookupCacheSetCurrent(EMKLookupCache *cache);
OBJC_EXTERN void EMKLookupCacheRemoveCurrent();

@interface EMKLookupCache : NSObject

@property (nonatomic, strong, readonly) EMKManagedObjectMapping *mapping;
@property (nonatomic, strong, readonly) NSManagedObjectContext *context;

- (instancetype)initWithMapping:(EMKManagedObjectMapping *)mapping
                 representation:(id)representation
                        context:(NSManagedObjectContext *)context;

#pragma mark -

- (id)existingObjectForRepresentation:(id)representation mapping:(EMKManagedObjectMapping *)mapping;
- (void)addExistingObject:(id)object usingMapping:(EMKManagedObjectMapping *)mapping;


- (void)addPrimaryKeyValue:(id)value forObjectOfClass:(Class)class;
- (id)cachedObjectOfClass:(Class)class withPrimaryKeyValue:(id)value;

@end