//
//  JJDiscoverCollectionViewCell.m
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "JJDiscoverCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface  JJDiscoverCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation JJDiscoverCollectionViewCell

- (void)setUrl:(NSURL *)url {
    _url = url;
    __weak typeof(self) weekSelf = self;
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        UIImage *image = [UIImage imageWithCGImage:rep.fullScreenImage];
        weekSelf.imageView.image = image;
    } failureBlock:^(NSError *error) {
        weekSelf.imageView.image = [UIImage imageNamed:@"default_icon"];
    }];
}

@end
