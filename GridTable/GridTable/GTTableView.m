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

#pragma mark - Public APIs
-(void)reloadData
{
    [self.collectionView reloadData];
}

-(void)reloadCellAtRow:(NSUInteger)row Column:(NSUInteger)column
{
    if (self.tableInfo && row < self.tableInfo.rowInofs.count && column < self.tableInfo.columnInfos.count) {
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:column inSection:row]]];
    }
}

-(void)setTableInfo:(GTTableInfo *)tableInfo
{
    _tableInfo = tableInfo;
    [self.collectionView reloadData];
}

-(void)registerCustomCellClass:(Class)class WithIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:class forCellWithReuseIdentifier:identifier];
}

#pragma mark - Collection Datasource & Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.tableInfo.rowInofs.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tableInfo.columnInfos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GTTableCellInfo *cellInfo = [self.tableInfo cellForRow:indexPath.section Column:indexPath.item];
    UICollectionViewCell *cell = nil;
    if (cellInfo.cellIdentifier == nil || [cellInfo.cellIdentifier isEqualToString:kGridTableTextCellIdentifier]) {
        //draw text cell
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GTCollectionViewTextCell" forIndexPath:indexPath];
        ((GTCollectionViewTextCell *)cell).label.text = [NSString stringWithFormat:@"%ld - %ld",(long)(indexPath.section), (long)(indexPath.row)];
    } else {
        //draw custom cell
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellInfo.cellIdentifier forIndexPath:indexPath];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:prepareCell:AtRow:Column:)]) {
            [self.delegate tableView:self prepareCell:cell AtRow:indexPath.section Column:indexPath.item];
        }
    }
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.contentView.layer.borderWidth = 0.5;
    cell.backgroundView = [UIView new];
    cell.selectedBackgroundView = [UIView new];
#warning handle backgound and selection here!
    cell.backgroundView.backgroundColor = cellInfo.cellBackgroundColor;
    cell.selectedBackgroundView.backgroundColor = cellInfo.cellSelectedBackgroundColor;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectCellAtRow:Column:)]) {
        [self.delegate tableView:self didSelectCellAtRow:indexPath.section Column:indexPath.item];
    }
}

#pragma mark - Layout Delegate
-(CGFloat)collectionView:(UICollectionView *)collectionView widthForColumn:(NSInteger)column
{
    GTTableColumnInfo *columnInfo = [self.tableInfo.columnInfos objectAtIndex:column];
    return columnInfo.columnWidht;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView heightForRow:(NSInteger)row
{
    GTTableRowInfo *rowInfo = [self.tableInfo.rowInofs objectAtIndex:row];
    return rowInfo.rowHeight;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldRowFixed:(NSInteger)row
{
    GTTableRowInfo *rowInfo = [self.tableInfo.rowInofs objectAtIndex:row];
    return rowInfo.isRowFixed;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldColumnFixed:(NSInteger)column
{
    GTTableColumnInfo *columnInfo = [self.tableInfo.columnInfos objectAtIndex:column];
    return columnInfo.isColumnFixed;
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
