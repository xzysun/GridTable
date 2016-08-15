//
//  GTCellPosition.m
//  GridTable
//
//  Created by xzysun on 16/8/15.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import "GTCellPosition.h"

NSString *NSStringFromGTCellPosition(GTCellPosition position)
{
    return [NSString stringWithFormat:@"GTCellPosition(%lu-%lu)", (long)(position.row), (long)(position.column)];
}

@implementation NSValue (GTCellPosition)

-(GTCellPosition)GT_CellPosition
{
    GTCellPosition cellPosition;
    [self getValue:&cellPosition];
    return cellPosition;
}

+(NSValue *)valueWithCellPosition:(GTCellPosition)cellPosition
{
    return [NSValue valueWithBytes:&cellPosition objCType:@encode(GTCellPosition)];
}
@end