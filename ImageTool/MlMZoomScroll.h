//
//  MlMZoomScroll.h
//  ImageTool
//
//  Created by my on 16/6/18.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MlMZoomScroll : UIScrollView


@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, copy) void(^singleTap)();

- (void)setImage:(UIImage *)image;

- (void)showIndicator;
- (void)hidenIndicator;

@end
