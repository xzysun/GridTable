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
#import "GTCellPosition.h"

@class GTTableView;
@protocol GTTableViewDelegate <NSObject>

-(void)tableView:(GTTableView *)tableView didSelectCellAt:(GTCellPosition)position;

@optional
-(void)tableview:(GTTableView *)tableview prepareTextCell:(GTCollectionViewTextCell *)textCell At:(GTCellPosition)position;
-(void)tableView:(GTTableView *)tableView prepareCustomCell:(UICollectionViewCell *)cell At:(GTCellPosition)position;

@end

@interface GTTableView : UIView

@property (nonatomic, weak) id<GTTableViewDelegate> delegate;
@property (nonatomic, strong) GTTableInfo *tableInfo;

-(void)reloadData;
-(void)reloadCellAtPosition:(GTCellPosition)position;
-(void)registerCustomCellClass:(Class)class WithIdentifier:(NSString *)identifier;
@end
