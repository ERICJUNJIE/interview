//
//  JJDicoverTableViewCell.m
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "JJDicoverTableViewCell.h"
#import "DFFlowLayout.h"
#import "JJDiscoverCollectionViewCell.h"
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"

@interface JJDicoverTableViewCell ()<DFFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource,MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *usernameLable;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightCons;
@property (weak, nonatomic) IBOutlet DFFlowLayout *collectionViewFlowLayout;

@property (nonatomic, strong) NSMutableArray *photoArray;

@end

@implementation JJDicoverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    self.collectionViewFlowLayout.delegate = self;
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.delegate = self;
    [self.contentLable setPreferredMaxLayoutWidth:[UIScreen mainScreen].bounds.size.width - 30 - 10 - 40];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <DFFlowLayoutDelegate>
- (CGFloat)waterflowLayout:(DFFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    return itemWidth;
}

- (CGFloat)columnCountInWaterflowLayout:(DFFlowLayout *)waterflowLayout {
    return 3;
}
- (CGFloat)columnMarginInWaterflowLayout:(DFFlowLayout *)waterflowLayout {
    return 5;
}
- (CGFloat)rowMarginInWaterflowLayout:(DFFlowLayout *)waterflowLayout {
    return 5;
}
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(DFFlowLayout *)waterflowLayout {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JJDiscoverCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    [cell setUrl:[NSURL URLWithString:self.model.imageArray[indexPath.row]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] init];
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    browser.delegate = self;
    [[[self viewController] navigationController] pushViewController:browser animated:YES];
}

#pragma mark - <MWPhotoBrowserDelegate>
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photoArray.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return self.photoArray[index];
}

#pragma mark - Getter
- (CGFloat)cellHeight {
    //总数
    NSInteger count = self.model.imageArray.count;
    //行数
    NSInteger rowCount = (count - 1) / 3 + 1;
    //计算高度
    CGFloat itemH = ([UIScreen mainScreen].bounds.size.width * 2 / 3.0 - 10) / 3;
    CGFloat height = itemH * rowCount + (rowCount - 1) * 5;
    self.collectionViewHeightCons.constant = height;
    return CGRectGetMinY(self.imageCollectionView.frame) + 30 + height;
}

#pragma mark - Setter
- (void)setModel:(JJMessageModel *)model {
    _model = model;
    self.contentLable.text = model.content;
    self.usernameLable.text = model.userName;
    [self.imageCollectionView reloadData];
    [self parsePhotos];
}

#pragma mark - Getter
- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = @[].mutableCopy;
    }
    return _photoArray;
}

#pragma mark - private
- (void)parsePhotos {
    [self.photoArray removeAllObjects];
    for (NSString *str in self.model.imageArray) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:str]];
        [self.photoArray addObject:photo];
    }
}

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
