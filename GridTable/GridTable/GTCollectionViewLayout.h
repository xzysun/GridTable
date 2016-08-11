//
//  GTCollectionViewLayout.h
//  GridTable
//
//  Created by xzysun on 16/8/11.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTCollectionViewLayoutDelegate <NSObject>

-(CGFloat)collectionView:(UICollectionView *)collectionView widthForColumn:(NSInteger)column;
-(CGFloat)collectionView:(UICollectionView *)collectionView heightForRow:(NSInteger)row;

@end

@interface GTCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<GTCollectionViewLayoutDelegate> delegate;
@end
