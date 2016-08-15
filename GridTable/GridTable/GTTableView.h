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

@class GTTableView;
@protocol GTTableViewDelegate <NSObject>

-(void)tableView:(GTTableView *)tableView didSelectCellAtRow:(NSInteger)row Column:(NSInteger)column;

@optional
-(void)tableview:(GTTableView *)tableview prepareTextCell:(GTCollectionViewTextCell *)textCell AtRow:(NSInteger)row Column:(NSInteger)column;
-(void)tableView:(GTTableView *)tableView prepareCell:(UICollectionViewCell *)cell AtRow:(NSInteger)row Column:(NSInteger)column;

@end

@interface GTTableView : UIView

@property (nonatomic, weak) id<GTTableViewDelegate> delegate;
@property (nonatomic, strong) GTTableInfo *tableInfo;

-(void)reloadData;
-(void)reloadCellAtRow:(NSUInteger)row Column:(NSUInteger)column;
-(void)registerCustomCellClass:(Class)class WithIdentifier:(NSString *)identifier;
@end
