//
//  DemoThreeViewController.m
//  GridTable
//
//  Created by xzysun on 16/8/14.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import "DemoThreeViewController.h"

@interface DemoThreeViewController ()

@property (nonatomic, strong) GTTableView *tableView;
@end

@implementation DemoThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[GTTableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64.0)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    GTTableInfo *info = [GTTableInfo tableInfoWithRows:50 Columns:5];
//    [info setFixedRowCount:1 FixedColumnCount:0];
    CGFloat columnWidth = CGRectGetWidth(self.view.frame)/info.columnInfos.count;
    [info.columnInfos enumerateObjectsUsingBlock:^(GTTableColumnInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.columnWidth = columnWidth;
    }];
    info.columnInfos.lastObject.columnWidth = 75.0;
    [info buildTableCellInfoWithBlock:^(GTTableCellInfo *cellInfo, NSInteger row, NSInteger column) {
        //
    }];
    self.tableView.tableInfo = info;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
