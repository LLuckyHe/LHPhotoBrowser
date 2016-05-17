//
//  LHPhotoView.m
//  LHPhotoBrowserDemo
//
//  Created by slihe on 16/5/17.
//  Copyright © 2016年 slihe. All rights reserved.
//

#import "LHPhotoView.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "LHProgressView.h"

#define ScreenW self.bounds.size.width
#define ScreenH self.bounds.size.height
#define ScreenScale [UIScreen mainScreen].scale
#define kMinProgress 0.0001

@interface LHPhotoView ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *scrollView;

@property(nonatomic, strong)LHProgressView *progressView;

@property(nonatomic, strong)UIImageView *itemImageView;

@property(nonatomic, assign)CGFloat fillScale;

@property(nonatomic, assign)CGSize imageRealSize;

@end

@implementation LHPhotoView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        [_scrollView addSubview:self.itemImageView];
        
        _progressView = [[LHProgressView alloc] init];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
    }
    
    return self;
}

- (UIImageView *)itemImageView
{
    if (!_itemImageView) {
        _itemImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_itemImageView setContentMode:UIViewContentModeScaleAspectFill];
        _itemImageView.clipsToBounds = YES;
    }
    
    return _itemImageView;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _scrollView.frame = self.bounds;
    
    _progressView.center = CGPointMake((self.bounds.size.width) / 2, (self.bounds.size.height) / 2);
}

- (void)setItemImage:(UIImage *)itemImage
{
    _itemImage = itemImage;
    
}

- (void)setItemImageUrl:(NSString *)itemImageUrl
{
    _itemImageUrl = itemImageUrl;
    
    BOOL imageExist = [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:itemImageUrl]];
    
    if (_itemImageProgress == 1.0 || imageExist) {
        
        [_progressView removeFromSuperview];
        
    } else {
        
        _progressView.bounds = CGRectMake(0, 0, 50, 50);
        _progressView.center = CGPointMake((self.bounds.size.width) / 2, (self.bounds.size.height) / 2);
        [self addSubview:_progressView];
        
        _progressView.progress = _itemImageProgress;
        
    }
    
    _itemImageView.image = _itemImage;
    
    [self resetSize];
    
    __weak LHProgressView *progressView = _progressView;
    __weak LHPhotoView *photoView = self;
    NSInteger index = self.tag - 1;
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:itemImageUrl] options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        if ([photoView.photoViewDelegate respondsToSelector:@selector(photoIsShowingPhotoViewAtIndex:)]) {
            BOOL isShow = [photoView.photoViewDelegate photoIsShowingPhotoViewAtIndex:index];
            
            if (isShow) {
                if (receivedSize > kMinProgress) {
                    progressView.progress = (float)receivedSize/expectedSize;
                }
            }
            
        }
        
        if ([photoView.photoViewDelegate respondsToSelector:@selector(updatePhotoProgress:andIndex:)]) {
            [photoView.photoViewDelegate updatePhotoProgress:(float)receivedSize/expectedSize andIndex:index];
        }
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        if (image) {
            if ([photoView.photoViewDelegate respondsToSelector:@selector(photoIsShowingPhotoViewAtIndex:)]) {
                BOOL isShow = [photoView.photoViewDelegate photoIsShowingPhotoViewAtIndex:index];
                
                if (isShow) {
                    photoView.itemImageView.image = image;
                    
                    [self resetSize];
                }
                
            }
            
            if ([photoView.photoViewDelegate respondsToSelector:@selector(updatePhotoProgress:andIndex:)]) {
                [photoView.photoViewDelegate updatePhotoProgress:1.0 andIndex:index];
            }
        }
        
        
    }];
    
}

- (void)centerContent
{
    
    CGRect frame = _itemImageView.frame;
    
    CGFloat top = 0, left = 0;
    if (_scrollView.contentSize.width < _scrollView.bounds.size.width) {
        left = (_scrollView.bounds.size.width - _scrollView.contentSize.width) * 0.5f;
    }
    if (_scrollView.contentSize.height < _scrollView.bounds.size.height) {
        top = (_scrollView.bounds.size.height - _scrollView.contentSize.height) * 0.5f;
    }
    
    top -= frame.origin.y;
    left -= frame.origin.x;
    
    _scrollView.contentInset = UIEdgeInsetsMake(top, left, top, left);
    
}


- (void)checkSize
{
    
    if (_itemImageView.image) {
        
        _scrollView.zoomScale = 1.0;
        
        CGFloat imageViewW = self.bounds.size.width;
        CGFloat imageViewH = imageViewW * _itemImageView.image.size.height / _itemImageView.image.size.width;
        CGFloat imageViewX = 0;
        CGFloat imageViewY = 0;
        
        _itemImageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
        
        _imageRealSize = CGSizeMake(_itemImageView.image.size.width * _itemImageView.image.scale / ScreenScale, _itemImageView.image.size.height * _itemImageView.image.scale / ScreenScale);
        
        CGFloat maxScale = 1.0;
        CGFloat minScale = 1.0;
        
        if(ScreenW < ScreenH){
            
            if (_itemImageView.bounds.size.height < _itemImageView.bounds.size.width) {
                
                _fillScale = ScreenH / _itemImageView.bounds.size.height;
                maxScale = _fillScale;
                minScale = _imageRealSize.width / _itemImageView.bounds.size.width;
                
                if (_imageRealSize.width * 3 / imageViewW > maxScale) {
                    maxScale = _imageRealSize.width * 3 / imageViewW;
                }
                
                if (minScale > 1.0) {
                    minScale = 1.0;
                }
                
            } else {
                
                maxScale = _imageRealSize.width * 3 / imageViewW;
                minScale = _imageRealSize.width / imageViewW;
                
                if (maxScale < 1.0) {
                    maxScale = 1.0;
                }
                
                if (minScale > 1.0) {
                    minScale = 1.0;
                }
                
            }
            
        } else {
            
            if (_itemImageView.bounds.size.width / _itemImageView.bounds.size.height > ScreenW / ScreenH) {
                
                _fillScale = ScreenH / _itemImageView.bounds.size.height;
                maxScale = _fillScale;
                minScale = _imageRealSize.width / _itemImageView.bounds.size.width;
                
                if (_imageRealSize.width * 3 / imageViewW > maxScale) {
                    maxScale = _imageRealSize.width * 3 / imageViewW;
                }
                
                if (minScale > 1.0) {
                    minScale = 1.0;
                }
                
            } else {
                
                maxScale = _imageRealSize.width * 3 / imageViewW;
                minScale = _imageRealSize.width / imageViewW;
                
                if (maxScale < 1.0) {
                    maxScale = 1.0;
                }
                
                if (minScale > 1.0) {
                    minScale = 1.0;
                }
                
            }
            
        }
        
        _scrollView.maximumZoomScale = maxScale;
        _scrollView.minimumZoomScale = minScale;
        
    } else {
        
        _itemImageView.frame = self.bounds;
        
    }
    
    _scrollView.contentSize = _itemImageView.bounds.size;
    
    [self centerContent];
    
}

- (void)resetSize
{
    
    [self checkSize];
    
    if (_scrollView.contentInset.top == 0) {
        _scrollView.contentOffset = CGPointZero;
    }
}

- (void)singleTap:(UITapGestureRecognizer *)singleTap
{
    
//    [[SDWebImageManager sharedManager].imageCache clearMemory];
//    [[SDWebImageManager sharedManager].imageCache clearDisk];
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
        [self.photoViewDelegate photoViewSingleTap:self.tag];
    }
    
}

- (void)doubleTap:(UITapGestureRecognizer *)doubleTap
{
    
    CGPoint location = [doubleTap locationInView:_itemImageView];
    
    if(ScreenW < ScreenH){
        
        if (_itemImageView.bounds.size.height < _itemImageView.bounds.size.width) {
            
            if (_scrollView.zoomScale == _scrollView.maximumZoomScale || fabs(_scrollView.zoomScale - _fillScale) < 0.00001) {
                
                [_scrollView setZoomScale:1.0 animated:YES];
                
            } else {
                
                CGFloat locationX = location.x;
                
                CGRect zoomRect = CGRectMake(locationX, 0, ScreenW / _fillScale, _itemImageView.bounds.size.height);
                
                [_scrollView zoomToRect:zoomRect animated:YES];
                
            }
            
        } else {
            
            if (_scrollView.zoomScale == _scrollView.maximumZoomScale) {
                
                if (_scrollView.maximumZoomScale == 1.0) {
                    
                    CGRect zoomRect = CGRectMake(0, location.y - ScreenH / 2, _itemImageView.bounds.size.width, ScreenH);
                    
                    [_scrollView zoomToRect:zoomRect animated:YES];
                    
                } else {
                    
                    [_scrollView setZoomScale:1.0 animated:YES];
                    
                }
                
            } else {
                
                CGFloat locationX = location.x;
                CGFloat locationY = location.y;
                
                CGRect zoomRect = CGRectMake(locationX, locationY, 1, 1);
                
                [_scrollView zoomToRect:zoomRect animated:YES];
                
            }
            
        }
        
    } else {
        
        if (_itemImageView.bounds.size.width / _itemImageView.bounds.size.height > ScreenW / ScreenH) {
            
            if (_scrollView.zoomScale == _scrollView.maximumZoomScale ||fabs(_scrollView.zoomScale - _fillScale) < 0.00001) {
                
                [_scrollView setZoomScale:1.0 animated:YES];
                
            } else {
                
                CGFloat locationX = location.x;
                
                CGRect zoomRect = CGRectMake(locationX, 0, ScreenW / _fillScale, _itemImageView.bounds.size.height);
                
                [_scrollView zoomToRect:zoomRect animated:YES];
                
            }
            
        } else if(_itemImageView.bounds.size.height < _itemImageView.bounds.size.width){
            
            CGRect zoomRect = CGRectMake(0, location.y - ScreenH / 2, _itemImageView.bounds.size.width, ScreenH);
            
            [_scrollView zoomToRect:zoomRect animated:YES];
            
        } else {
            
            if (_scrollView.zoomScale == _scrollView.maximumZoomScale) {
                
                if (_scrollView.maximumZoomScale == 1.0) {
                    
                    CGRect zoomRect = CGRectMake(0, location.y - ScreenH / 2, _itemImageView.bounds.size.width, ScreenH);
                    
                    [_scrollView zoomToRect:zoomRect animated:YES];
                    
                } else {
                    
                    [_scrollView setZoomScale:1.0 animated:YES];
                    
                }
                
            } else {
                
                CGFloat locationX = location.x;
                CGFloat locationY = location.y;
                
                CGRect zoomRect = CGRectMake(locationX, locationY, 1, 1);
                
                [_scrollView zoomToRect:zoomRect animated:YES];
                
            }
            
        }
        
    }
    
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.itemImageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerContent];
}

@end
