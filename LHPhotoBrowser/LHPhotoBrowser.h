//
//  LHPhotoBrowser.h
//  LHPhotoBrowserDemo
//
//  Created by slihe on 16/5/17.
//  Copyright © 2016年 slihe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHPhotoBrowser : UIViewController

@property(nonatomic, strong)NSArray *imgsArray;

@property(nonatomic, strong)NSArray *imgUrlsArray;

@property(nonatomic, assign)NSInteger tapImgIndex;

@property(nonatomic, assign)BOOL hideStatusBar;

- (void)show;

- (void)showWithPush:(UIViewController *)superVc;
@end
