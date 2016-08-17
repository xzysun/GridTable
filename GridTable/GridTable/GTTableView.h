//
//  GTTableView.h
//  GridTable
//
//  Created by xzysun on 16/8/11.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTTableInfo.h"
#import "GTCollectionViewTextCell.h"
#import "GTPosition.h"

@class GTTableView;
@protocol GTTableViewDelegate <NSObject>

-(void)tableView:(GTTableView *)tableView didSelectCellAtPosition:(GTPosition)position;

@optional
-(void)tableview:(GTTableView *)tableview prepareTextCell:(GTCollectionViewTextCell *)textCell AtPosition:(GTPosition)position;
-(void)tableView:(GTTableView *)tableView prepareCustomCell:(UICollectionViewCell *)cell AtPosition:(GTPosition)position;

@end

typedef enum : NSUInteger {
    GTTableViewSelectionTypeNone,
    GTTableViewSelectionTypeCell,
    GTTableViewSelectionTypeRow,
    GTTableViewSelectionTypeColumn,
} GTTableViewSelectionType;

@interface GTTableView : UIView

@property (nonatomic, weak) id<GTTableViewDelegate> delegate;
@property (nonatomic, strong) GTTableInfo *tableInfo;
@property (nonatomic, assign) GTTableViewSelectionType selectionType;
@property (nonatomic, assign) BOOL allowsMultipleSelection;//not yet!

-(void)reloadData;
-(void)reloadCellAtPosition:(GTPosition)position;
-(void)registerCustomCellClass:(Class)class WithIdentifier:(NSString *)identifier;
@end
