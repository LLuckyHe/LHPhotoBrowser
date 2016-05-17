//
//  LHPhotoView.h
//  LHPhotoBrowserDemo
//
//  Created by slihe on 16/5/17.
//  Copyright © 2016年 slihe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LHPhotoViewDelegate <NSObject>

- (void)photoViewSingleTap:(NSInteger)index;

- (BOOL)photoIsShowingPhotoViewAtIndex:(NSUInteger)index;

- (void)updatePhotoProgress:(CGFloat)progress andIndex:(NSInteger)index;

@end

@interface LHPhotoView : UIView

@property(nonatomic, strong)UIImage *itemImage;

@property(nonatomic, copy)NSString *itemImageUrl;

@property(nonatomic, assign)CGFloat itemImageProgress;

@property(nonatomic, weak)id<LHPhotoViewDelegate> photoViewDelegate;

- (void)resetSize;

@end
