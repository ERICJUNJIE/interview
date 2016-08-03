//
//  DFFlowLayout.h
//  DoingForceOA
//
//  Created by Eric on 16/7/6.
//  Copyright © 2016年 DoingForce. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DFFlowLayout;

@protocol DFFlowLayoutDelegate <NSObject>
@required
- (CGFloat)waterflowLayout:(DFFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(DFFlowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(DFFlowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(DFFlowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(DFFlowLayout *)waterflowLayout;
@end

@interface DFFlowLayout : UICollectionViewFlowLayout

/** 代理 */
@property (nonatomic, weak) id<DFFlowLayoutDelegate> delegate;

@end
