//
//  GTTableInfo.m
//  GridTable
//
//  Created by xzysun on 16/8/11.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import "GTTableInfo.h"

@implementation GTTableInfo

-(void)markCurrentSelectedCell:(GTTableCellInfo *)cell
{
    if (_currentSelectedCell == cell) {//same cell
        return;
    }
    if (_currentSelectedCell) {
        //clean old state
    }
    //add new state
}
@end

@implementation GTTableRowInfo


@end

@implementation GTTableColumnInfo


@end

@implementation GTTableCellInfo


@end