//
//  ViewController.m
//  GridTable
//
//  Created by xzysun on 16/8/11.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import "ViewController.h"
#import "GTTableView.h"

@interface ViewController () <GTTableViewDelegate>

@property (nonatomic, strong) GTTableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Grid Table Demo";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[GTTableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64.0)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    GTTableInfo *info = [GTTableInfo tableInfoWithRows:30 Columns:20];
    info.rowInofs.firstObject.isRowFixed = YES;
    info.columnInfos.firstObject.isColumnFixed = YES;
    [info buildTableCellInfoWithBlock:^(GTTableCellInfo *cellInfo, NSInteger row, NSInteger column) {
        //
    }];
    self.tableView.tableInfo = info;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Delegate
-(void)tableView:(GTTableView *)tableView didSelectCellAtRow:(NSInteger)row Column:(NSInteger)column
{
    NSLog(@"tableview didSelectCell:%lu-%lu", row, column);
}
@end
