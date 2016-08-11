//
//  GTTableView.m
//  GridTable
//
//  Created by xzysun on 16/8/11.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import "GTTableView.h"
#import "GTCollectionViewLayout.h"
#import "GTCollectionViewTextCell.h"

@interface GTTableView () <UICollectionViewDelegate, UICollectionViewDataSource, GTCollectionViewLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) GTCollectionViewLayout *layout;
@end

@implementation GTTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //init
    }
    return self;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //init
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - Collection Datasource & Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 30;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GTCollectionViewTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GTCollectionViewTextCell" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%ld - %ld",(long)indexPath.section, (long)indexPath.row];
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.contentView.layer.borderWidth = 0.5;
    return cell;
}

#pragma mark - Layout Delegate
-(CGFloat)collectionView:(UICollectionView *)collectionView widthForColumn:(NSInteger)column
{
    return 80.0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView heightForRow:(NSInteger)row
{
    return 60.0;
}

#pragma mark - Getter & Setter
-(GTCollectionViewLayout *)layout
{
    if (_layout == nil) {
        _layout = [GTCollectionViewLayout new];
        _layout.delegate = self;
    }
    return _layout;
}

-(UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_collectionView];
        [_collectionView registerClass:[GTCollectionViewTextCell class] forCellWithReuseIdentifier:@"GTCollectionViewTextCell"];
    }
    return _collectionView;
}
@end
