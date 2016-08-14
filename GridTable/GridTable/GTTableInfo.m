//
//  GTTableInfo.m
//  GridTable
//
//  Created by xzysun on 16/8/11.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import "GTTableInfo.h"

@interface GTTableRowInfo ()

-(void)setFixed:(BOOL)fixed;
@end

@interface GTTableColumnInfo ()

-(void)setFixed:(BOOL)fixed;
@end

@interface GTTableCellInfo ()

-(instancetype)initWithRowInfo:(GTTableRowInfo *)rowInfo ColumnInfo:(GTTableColumnInfo *)colunmInfo;
@end

#pragma mark - GTTableInfo
@implementation GTTableInfo

+(instancetype)tableInfoWithRows:(NSUInteger)rows Columns:(NSUInteger)columns
{
    GTTableInfo *tableInfo = [[GTTableInfo alloc] initWithRows:rows Columns:columns];
    return tableInfo;
}

-(instancetype)initWithRows:(NSUInteger)rows Columns:(NSUInteger)columns
{
    if (self = [super init]) {
        //init
        [self generateRowsInfo:rows ColumnsInfo:columns];
    }
    return self;
}

#pragma mark - Data Management
-(void)buildTableCellInfoWithBlock:(GTCellDataBuildBlock)block
{
    NSAssert(block, @"build block is needed!!");
    NSInteger rowsCount = self.rowInofs.count;
    NSInteger columnsCount = self.columnInfos.count;
    NSMutableArray *tmpTable = [NSMutableArray arrayWithCapacity:rowsCount];
    for (NSInteger row = 0; row < rowsCount; row ++) {
        GTTableRowInfo *rowInfo = [self.rowInofs objectAtIndex:row];
        NSMutableArray *tmpRow = [NSMutableArray arrayWithCapacity:columnsCount];
        for (NSInteger column = 0; column < columnsCount; column ++) {
            GTTableColumnInfo *columnInfo = [self.columnInfos objectAtIndex:column];
            GTTableCellInfo *cell = [[GTTableCellInfo alloc] initWithRowInfo:rowInfo ColumnInfo:columnInfo];
            [tmpRow addObject:cell];
            block(cell, row, column);
        }
        [tmpTable addObject:[tmpRow copy]];
    }
    _cellInfos = [tmpTable copy];
}

-(GTTableRowInfo *)addRowWithDataBuildBlock:(GTCellDataBuildBlock)block
{
    NSMutableArray *tmpRowInfos = [_rowInofs mutableCopy];
    GTTableRowInfo *rowInfo = [GTTableRowInfo new];
    [tmpRowInfos addObject:rowInfo];
    _rowInofs = [tmpRowInfos copy];
    //build cell info
    NSInteger rowsCount = self.rowInofs.count;
    NSInteger columnsCount = self.columnInfos.count;
    NSMutableArray *tmpRow = [NSMutableArray arrayWithCapacity:columnsCount];
    for (NSInteger column = 0 ; column < columnsCount; column ++) {
        GTTableColumnInfo *columnInfo = [self.columnInfos objectAtIndex:column];
        GTTableCellInfo *cell = [[GTTableCellInfo alloc] initWithRowInfo:rowInfo ColumnInfo:columnInfo];
        [tmpRow addObject:cell];
        block(cell, rowsCount-1, column);
    }
    NSMutableArray *tmpTable = [_cellInfos mutableCopy];
    [tmpTable addObject:[tmpRow copy]];
    _cellInfos = [tmpTable copy];
    return rowInfo;
}

-(GTTableColumnInfo *)addColumnWithDataBuildBlock:(GTCellDataBuildBlock)block
{
    NSMutableArray *tmpColumnInfos = [_columnInfos mutableCopy];
    GTTableColumnInfo *columnInfo = [GTTableColumnInfo new];
    [tmpColumnInfos addObject:columnInfo];
    _columnInfos = [tmpColumnInfos copy];
    //build cell info
    NSInteger rowsCount = self.rowInofs.count;
    NSInteger columnsCount = self.columnInfos.count;
    NSMutableArray *tmpTable = [NSMutableArray arrayWithCapacity:rowsCount];
    for (NSInteger row = 0; row < rowsCount; row ++) {
        GTTableRowInfo *rowInfo = [self.rowInofs objectAtIndex:row];
        NSMutableArray *tmpRow = [[_cellInfos objectAtIndex:row] mutableCopy];
        GTTableCellInfo *cell = [[GTTableCellInfo alloc] initWithRowInfo:rowInfo ColumnInfo:columnInfo];
        [tmpRow addObject:cell];
        block(cell, row, columnsCount-1);
        [tmpTable addObject:[tmpRow copy]];
    }
    _cellInfos = [tmpTable copy];
    return columnInfo;
}

-(void)removeRow:(NSUInteger)row
{
    NSMutableArray *tmpRowInfos = [_rowInofs mutableCopy];
    [tmpRowInfos removeObjectAtIndex:row];
    _rowInofs = [tmpRowInfos copy];
    NSMutableArray *tmpTable = [_cellInfos mutableCopy];
    [tmpTable removeObjectAtIndex:row];
    _cellInfos = [tmpTable copy];
}

-(void)removeColumn:(NSUInteger)column
{
    NSMutableArray *tmpColumnInfos = [_columnInfos mutableCopy];
    [tmpColumnInfos removeObjectAtIndex:column];
    _columnInfos = [tmpColumnInfos mutableCopy];
    NSInteger rowsCount = self.rowInofs.count;
    NSMutableArray *tmpTable = [NSMutableArray arrayWithCapacity:rowsCount];
    for (NSInteger row = 0; row < rowsCount; row ++) {
        NSMutableArray *tmpRow = [[_cellInfos objectAtIndex:row] mutableCopy];
        [tmpRow removeObjectAtIndex:column];
        [tmpTable addObject:[tmpRow copy]];
    }
    _cellInfos = [tmpTable copy];
}

-(void)setFixedRowCount:(NSUInteger)fixedRowCount FixedColumnCount:(NSUInteger)fixedColumnCount
{
    NSAssert(fixedRowCount < self.rowInofs.count, @"fixed row count greater than row count!");
    NSAssert(fixedColumnCount < self.columnInfos.count, @"fixed column count greater than column count!");
    _fixRowCount = fixedRowCount;
    _fixColumnCount = fixedColumnCount;
    NSInteger rowsCount = self.rowInofs.count;
    NSInteger columnsCount = self.columnInfos.count;
    for (NSInteger row = 0; row < rowsCount; row ++) {
        GTTableRowInfo *rowInfo = [self.rowInofs objectAtIndex:row];
        if (row < fixedRowCount) {
            [rowInfo setFixed:YES];
        } else {
            [rowInfo setFixed:NO];
        }
    }
    for (NSInteger column = 0; column < columnsCount; column ++) {
        GTTableColumnInfo *columnInfo = [self.columnInfos objectAtIndex:column];
        if (column < fixedColumnCount) {
            [columnInfo setFixed:YES];
        } else {
            [columnInfo setFixed:NO];
        }
    }
}

-(GTTableCellInfo *)cellForRow:(NSUInteger)row Column:(NSUInteger)column
{
    return [[_cellInfos objectAtIndex:row] objectAtIndex:column];
}

#pragma mark - Private
-(void)generateRowsInfo:(NSInteger)rows ColumnsInfo:(NSInteger)columns
{
    NSMutableArray *tmpRows = [NSMutableArray arrayWithCapacity:rows];
    for (NSInteger i = 0; i < rows; i ++) {
        GTTableRowInfo *rowInfo = [GTTableRowInfo new];
        [tmpRows addObject:rowInfo];
    }
    _rowInofs = [tmpRows copy];
    NSMutableArray *tmpColumns = [NSMutableArray arrayWithCapacity:columns];
    for (NSInteger i = 0 ; i < columns; i ++) {
        GTTableColumnInfo *columnInfo = [GTTableColumnInfo new];
        [tmpColumns addObject:columnInfo];
    }
    _columnInfos = [tmpColumns copy];
}
@end

#pragma mark - GTTableRowInfo
@implementation GTTableRowInfo

-(instancetype)init
{
    if (self = [super init]) {
        //init
        _rowHeight = kGridTableDefaultRowHeight;
    }
    return self;
}

-(void)setFixed:(BOOL)fixed
{
    _isRowFixed = fixed;
}
@end

#pragma mark - GTTableColumnInfo
@implementation GTTableColumnInfo

-(instancetype)init
{
    if ( self = [super init]) {
        //init
        _columnWidth = kGridTableDefaultColumnWidth;
    }
    return self;
}

-(void)setFixed:(BOOL)fixed
{
    _isColumnFixed = fixed;
}
@end

#pragma mark - GTTableCellInfo
@implementation GTTableCellInfo

-(instancetype)initWithRowInfo:(GTTableRowInfo *)rowInfo ColumnInfo:(GTTableColumnInfo *)colunmInfo
{
    if ( self = [super init]) {
        //init
        _rowInfo = rowInfo;
        _columnInfo = colunmInfo;
        _cellIdentifier = kGridTableTextCellIdentifier;
//        _cellClassName = @"GTCollectionViewTextCell";
    }
    return self;
}

-(UIColor *)cellBackgroundColor
{
    if (_cellBackgroundColor) {
        return _cellBackgroundColor;
    }
    if (self.rowInfo && self.rowInfo.rowBackgroundColor) {
        return self.rowInfo.rowBackgroundColor;
    }
    if (self.columnInfo && self.columnInfo.columnBackgroundColor) {
        return self.columnInfo.columnBackgroundColor;
    }
    return [UIColor whiteColor];
}

-(UIColor *)cellSelectedBackgroundColor
{
    if (_cellSelectedBackgroundColor) {
        return _cellSelectedBackgroundColor;
    }
    if (self.rowInfo && self.rowInfo.rowSelectedBackgroundColor) {
        return self.rowInfo.rowSelectedBackgroundColor;
    }
    if (self.columnInfo && self.columnInfo.columnBackgroundColor) {
        return self.columnInfo.columnSelectedBackgroundColor;
    }
    return [UIColor lightGrayColor];
}

@end