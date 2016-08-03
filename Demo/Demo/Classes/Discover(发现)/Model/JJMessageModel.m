//
//  JJMessageModel.m
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "JJMessageModel.h"

@implementation JJMessageModel

- (NSArray *)imageArray {
    if ([_imageArray isKindOfClass:[NSArray class]]) {
        return _imageArray;
    }
    return nil;
}

@end
