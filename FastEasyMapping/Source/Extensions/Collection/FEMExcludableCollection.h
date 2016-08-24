// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FEMExcludableCollection <NSObject>
@required
- (id)collectionByExcludingObjects:(id)objects;

@end

@interface NSArray (FEMExcludableCollection) <FEMExcludableCollection>

- (NSArray *)collectionByExcludingObjects:(NSArray *)objects;

@end

@interface NSSet (FEMExcludableCollection) <FEMExcludableCollection>

- (NSSet *)collectionByExcludingObjects:(NSSet *)objects;

@end

@interface NSOrderedSet (FEMExcludableCollection) <FEMExcludableCollection>

- (NSOrderedSet *)collectionByExcludingObjects:(NSOrderedSet *)objects;

@end

NS_ASSUME_NONNULL_END