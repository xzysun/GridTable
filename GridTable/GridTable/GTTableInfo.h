//
//  GTTableInfo.h
//  GridTable
//
//  Created by xzysun on 16/8/11.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kGridTableDefaultRowHeight = 40.0;
static CGFloat const kGridTableDefaultColumnWidth = 60.0;
static NSString * const kGridTableTextCellIdentifier = @"kGridTableTextCellIdentifier";

@class GTTableRowInfo;
@class GTTableColumnInfo;
@class GTTableCellInfo;

typedef void(^GTCellDataBuildBlock)(GTTableCellInfo *cellInfo, NSInteger row, NSInteger column);

@interface GTTableInfo : NSObject

@property (nonatomic, strong, readonly) NSArray<GTTableRowInfo *> *rowInofs;
@property (nonatomic, strong, readonly) NSArray<GTTableColumnInfo *> *columnInfos;
@property (nonatomic, strong, readonly) NSArray<NSArray<GTTableCellInfo *> *> *cellInfos;

+(instancetype)tableInfoWithRows:(NSUInteger)rows Columns:(NSUInteger)columns;

-(void)buildTableCellInfoWithBlock:(GTCellDataBuildBlock)block;

-(GTTableRowInfo *)addRowWithDataBuildBlock:(GTCellDataBuildBlock)block;

-(GTTableColumnInfo *)addColumnWithDataBuildBlock:(GTCellDataBuildBlock)block;

-(void)removeRow:(NSUInteger)row;

-(void)removeColumn:(NSUInteger)column;

-(GTTableCellInfo *)cellForRow:(NSUInteger)row Column:(NSUInteger)column;

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

@property (nonatomic, weak, readonly) GTTableRowInfo *rowInfo;
@property (nonatomic, weak, readonly) GTTableColumnInfo *columnInfo;
@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, strong) UIColor *cellSelectedBackgroundColor;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *cellIdentifier;
//@property (nonatomic, copy) NSString *cellClassName;
@property (nonatomic, strong) NSDictionary *textAttribute;//for text cell
@end