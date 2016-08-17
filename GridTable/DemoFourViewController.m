//
//  DemoFourViewController.m
//  GridTable
//
//  Created by xzysun on 16/8/14.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import "DemoFourViewController.h"
#import "GTTableView.h"

@interface DemoFourViewController () <GTTableViewDelegate>

@property (weak, nonatomic) IBOutlet GTTableView *tableView;
@end

@implementation DemoFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    GTTableInfo *info = [GTTableInfo tableInfoWithRows:300 Columns:60];
    [info setFixedRowCount:2 FixedColumnCount:1];
    [info buildTableCellInfoWithBlock:^(GTTableCellInfo *cellInfo, NSInteger row, NSInteger column) {
        //
    }];
    info.rowInofs.firstObject.rowBackgroundColor = [UIColor greenColor];
    info.rowInofs.firstObject.rowSelectedBackgroundColor = [UIColor yellowColor];
    info.columnInfos.firstObject.columnBackgroundColor = [UIColor blueColor];
    info.columnInfos.firstObject.columnSelectedBackgroundColor = [UIColor purpleColor];
    self.tableView.tableInfo = info;
    self.tableView.selectionType = GTTableViewSelectionTypeCell;
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
