//
//  JJMessage.m
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "JJMessage.h"
#import "JJMessageTools.h"

@implementation JJMessage


#pragma mark - Getter
- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = @[].mutableCopy;
    }
    return _imageArray;
}

- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = @[].mutableCopy;
    }
    return _imageUrlArray;
}

- (NSArray *)photoArray {
    NSMutableArray *array = @[].mutableCopy;
    for (UIImage *image in self.imageArray) {
        [array addObject:[MWPhoto photoWithImage:image]];
    }
    return array.copy;
}

#pragma mark - 

- (BOOL)sendReqSaveMessage {
    return [[JJMessageTools shareMessageTools] insertMessageWithContent:self.content imageArray:self.imageUrlArray username:self.userName];
}

@end
