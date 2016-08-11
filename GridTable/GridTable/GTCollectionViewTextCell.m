//
//  GTCollectionViewTextCell.m
//  GridTable
//
//  Created by xzysun on 16/8/11.
//  Copyright © 2016年 AnyApps. All rights reserved.
//

#import "GTCollectionViewTextCell.h"

@implementation GTCollectionViewTextCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

-(UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_label];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:16.0];
    }
    return _label;
}
@end
