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

@property (nonatomic, assign) GTPosition lastSelectedPosition;
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

-(void)reloadCellAtPosition:(GTPosition)position
{
    if (self.tableInfo && position.row < self.tableInfo.rowInofs.count && position.column < self.tableInfo.columnInfos.count) {
        NSUInteger fixRowCount = self.tableInfo.fixRowCount;
        NSUInteger fixColumnCount = self.tableInfo.fixColumnCount;
        if (position.row < fixRowCount && position.column < fixColumnCount) {
            //reload header
            [self.headerTable reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:position.column inSection:position.row]]];
        } else if (position.row < fixRowCount &&  position.column >= fixColumnCount) {
            //reload fix row
            [self.fixRowTable reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:position.column-fixColumnCount inSection:position.row]]];
        } else if (position.row >= fixRowCount && position.column < fixColumnCount) {
            //reload fix column
            [self.fixColumnTable reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:position.column inSection:position.row-fixRowCount]]];
        } else {
            //reload main table
            [self.mainTable reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:position.column-fixColumnCount inSection:position.row-fixRowCount]]];
        }
    }
}

-(void)reloadRowData:(NSUInteger)row
{
    if (self.tableInfo && row < self.tableInfo.rowInofs.count) {
        NSUInteger fixRowCount = self.tableInfo.fixRowCount;
        if (row < fixRowCount) {
            //reload header & fix rows
            [self.headerTable reloadSections:[NSIndexSet indexSetWithIndex:row]];
            [self.fixRowTable reloadSections:[NSIndexSet indexSetWithIndex:row]];
        } else {
            //reload fix column && main table
            [self.fixColumnTable reloadSections:[NSIndexSet indexSetWithIndex:row-fixRowCount]];
            [self.mainTable reloadSections:[NSIndexSet indexSetWithIndex:row-fixRowCount]];
        }
    }
}

-(void)reloadColumnData:(NSUInteger)column
{
    if (self.tableInfo && column < self.tableInfo.columnInfos.count) {
        NSUInteger fixColumnCount = self.tableInfo.fixColumnCount;
        NSUInteger fixRowCount = self.tableInfo.fixRowCount;
        NSUInteger rowCount = self.tableInfo.rowInofs.count;
        if (column < fixColumnCount) {
            //reload header & fix columns
            NSMutableArray *headerReloadList = [NSMutableArray arrayWithCapacity:fixRowCount];
            for (NSInteger row = 0; row < fixRowCount; row ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:column inSection:row];
                [headerReloadList addObject:indexPath];
            }
            [self.headerTable reloadItemsAtIndexPaths:headerReloadList];
            NSMutableArray *fixColumnReloadList = [NSMutableArray arrayWithCapacity:rowCount-fixRowCount];
            for (NSInteger row = fixRowCount; row < rowCount; row ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:column inSection:row-fixRowCount];
                [fixColumnReloadList addObject:indexPath];
            }
            [self.fixColumnTable reloadItemsAtIndexPaths:fixColumnReloadList];
        } else {
            //reload fix row & main table
            NSMutableArray *fixRowReloadList = [NSMutableArray arrayWithCapacity:fixRowCount];
            for (NSInteger row = 0; row < fixRowCount; row ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:column-fixColumnCount inSection:row];
                [fixRowReloadList addObject:indexPath];
            }
            [self.fixRowTable reloadItemsAtIndexPaths:fixRowReloadList];
            NSMutableArray *mainTableReloadList = [NSMutableArray arrayWithCapacity:rowCount-fixRowCount];
            for (NSInteger row = fixRowCount; row < rowCount; row ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:column-fixColumnCount inSection:row-fixRowCount];
                [mainTableReloadList addObject:indexPath];
            }
            [self.mainTable reloadItemsAtIndexPaths:mainTableReloadList];
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

#pragma mark - Private Mehtod
-(GTPosition)convertPosition:(UICollectionView *)collectionView FromIndexPath:(NSIndexPath *)indexPath
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
    return GTPositionMake(row, column);
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
    GTPosition position = [self convertPosition:collectionView FromIndexPath:indexPath];
    GTTableCellInfo *cellInfo = [self.tableInfo cellForRow:position.row Column:position.column];
    UICollectionViewCell *cell = nil;
    if (cellInfo.cellIdentifier == nil || [cellInfo.cellIdentifier isEqualToString:kGridTableTextCellIdentifier]) {
        //draw text cell
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GTCollectionViewTextCell" forIndexPath:indexPath];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableview:prepareTextCell:AtPosition:)]) {
            [self.delegate tableview:self prepareTextCell:(GTCollectionViewTextCell *)cell AtPosition:position];
        }
    } else {
        //draw custom cell
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellInfo.cellIdentifier forIndexPath:indexPath];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:prepareCustomCell:AtPosition:)]) {
            [self.delegate tableView:self prepareCustomCell:cell AtPosition:position];
        }
    }
    if (cell.backgroundView == nil) {
        cell.backgroundView = [UIView new];
    }
    if (cell.selectedBackgroundView == nil) {
        cell.selectedBackgroundView = [UIView new];
    }
    //handle selection state & background color
    UIColor *backgroundColor = cellInfo.cellBackgroundColor;
    UIColor *highLightedBackgroundColor = cellInfo.cellSelectedBackgroundColor;
    if (self.selectionType == GTTableViewSelectionTypeNone) {
        highLightedBackgroundColor = cellInfo.cellBackgroundColor;
    } else if (self.selectionType == GTTableViewSelectionTypeCell) {
        if (cellInfo.selected) {
            backgroundColor = cellInfo.cellSelectedBackgroundColor;
        }
    } else if (self.selectionType == GTTableViewSelectionTypeRow) {
        if (cellInfo.rowInfo.selected) {
            backgroundColor = cellInfo.cellSelectedBackgroundColor;
        }
    } else if (self.selectionType == GTTableViewSelectionTypeColumn) {
        if (cellInfo.columnInfo.selected) {
            backgroundColor = cellInfo.cellSelectedBackgroundColor;
        }
    }
    cell.backgroundView.backgroundColor = backgroundColor;
    cell.selectedBackgroundView.backgroundColor = highLightedBackgroundColor;
    //draw border
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.contentView.layer.borderWidth = 0.5;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //clear last selection
    GTTableCellInfo *lastCellInfo = [self.tableInfo cellForRow:self.lastSelectedPosition.row Column:self.lastSelectedPosition.column];
    lastCellInfo.selected = NO;
    lastCellInfo.rowInfo.selected = NO;
    lastCellInfo.columnInfo.selected = NO;
    if (self.selectionType == GTTableViewSelectionTypeCell) {
        [self reloadCellAtPosition:self.lastSelectedPosition];
    } else if (self.selectionType == GTTableViewSelectionTypeRow) {
        [self reloadRowData:self.lastSelectedPosition.row];
    } else if (self.selectionType == GTTableViewSelectionTypeColumn) {
        [self reloadColumnData:self.lastSelectedPosition.column];
    }
    //mark new selection
    GTPosition position = [self convertPosition:collectionView FromIndexPath:indexPath];
    GTTableCellInfo *cellInfo = [self.tableInfo cellForRow:position.row Column:position.column];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectCellAtPosition:)]) {
        [self.delegate tableView:self didSelectCellAtPosition:position];
    }
    if (self.selectionType == GTTableViewSelectionTypeCell) {
        cellInfo.selected = YES;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } else if (self.selectionType == GTTableViewSelectionTypeRow) {
        cellInfo.rowInfo.selected = YES;
        [self reloadRowData:position.row];
    } else if (self.selectionType == GTTableViewSelectionTypeColumn) {
        cellInfo.columnInfo.selected = YES;
        [self reloadColumnData:position.column];
    }
    self.lastSelectedPosition = position;
}

//-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    GTPosition position = [self convertPosition:collectionView FromIndexPath:indexPath];
//    GTTableCellInfo *cellInfo = [self.tableInfo cellForRow:position.row Column:position.column];
//    cellInfo.selected = NO;
//}

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
        _fixRowTable.scrollsToTop = NO;
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
        _fixColumnTable.scrollsToTop = NO;
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
        _headerTable.scrollsToTop = NO;
    }
    return _headerTable;
}
@end
