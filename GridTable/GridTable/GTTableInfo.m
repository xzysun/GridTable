//
//  GTTableInfo.m
//  GridTable
//
//  Created by xzysun on 16/8/11.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import "GTTableInfo.h"

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
-(void)generateTableDataWithBlock:(GTCellDataBuildBlock)block
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

@end

#pragma mark - GTTableColumnInfo
@implementation GTTableColumnInfo

-(instancetype)init
{
    if ( self = [super init]) {
        //init
        _columnWidht = kGridTableDefaultColumnWidth;
    }
    return self;
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
        _cellBackgroundColor = [UIColor whiteColor];
        _cellSelectedBackgroundColor = [UIColor lightGrayColor];
        _cellIdentifier = kGridTableTextCellIdentifier;
//        _cellClassName = @"GTCollectionViewTextCell";
    }
    return self;
}

@end