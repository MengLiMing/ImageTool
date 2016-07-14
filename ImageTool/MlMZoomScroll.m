//
//  MlMZoomScroll.m
//  ImageTool
//
//  Created by my on 16/6/18.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "MlMZoomScroll.h"

@interface MlMZoomScroll () <UIScrollViewDelegate>

@end

@implementation MlMZoomScroll

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        
        //代理
        self.delegate = self;
        //添加手势
        [self addGesture];
        //设置伸缩比例
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1;
    }
    return self;
}


#pragma mark - 动画
- (void)showIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.indicator.hidden = NO;
        [self.indicator startAnimating];
    });

}

- (void)hidenIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.indicator.hidden = YES;
        [self.indicator stopAnimating];
    });
}

#pragma mark - 初始化
- (void)initView {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.center = self.center;
    [self addSubview:self.imageView];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.center = self.center;
    [self addSubview:self.indicator];
    
}

- (void)setImage:(UIImage *)image {
    if (!image) {
        self.imageView.image = nil;
        return;
    }
    //确定imageView的frame
    CGRect frame;
    //计算显示的图片宽和高
    CGFloat imageScale = image.size.width/image.size.height;//图片宽高比
    CGFloat selfScale = self.frame.size.width/self.frame.size.height;//图片宽高比
    if (selfScale >= imageScale) {
        frame = CGRectMake(0, 0, imageScale*self.frame.size.height, self.frame.size.height);
    } else {
        frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width/imageScale);
    }
    
    self.imageView.frame = frame;
    [self.imageView setImage:image];
    self.imageView.center = self.center;

}

#pragma mark - 添加手势
- (void)addGesture {
    //单击手势
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapOnScrollView:)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
    //双击手势
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapOnScrollView:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
}

//手势方法
- (void)singleTapOnScrollView:(UITapGestureRecognizer *)tap {
    if (self.singleTap) {
        self.singleTap();
    }
}

- (void)doubleTapOnScrollView:(UITapGestureRecognizer *)tap {
    CGFloat scale = 1;
    if (self.zoomScale !=3) {
        scale = 3;
    } else {
        scale = 1;
    }
    [self zoomToScale:scale withCenter:[tap locationInView:self] completion:^(CGRect rect) {
        [self zoomToRect:rect animated:YES];
    }];
}

//以点击中心放大
- (void)zoomToScale:(CGFloat)scale withCenter:(CGPoint)center completion:(void(^)(CGRect Rect))completion {
    //内容放大scale，截取图片的大小宽度肯定是scrollView的frame大小的1/scale
    CGRect rect;
    rect.size.height = self.frame.size.height / scale;
    rect.size.width  = self.frame.size.width  / scale;
    rect.origin.x    = center.x - (rect.size.width  /2.0);
    rect.origin.y    = center.y - (rect.size.height /2.0);
    completion(rect);}

#pragma mark - scrollViewDelegate
//返回一个放大或缩小的视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

//保持操作的图片居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}


@end
