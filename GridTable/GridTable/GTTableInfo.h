//
//  GTTableInfo.h
//  GridTable
//
//  Created by xzysun on 16/8/11.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GTTableCellTypeText,
    GTTableCellTypeCustom,
} GTTableCellType;

@class GTTableRowInfo;
@class GTTableColumnInfo;
@class GTTableCellInfo;
@interface GTTableInfo : NSObject

@property (nonatomic, strong) NSArray<GTTableRowInfo *> *rowInofs;
@property (nonatomic, strong) NSArray<GTTableColumnInfo *> *columnInfos;
@property (nonatomic, strong) NSArray<NSArray *> *cellInfos;

@end


@interface GTTableRowInfo : NSObject

@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) BOOL isRowFixed;
@property (nonatomic, strong) UIColor *rowBackgroundColor;
@property (nonatomic, strong) UIColor *rowSelectedBackgroundColor;
@property (nonatomic, assign) BOOL selected;
@end

@interface GTTableColumnInfo : NSObject

@property (nonatomic, assign) CGFloat columnWidht;
@property (nonatomic, assign) BOOL isColumnFixed;
@property (nonatomic, strong) UIColor *columnBackgroundColor;
@property (nonatomic, strong) UIColor *columnSelectedBackgroundColor;
@property (nonatomic, assign) BOOL selected;
@end

@interface GTTableCellInfo : NSObject

@property (nonatomic, assign) GTTableCellType type;
@property (nonatomic, weak) GTTableRowInfo *rowInfo;
@property (nonatomic, weak) GTTableColumnInfo *columnInfo;
@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, strong) UIColor *cellSelectedBackgroundColor;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *customCellIdentifier;
@end