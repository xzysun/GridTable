//
//  DemoTwoViewController.m
//  GridTable
//
//  Created by xzysun on 16/8/14.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import "DemoTwoViewController.h"
#import "GTTableView.h"

@interface DemoTwoViewController () <GTTableViewDelegate>

@property (weak, nonatomic) IBOutlet GTTableView *tableView;
@end

@implementation DemoTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    GTTableInfo *info = [GTTableInfo tableInfoWithRows:50 Columns:30];
    [info buildTableCellInfoWithBlock:^(GTTableCellInfo *cellInfo, NSInteger row, NSInteger column) {
        //
    }];
    info.rowInofs.firstObject.rowBackgroundColor = [UIColor greenColor];
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
-(void)tableView:(GTTableView *)tableView didSelectCellAtPosition:(GTPosition)position
{
    NSLog(@"tableview didSelectCell:%@", NSStringFromGTPosition(position));
}

-(void)tableview:(GTTableView *)tableview prepareTextCell:(GTCollectionViewTextCell *)textCell AtPosition:(GTPosition)position
{
    textCell.label.text = [NSString stringWithFormat:@"%ld - %ld",(long)(position.row), (long)(position.column)];
}
@end
