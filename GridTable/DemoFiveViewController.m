//
//  DemoFiveViewController.m
//  GridTable
//
//  Created by xzysun on 16/8/18.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import "DemoFiveViewController.h"

@interface DemoFiveViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet GTTableView *tableView;
@end

@implementation DemoFiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    GTTableInfo *info = [GTTableInfo tableInfoWithRows:30 Columns:20];
    [info buildTableCellInfoWithBlock:^(GTTableCellInfo *cellInfo, NSInteger row, NSInteger column) {
        //
    }];
    info.rowInofs.firstObject.rowBackgroundColor = [UIColor greenColor];
    info.rowInofs.firstObject.rowSelectedBackgroundColor = [UIColor yellowColor];
    info.columnInfos.firstObject.columnBackgroundColor = [UIColor blueColor];
    info.columnInfos.firstObject.columnSelectedBackgroundColor = [UIColor purpleColor];
    self.tableView.tableInfo = info;
    self.tableView.selectionType = GTTableViewSelectionTypeNone;
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

- (IBAction)segmentValueChangeAction:(id)sender
{
    switch (self.segment.selectedSegmentIndex) {
        case 0:
            self.tableView.selectionType = GTTableViewSelectionTypeNone;
            break;
        case 1:
            self.tableView.selectionType = GTTableViewSelectionTypeCell;
            break;
        case 2:
            self.tableView.selectionType = GTTableViewSelectionTypeRow;
            break;
        case 3:
            self.tableView.selectionType = GTTableViewSelectionTypeColumn;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}
@end
