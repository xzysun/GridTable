//
//  GTCollectionViewLayout.m
//  GridTable
//
//  Created by xzysun on 16/8/11.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import "GTCollectionViewLayout.h"

@interface GTCollectionViewLayout ()

@property (nonatomic, strong) NSDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *layoutInfo;
@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, assign) CGFloat totalHeight;
@end

@implementation GTCollectionViewLayout

#pragma mark - Subclass Override
-(void)prepareLayout
{
    [self calculateTotalWidthAndHeight];
    NSMutableDictionary *layoutInfo = [NSMutableDictionary dictionary];
    BOOL delegateWidthFlag = (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:heightForRow:)]);
    BOOL delegateHeightFlag = (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:heightForRow:)]);
    BOOL delegateRowFixFlag = (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:shouldRowFixed:)]);
    BOOL delegateColumnFixFlag = (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:shouldColumnFixed:)]);
    NSInteger rowsCount = [self.collectionView numberOfSections];
    NSInteger columnsCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat originY = 0.0;
    CGFloat fixedOriginY = 0.0;
    for (NSInteger row = 0; row < rowsCount; row ++) {
        CGFloat height = 0.0;
        if (delegateHeightFlag) {
            height = [self.delegate collectionView:self.collectionView heightForRow:row];
        }
        BOOL rowFixed = NO;
        if (delegateRowFixFlag) {
            rowFixed = [self.delegate collectionView:self.collectionView shouldRowFixed:row];
        }
        CGFloat originX = 0.0;
        CGFloat fixedOriginX = 0.0;
        for (NSInteger column = 0; column < columnsCount; column ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:column inSection:row];
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGFloat width = 0.0;
            if (delegateWidthFlag) {
                width = [self.delegate collectionView:self.collectionView widthForColumn:column];
            }
            BOOL columnFixed = NO;
            if (delegateColumnFixFlag) {
                columnFixed = [self.delegate collectionView:self.collectionView shouldColumnFixed:column];
            }
            CGFloat realOriginX = originX;
            CGFloat realOriginY = originY;
            if (columnFixed && rowFixed) {
                itemAttributes.zIndex = 2000;//float on top most
                realOriginX = self.collectionView.contentOffset.x + fixedOriginX;
                realOriginY = self.collectionView.contentOffset.y + fixedOriginY;
            } else if (columnFixed && !rowFixed) {
                itemAttributes.zIndex = 1000;//something bigger than 0
                realOriginX = self.collectionView.contentOffset.x + fixedOriginX;
                realOriginY = MIN(self.collectionView.contentOffset.y, 0) + originY;
            } else if (!columnFixed && rowFixed) {
                itemAttributes.zIndex += 1000;//something bigger than 0
                realOriginY = self.collectionView.contentOffset.y + fixedOriginY;
                realOriginX = MIN(self.collectionView.contentOffset.x, 0) + originX;
            }
            itemAttributes.frame = CGRectMake(realOriginX, realOriginY, width, height);
            [layoutInfo setObject:itemAttributes forKey:indexPath];
            if (columnFixed) {
                fixedOriginX += width;
            }
            originX += width;
        }
        if (rowFixed) {
            fixedOriginY += height;
        }
        originY += height;
    }
    self.layoutInfo = [layoutInfo copy];
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake(self.totalWidth, self.totalHeight);
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray array];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }];
    return allAttributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.layoutInfo objectForKey:indexPath];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

#pragma mark - Private 
-(void)calculateTotalWidthAndHeight
{
    NSInteger rowsCount = [self.collectionView numberOfSections];
    NSInteger columnsCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat totalWidth = 0.0;
    CGFloat totalHeight = 0.0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:widthForColumn:)]) {
        for (NSInteger column = 0; column < columnsCount; column ++) {
            CGFloat width = [self.delegate collectionView:self.collectionView widthForColumn:column];
            totalWidth += width;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:heightForRow:)]) {
        for (NSInteger row = 0; row < rowsCount; row ++) {
            CGFloat height = [self.delegate collectionView:self.collectionView heightForRow:row];
            totalHeight += height;
        }
    }
    self.totalWidth = totalWidth;
    self.totalHeight = totalHeight;
}
@end
