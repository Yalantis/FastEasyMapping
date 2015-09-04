// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

#import "FEMRelationshipAssignmentContext.h"

@class FEMMapping;

NS_ASSUME_NONNULL_BEGIN

@interface FEMObjectStore : NSObject <FEMRelationshipAssignmentContextDelegate>

- (void)prepareTransactionForMapping:(FEMMapping *)mapping ofRepresentation:(NSArray *)representation;
- (void)beginTransaction;
- (nullable NSError *)commitTransaction;

- (id)newObjectForMapping:(FEMMapping *)mapping;
- (FEMRelationshipAssignmentContext *)newAssignmentContext;

- (void)registerObject:(id)object forMapping:(FEMMapping *)mapping;
- (BOOL)canRegisterObject:(id)object forMapping:(FEMMapping *)mapping;

- (NSDictionary *)registeredObjectsForMapping:(FEMMapping *)mapping;
- (nullable id)registeredObjectForRepresentation:(id)representation mapping:(FEMMapping *)mapping;

@end

NS_ASSUME_NONNULL_END