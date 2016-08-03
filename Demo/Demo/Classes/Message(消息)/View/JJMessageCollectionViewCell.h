//
//  JJMessageCollectionViewCell.h
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJMessageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) void(^messageImageDeleteBlock)(void);

@end
