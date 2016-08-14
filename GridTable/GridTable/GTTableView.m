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

@property (nonatomic, strong) UICollectionView *mainTable;
@property (nonatomic, strong) UICollectionView *fixRowTable;
@property (nonatomic, strong) UICollectionView *fixColumnTable;
@property (nonatomic, strong) UICollectionView *headerTable;
@property (nonatomic, strong) GTCollectionViewLayout *mainLayout;
@property (nonatomic, strong) GTCollectionViewLayout *fixRowLayout;
@property (nonatomic, strong) GTCollectionViewLayout *fixColumnLayout;
@property (nonatomic, strong) GTCollectionViewLayout *headerLayout;
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
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat fixColumnWidth = 0.0;
    CGFloat fixRowHeight = 0.0;
    if (self.tableInfo && self.tableInfo.fixRowCount > 0) {
        for (NSInteger row = 0; row < self.tableInfo.fixRowCount; row ++) {
            fixRowHeight += [self.tableInfo.rowInofs objectAtIndex:row].rowHeight;
        }
    }
    if (self.tableInfo && self.tableInfo.fixColumnCount > 0) {
        for (NSInteger column = 0; column < self.tableInfo.fixColumnCount; column ++) {
            fixColumnWidth += [self.tableInfo.columnInfos objectAtIndex:column].columnWidth;
        }
    }
    self.headerTable.frame = CGRectMake(0, 0, fixColumnWidth, fixRowHeight);
    self.fixRowTable.frame = CGRectMake(fixColumnWidth, 0, width-fixColumnWidth, fixRowHeight);
    self.fixColumnTable.frame = CGRectMake(0, fixRowHeight, fixColumnWidth, height-fixRowHeight);
    self.mainTable.frame = CGRectMake(fixColumnWidth, fixRowHeight, width-fixColumnWidth, height-fixRowHeight);
}

#pragma mark - Public APIs
-(void)reloadData
{
    [self.mainTable reloadData];
    [self.headerTable reloadData];
    [self.fixRowTable reloadData];
    [self.fixColumnTable reloadData];
}

-(void)reloadCellAtRow:(NSUInteger)row Column:(NSUInteger)column
{
    if (self.tableInfo && row < self.tableInfo.rowInofs.count && column < self.tableInfo.columnInfos.count) {
        NSUInteger fixRowCount = self.tableInfo.fixRowCount;
        NSUInteger fixColumnCount = self.tableInfo.fixColumnCount;
        if (row < fixRowCount && column < fixColumnCount) {
            //reload header
            [self.headerTable reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:column inSection:row]]];
        } else if (row < fixRowCount &&  column > fixColumnCount) {
            //reload fix row
            [self.fixRowTable reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:column-fixColumnCount inSection:row]]];
        } else if (row > fixRowCount && column < fixColumnCount) {
            //reload fix column
            [self.fixColumnTable reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:column inSection:row-fixRowCount]]];
        } else {
            //reload main table
            [self.mainTable reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:column-fixColumnCount inSection:row-fixRowCount]]];
        }
    }
}

-(void)setTableInfo:(GTTableInfo *)tableInfo
{
    _tableInfo = tableInfo;
    [self reloadData];
}

-(void)registerCustomCellClass:(Class)class WithIdentifier:(NSString *)identifier
{
    [self.headerTable registerClass:class forCellWithReuseIdentifier:identifier];
    [self.fixRowTable registerClass:class forCellWithReuseIdentifier:identifier];
    [self.fixColumnTable registerClass:class forCellWithReuseIdentifier:identifier];
    [self.mainTable registerClass:class forCellWithReuseIdentifier:identifier];
}

#pragma mark - Collection Datasource & Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == self.headerTable) {
        return self.tableInfo.fixRowCount;
    } else if (collectionView == self.fixRowTable) {
        return self.tableInfo.fixRowCount;
    } else if (collectionView == self.fixColumnTable) {
        return self.tableInfo.rowInofs.count - self.tableInfo.fixRowCount;
    } else if (collectionView == self.mainTable) {
        return self.tableInfo.rowInofs.count - self.tableInfo.fixRowCount;
    }
    return 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.headerTable) {
        return self.tableInfo.fixColumnCount;
    } else if (collectionView == self.fixRowTable) {
        return self.tableInfo.columnInfos.count - self.tableInfo.fixColumnCount;
    } else if (collectionView == self.fixColumnTable) {
        return self.tableInfo.fixColumnCount;
    } else if (collectionView == self.mainTable) {
        return self.tableInfo.columnInfos.count - self.tableInfo.fixColumnCount;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = 0;
    NSInteger column = 0;
    if (collectionView == self.headerTable) {
        row = indexPath.section;
        column = indexPath.item;
    } else if (collectionView == self.fixRowTable) {
        row = indexPath.section;
        column = indexPath.item + self.tableInfo.fixColumnCount;
    } else if (collectionView == self.fixColumnTable) {
        row = indexPath.section + self.tableInfo.fixRowCount;
        column = indexPath.item;
    } else {
        row = indexPath.section + self.tableInfo.fixRowCount;
        column = indexPath.item + self.tableInfo.fixColumnCount;
    }
    GTTableCellInfo *cellInfo = [self.tableInfo cellForRow:row Column:column];
    UICollectionViewCell *cell = nil;
    if (cellInfo.cellIdentifier == nil || [cellInfo.cellIdentifier isEqualToString:kGridTableTextCellIdentifier]) {
        //draw text cell
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GTCollectionViewTextCell" forIndexPath:indexPath];
        ((GTCollectionViewTextCell *)cell).label.text = [NSString stringWithFormat:@"%ld - %ld",(long)(row), (long)(column)];
    } else {
        //draw custom cell
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellInfo.cellIdentifier forIndexPath:indexPath];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:prepareCell:AtRow:Column:)]) {
            [self.delegate tableView:self prepareCell:cell AtRow:row Column:column];
        }
    }
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.contentView.layer.borderWidth = 0.5;
    if (cell.backgroundView == nil) {
        cell.backgroundView = [UIView new];
    }
    if (cell.selectedBackgroundView == nil) {
        cell.selectedBackgroundView = [UIView new];
    }
#warning handle backgound and selection here!
    cell.backgroundView.backgroundColor = cellInfo.cellBackgroundColor;
    cell.selectedBackgroundView.backgroundColor = cellInfo.cellSelectedBackgroundColor;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = 0;
    NSInteger column = 0;
    if (collectionView == self.headerTable) {
        row = indexPath.section;
        column = indexPath.item;
    } else if (collectionView == self.fixRowTable) {
        row = indexPath.section;
        column = indexPath.item + self.tableInfo.fixColumnCount;
    } else if (collectionView == self.fixColumnTable) {
        row = indexPath.section + self.tableInfo.fixRowCount;
        column = indexPath.item;
    } else {
        row = indexPath.section + self.tableInfo.fixRowCount;
        column = indexPath.item + self.tableInfo.fixColumnCount;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectCellAtRow:Column:)]) {
        [self.delegate tableView:self didSelectCellAtRow:row Column:column];
    }
}

#pragma mark - Layout Delegate
-(CGFloat)collectionView:(UICollectionView *)collectionView widthForColumn:(NSInteger)column
{
    if (collectionView == self.headerTable || collectionView == self.fixColumnTable) {
        GTTableColumnInfo *columnInfo = [self.tableInfo.columnInfos objectAtIndex:column];
        return columnInfo.columnWidth;
    }
    if (collectionView == self.fixRowTable || collectionView == self.mainTable) {
        GTTableColumnInfo *columnInfo = [self.tableInfo.columnInfos objectAtIndex:column+self.tableInfo.fixColumnCount];
        return columnInfo.columnWidth;
    }
    return 0.0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView heightForRow:(NSInteger)row
{
    if (collectionView == self.headerTable || collectionView == self.fixRowTable) {
        GTTableRowInfo *rowInfo = [self.tableInfo.rowInofs objectAtIndex:row];
        return rowInfo.rowHeight;
    }
    if (collectionView == self.fixColumnTable || collectionView == self.mainTable) {
        GTTableRowInfo *rowInfo = [self.tableInfo.rowInofs objectAtIndex:row+self.tableInfo.fixRowCount];
        return rowInfo.rowHeight;
    }
    return 0.0;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mainTable) {
        [self.fixRowTable setContentOffset:CGPointMake(MAX(scrollView.contentOffset.x, 0), 0)];
        [self.fixColumnTable setContentOffset:CGPointMake(0, MAX(scrollView.contentOffset.y, 0))];
    } else if (scrollView == self.fixRowTable) {
        [self.mainTable setContentOffset:CGPointMake(scrollView.contentOffset.x, self.mainTable.contentOffset.y)];
    } else if (scrollView == self.fixColumnTable) {
        [self.mainTable setContentOffset:CGPointMake(self.mainTable.contentOffset.x, scrollView.contentOffset.y)];
    }
}

#pragma mark - Getter & Setter
-(GTCollectionViewLayout *)mainLayout
{
    if (_mainLayout == nil) {
        _mainLayout = [GTCollectionViewLayout new];
        _mainLayout.delegate = self;
    }
    return _mainLayout;
}

-(GTCollectionViewLayout *)fixRowLayout
{
    if (_fixRowLayout == nil) {
        _fixRowLayout = [GTCollectionViewLayout new];
        _fixRowLayout.delegate = self;
    }
    return _fixRowLayout;
}

-(GTCollectionViewLayout *)fixColumnLayout
{
    if (_fixColumnLayout == nil) {
        _fixColumnLayout = [GTCollectionViewLayout new];
        _fixColumnLayout.delegate = self;
    }
    return _fixColumnLayout;
}

-(GTCollectionViewLayout *)headerLayout
{
    if (_headerLayout == nil) {
        _headerLayout = [GTCollectionViewLayout new];
        _headerLayout.delegate = self;
    }
    return _headerLayout;
}

-(UICollectionView *)mainTable
{
    if (_mainTable == nil) {
        _mainTable = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.mainLayout];
        _mainTable.dataSource = self;
        _mainTable.delegate = self;
        _mainTable.backgroundColor = [UIColor whiteColor];
        [self addSubview:_mainTable];
        [_mainTable registerClass:[GTCollectionViewTextCell class] forCellWithReuseIdentifier:@"GTCollectionViewTextCell"];
    }
    return _mainTable;
}

-(UICollectionView *)fixRowTable
{
    if (_fixRowTable == nil) {
        _fixRowTable = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.fixRowLayout];
        _fixRowTable.dataSource = self;
        _fixRowTable.delegate = self;
        _fixRowTable.backgroundColor = [UIColor whiteColor];
        [self addSubview:_fixRowTable];
        [_fixRowTable registerClass:[GTCollectionViewTextCell class] forCellWithReuseIdentifier:@"GTCollectionViewTextCell"];
        _fixRowTable.alwaysBounceVertical = NO;
        _fixRowTable.showsHorizontalScrollIndicator = NO;
    }
    return _fixRowTable;
}

-(UICollectionView *)fixColumnTable
{
    if (_fixColumnTable == nil) {
        _fixColumnTable = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.fixColumnLayout];
        _fixColumnTable.dataSource = self;
        _fixColumnTable.delegate = self;
        _fixColumnTable.backgroundColor = [UIColor whiteColor];
        [self addSubview:_fixColumnTable];
        [_fixColumnTable registerClass:[GTCollectionViewTextCell class] forCellWithReuseIdentifier:@"GTCollectionViewTextCell"];
        _fixColumnTable.alwaysBounceHorizontal = NO;
        _fixColumnTable.showsVerticalScrollIndicator = NO;
    }
    return _fixColumnTable;
}

-(UICollectionView *)headerTable
{
    if (_headerTable == nil) {
        _headerTable = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.headerLayout];
        _headerTable.dataSource = self;
        _headerTable.delegate = self;
        _headerTable.backgroundColor = [UIColor whiteColor];
        [self addSubview:_headerTable];
        [_headerTable registerClass:[GTCollectionViewTextCell class] forCellWithReuseIdentifier:@"GTCollectionViewTextCell"];
        _headerTable.bounces = NO;
    }
    return _headerTable;
}
@end
