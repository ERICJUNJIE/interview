//
//  JJMessageViewController.m
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "JJMessageViewController.h"

@interface JJMessageViewController () <UITextViewDelegate>
/**
 *  信息输入的TextView
 */
@property (weak, nonatomic) IBOutlet UITextView *messageContentTextView;
/**
 *  占位文本
 */
@property (weak, nonatomic) IBOutlet UILabel *messageContentPlaceholderLable;
/**
 *  信息图片的CollectionView
 */
@property (weak, nonatomic) IBOutlet UICollectionView *messageCollectionView;
/**
 *  图片的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageCollectionViewHeightCons;
@end

@implementation JJMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView {
    self.messageContentPlaceholderLable.hidden = textView.hasText;
}

@end
