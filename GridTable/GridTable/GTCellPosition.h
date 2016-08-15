//
//  GTCellPosition.h
//  GridTable
//
//  Created by xzysun on 16/8/15.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import <UIKit/UIKit.h>

struct GTCellPosition {
    NSUInteger row;
    NSUInteger column;
};
typedef struct GTCellPosition GTCellPosition;

static inline GTCellPosition GTPositionMake(NSUInteger row, NSUInteger column)
{
    GTCellPosition position;
    position.row = row;
    position.column = column;
    return position;
}
UIKIT_EXTERN NSString *NSStringFromGTCellPosition(GTCellPosition position);

@interface NSValue (GTCellPosition)

-(GTCellPosition)GT_CellPosition;
+(NSValue *)valueWithCellPosition:(GTCellPosition)cellPosition;
@end