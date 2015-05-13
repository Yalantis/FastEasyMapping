//
// Created by zen on 13/05/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FEMRelationship, FEMObjectStore, FEMRelationshipAssignmentContext;

@protocol FEMRelationshipAssignmentContextDelegate <NSObject>
@required

- (void)assignmentContext:(FEMRelationshipAssignmentContext *)context deletedObject:(id)object;

@end


@interface FEMRelationshipAssignmentContext: NSObject

@property (nonatomic, unsafe_unretained, readonly) FEMObjectStore *store;
- (instancetype)initWithStore:(FEMObjectStore *)store;

@property (nonatomic, strong, readonly) id destinationObject;
@property (nonatomic, strong, readonly) FEMRelationship *relationship;

@property (nonatomic, strong, readonly) id sourceRelationshipValue;
@property (nonatomic, strong, readonly) id targetRelationshipValue;

- (void)deleteRelationshipObject:(id)object;

@end