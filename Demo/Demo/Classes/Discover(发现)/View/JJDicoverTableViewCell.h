//
//  JJDicoverTableViewCell.h
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJMessageModel.h"

@interface JJDicoverTableViewCell : UITableViewCell

@property (nonatomic, strong) JJMessageModel *model;

- (CGFloat)cellHeight;

@end
