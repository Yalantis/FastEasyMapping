// For License please refer to LICENSE file in the root of FastEasyMapping project

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FEMMergeableCollection <NSObject>
@required
- (id)collectionByMergingObjects:(id)object;

@end

@interface NSArray (FEMMergeableCollection) <FEMMergeableCollection>

- (NSArray *)collectionByMergingObjects:(NSArray *)object;

@end

@interface NSSet (FEMMergeableCollection) <FEMMergeableCollection>

- (NSSet *)collectionByMergingObjects:(NSSet *)object;

@end

@interface NSOrderedSet (FEMMergeableCollection) <FEMMergeableCollection>

- (NSOrderedSet *)collectionByMergingObjects:(NSOrderedSet *)object;

@end

NS_ASSUME_NONNULL_END