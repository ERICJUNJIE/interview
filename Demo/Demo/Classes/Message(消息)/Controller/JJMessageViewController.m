//
//  JJMessageViewController.m
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "JJMessageViewController.h"
#import "DFFlowLayout.h"
#import "JJMessage.h"
#import "NSObject+Common.h"
#import <AVFoundation/AVFoundation.h>
#import "JJMessageCollectionViewCell.h"
#import "MWPhotoBrowser.h"

@interface JJMessageViewController () <UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,DFFlowLayoutDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,MWPhotoBrowserDelegate>
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
@property (weak, nonatomic) IBOutlet DFFlowLayout *messageCollectionViewFlowLayout;
/**
 *  图片的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageCollectionViewHeightCons;

@property (nonatomic, strong) JJMessage *message;
@property (nonatomic, strong) NSArray *photoArray;

@end

@implementation JJMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.messageCollectionViewFlowLayout.delegate = self;
    
    self.message = [JJMessage new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self resetCons];
}

#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView {
    self.messageContentPlaceholderLable.hidden = textView.hasText;
}

#pragma mark - <DFFlowLayoutDelegate>
- (CGFloat)waterflowLayout:(DFFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    return itemWidth;
}

- (CGFloat)columnCountInWaterflowLayout:(DFFlowLayout *)waterflowLayout {
    return 4;
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
    if (self.message.imageArray.count < 9) {
        return self.message.imageArray.count + 1;
    }
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.message.imageArray.count  && self.message.imageArray.count != 9) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell_plus" forIndexPath:indexPath];
        return cell;
    }
    JJMessageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    [cell setImage:self.message.imageArray[indexPath.row]];
    [cell setMessageImageDeleteBlock:^{
        [self.message.imageArray removeObjectAtIndex:indexPath.row];
        [self.messageCollectionView reloadData];
        self.photoArray = [self.message photoArray];
        [self resetCons];
    }];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.message.imageArray.count  && self.message.imageArray.count != 9) {
        [self selectPicture];
    }else {
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
        [self.navigationController pushViewController:browser animated:YES];
    }
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photoArray.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return self.photoArray[index];
}

#pragma mark - <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    UIImage *originalImage = info[@"UIImagePickerControllerOriginalImage"];
    [[self.message mutableArrayValueForKey:@"imageArray"] addObject:originalImage];
    [self.messageCollectionView reloadData];
    self.photoArray = [self.message photoArray];
    [self resetCons];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action
- (void)selectPicture {
    //1.判断相机是否可用
    BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!cameraAvailable) {
        [NSObject showHudTipStr:@"相机不可用"];
        return;
    }
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        [NSObject showHudTipStr:@"相机授权受限，请到设置中打开"];
        return;
    }
    //1.判断设置是否可用
    BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    //2.如果两个都可以用的话就弹出选择的actionSheet
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    if (photoLibraryAvailable && cameraAvailable) {
        __weak typeof(self) weekSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [imagePickerVC setSourceType:UIImagePickerControllerSourceTypeCamera];
            [weekSelf presentViewController:imagePickerVC animated:YES completion:nil];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [imagePickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [weekSelf presentViewController:imagePickerVC animated:YES completion:nil];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (cameraAvailable) {
        [imagePickerVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }else if (photoLibraryAvailable) {
        [imagePickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

#pragma mark - Private 
- (void)resetCons {
    //总数
    NSInteger count = self.message.imageArray.count;
    //行数
    NSInteger rowCount = count / 4 + 1;
    //计算高度
    CGFloat itemH = ([UIScreen mainScreen].bounds.size.width - 30 - 15) / 4;
    
    CGFloat height = 20;
    height += itemH * rowCount + (rowCount - 1) * 5;
    self.messageCollectionViewHeightCons.constant = height;

}

@end
