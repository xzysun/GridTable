//
//  GTPosition.h
//  GridTable
//
//  Created by xzysun on 16/8/15.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import <UIKit/UIKit.h>

struct GTPosition {
    NSUInteger row;
    NSUInteger column;
};
typedef struct GTPosition GTPosition;

static inline GTPosition GTPositionMake(NSUInteger row, NSUInteger column)
{
    GTPosition position;
    position.row = row;
    position.column = column;
    return position;
}
UIKIT_EXTERN NSString *NSStringFromGTPosition(GTPosition position);

@interface NSValue (GTPosition)

-(GTPosition)GT_CellPosition;
+(NSValue *)valueWithCellPosition:(GTPosition)cellPosition;
@end