//
//  GTPosition.m
//  GridTable
//
//  Created by xzysun on 16/8/15.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import "GTPosition.h"

NSString *NSStringFromGTPosition(GTPosition position)
{
    return [NSString stringWithFormat:@"GTPosition(%lu-%lu)", (long)(position.row), (long)(position.column)];
}

@implementation NSValue (GTPosition)

-(GTPosition)GT_CellPosition
{
    GTPosition cellPosition;
    [self getValue:&cellPosition];
    return cellPosition;
}

+(NSValue *)valueWithCellPosition:(GTPosition)cellPosition
{
    return [NSValue valueWithBytes:&cellPosition objCType:@encode(GTPosition)];
}
@end