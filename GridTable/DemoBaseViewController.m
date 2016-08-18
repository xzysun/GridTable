//
//  DemoBaseViewController.m
//  GridTable
//
//  Created by xzysun on 16/8/18.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import "DemoBaseViewController.h"

@interface DemoBaseViewController ()

@end

@implementation DemoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
