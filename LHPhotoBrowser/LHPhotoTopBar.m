//
//  LHPhotoTopBar.m
//  LHPhotoBrowserDemo
//
//  Created by Saiko－01 on 16/6/20.
//  Copyright © 2016年 slihe. All rights reserved.
//

#import "LHPhotoTopBar.h"

@interface LHPhotoTopBar ()
{
    UILabel *_pageLabel;
    UIImageView *_bgImage;
}

@end

@implementation LHPhotoTopBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        CGSize bgSize = CGSizeMake(MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) , 64);
        
        UIGraphicsBeginImageContextWithOptions(bgSize, NO, 0.f);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
        
        CGFloat compoents[8]={
            0,0,0,0.0,
            0,0,0,0.4
        };
        
        CGFloat locations[2]={0,1.0};
        
        CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 2);
        
        CGContextDrawLinearGradient(context, gradient, CGPointMake(self.bounds.size.width / 2, self.bounds.size.height), CGPointMake(self.bounds.size.width / 2, 0), 4);
        
        _bgImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - bgSize.width) / 2, 0, bgSize.width, bgSize.height)];
        _bgImage.userInteractionEnabled = YES;
        _bgImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
        
        [self addSubview:_bgImage];
        
        _pageLabel = [[UILabel alloc] init];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _pageLabel.text = @"";
        [self addSubview:_pageLabel];
        
    }
    
    return self;
}

- (void)setPageNum:(NSInteger)pageNum andAllPageNum:(NSInteger)allPageNum
{
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", pageNum, allPageNum];
    [_pageLabel sizeToFit];
    _pageLabel.frame = CGRectMake((self.bounds.size.width - _pageLabel.bounds.size.width) / 2, (self.bounds.size.height - _pageLabel.bounds.size.height) / 2, _pageLabel.bounds.size.width, _pageLabel.bounds.size.height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _pageLabel.frame = CGRectMake((self.bounds.size.width - _pageLabel.bounds.size.width) / 2, (self.bounds.size.height - _pageLabel.bounds.size.height) / 2, _pageLabel.bounds.size.width, _pageLabel.bounds.size.height);
    
    _bgImage.frame = CGRectMake((self.bounds.size.width - _bgImage.bounds.size.width) / 2, 0, _bgImage.bounds.size.width, _bgImage.bounds.size.height);
    
}

@end
