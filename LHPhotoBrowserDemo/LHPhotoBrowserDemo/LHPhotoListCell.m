//
//  LHPhotoListCell.m
//  LHPhotoBrowserDemo
//
//  Created by slihe on 16/5/17.
//  Copyright © 2016年 slihe. All rights reserved.
//

#import "LHPhotoListCell.h"
#import "LHPhotoBrowser.h"

#define ImgCount 3
#define LeftMargin 20
#define MidMargin 10
#define ImgW (([UIScreen mainScreen].bounds.size.width - 2 * LeftMargin - (ImgCount - 1) * MidMargin) / ImgCount)
#define ImgH ImgW
#define ImgTop 10

@interface LHPhotoListCell ()

@property(nonatomic, strong)NSArray *imgContainerArray;

@end

@implementation LHPhotoListCell

+(id)LHPhotoListCellWithTableView:(UITableView *)tableView
{
    static NSString *Id = @"lhPhotoListCell";
    
    LHPhotoListCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell) {
        [tableView registerClass:[self class] forCellReuseIdentifier:Id];
        cell = [tableView dequeueReusableCellWithIdentifier:Id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setImgs:(NSArray *)imgs
{
    
    _imgs = imgs;
    
    NSMutableArray *tmpImgRectArray = [NSMutableArray array];
    
    for(UIView *view in self.contentView.subviews){
        [view removeFromSuperview];
    }
    
    for(int i=0;i<imgs.count;i++){
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:imgs[i]];
        imageView.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)];
        [imageView addGestureRecognizer:tap];
        
        NSInteger col = i % 3;
        NSInteger row = i / 3;
        
        imageView.frame = CGRectMake(LeftMargin + (MidMargin + ImgW) * col, ImgTop + (MidMargin + ImgH) * row, ImgW, ImgH);
        
        [self.contentView addSubview:imageView];
        
        [tmpImgRectArray addObject:imageView];
        
    }
    
    _imgContainerArray = [tmpImgRectArray copy];
    
}

- (void)imgClick:(UITapGestureRecognizer *)tap
{
    
    UIView *view = tap.view;
    
    LHPhotoBrowser *bc = [[LHPhotoBrowser alloc] init];
    
    bc.imgsArray = _imgContainerArray;
    bc.imgUrlsArray = _imgUrls;
    bc.tapImgIndex = view.tag;
    
    [bc show];
    
}

+ (CGFloat)cellHeight:(NSInteger)imgNum
{
    if (imgNum == 0) {
        imgNum = 1;
    }
    
    NSInteger rowCount = (imgNum - 1) / 3;
    
    return 2 * ImgTop + ImgH + (MidMargin + ImgH) * rowCount;
}

@end
