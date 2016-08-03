//
//  JJMessageCollectionViewCell.m
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "JJMessageCollectionViewCell.h"

@interface JJMessageCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation JJMessageCollectionViewCell

#pragma mark - Action
/**
 *  删除图片
 */
- (IBAction)deleteButtonDidClick {
    if (self.messageImageDeleteBlock) {
        self.messageImageDeleteBlock();
        self.messageImageDeleteBlock = nil;
    }
}


#pragma mark - Setter
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

@end
