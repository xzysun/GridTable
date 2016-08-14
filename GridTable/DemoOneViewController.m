//
//  DemoOneViewController.m
//  GridTable
//
//  Created by xzysun on 16/8/14.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import "DemoOneViewController.h"
#import "GTTableView.h"

@interface DemoOneViewController () <GTTableViewDelegate>

@property (nonatomic, strong) GTTableView *tableView;
@end

@implementation DemoOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[GTTableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64.0)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    GTTableInfo *info = [GTTableInfo tableInfoWithRows:50 Columns:30];
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

#pragma mark - TableView Delegate
-(void)tableView:(GTTableView *)tableView didSelectCellAtRow:(NSInteger)row Column:(NSInteger)column
{
    NSLog(@"tableview didSelectCell:%lu-%lu", row, column);
}
@end