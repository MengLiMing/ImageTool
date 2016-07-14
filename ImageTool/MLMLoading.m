//
//  MLMLoading.m
//  UIBezierPathDemo
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 FuTang. All rights reserved.
//

#import "MLMLoading.h"


static const CGFloat k_Label_H = 20;
static const CGFloat k_SELF_W = 65;
static const CGFloat k_SELF_H = 65;
static const CGFloat k_LAYER_WH = 35;

static const CGFloat k_SHAPELAYER_LW = 3;

static const CGFloat k_ANIMATION_TIME = 1;

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define IOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define K_ANGLE_START(s) (s*M_PI)/180 //角度换算

static MLMLoading *loadingView;

@interface MLMLoading ()
{
    CAShapeLayer *bottomShapeLayer;//底层
    CAShapeLayer *topShaperLayer;//顶层
    
}
@property (nonatomic, strong) UILabel *msgLabel;//显示提示消息
@property (nonatomic, strong) UIView *backView;

@end

@implementation MLMLoading

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)lm_shareLoading {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadingView = [[MLMLoading alloc] initWithFrame:[UIScreen mainScreen].bounds];
        loadingView.backgroundColor = [UIColor clearColor];
        [loadingView initView];
    });
    return loadingView;
}


- (void)initView {
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k_SELF_W, k_SELF_H)];
    if (IOS8) {
        _backView.backgroundColor = [UIColor clearColor];
        UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        visualEfView.frame = CGRectMake(0, 0, 300, 400);
        visualEfView.alpha = 1.0;
        [_backView addSubview:visualEfView];
    } else {
        _backView.backgroundColor = [UIColor blackColor];
    }
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;

    _backView.center = self.center;
    [self addSubview:_backView];
    
    _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, _backView.frame.size.height - k_Label_H, _backView.frame.size.width, k_Label_H)];
    _msgLabel.textColor = [UIColor whiteColor];
    _msgLabel.font = [UIFont systemFontOfSize:12];
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:_msgLabel];
    
    //背景layer
    bottomShapeLayer = [CAShapeLayer layer];
    bottomShapeLayer.frame = CGRectMake((k_SELF_H - k_Label_H - k_LAYER_WH)/2, (k_SELF_W - k_LAYER_WH)/2, k_LAYER_WH, k_LAYER_WH);
    bottomShapeLayer.position = CGPointMake(k_SELF_H/2, (k_SELF_H - k_Label_H)/2);
    bottomShapeLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色
    bottomShapeLayer.strokeColor = [UIColor whiteColor].CGColor;//线条颜色
    bottomShapeLayer.lineWidth = k_SHAPELAYER_LW;
    bottomShapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, k_LAYER_WH, k_LAYER_WH)].CGPath;
    [_backView.layer addSublayer:bottomShapeLayer];
    
    
    //动画layer
    topShaperLayer = [CAShapeLayer layer];
    topShaperLayer.frame = CGRectMake((k_SELF_H - k_Label_H - k_LAYER_WH)/2, (k_SELF_W - k_LAYER_WH)/2, k_LAYER_WH, k_LAYER_WH);
    topShaperLayer.position = CGPointMake(k_SELF_H/2, (k_SELF_H - k_Label_H)/2);
    topShaperLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色
    topShaperLayer.strokeColor = [UIColor darkTextColor].CGColor;//线条颜色
    topShaperLayer.lineWidth = k_SHAPELAYER_LW;
    topShaperLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, k_LAYER_WH, k_LAYER_WH)].CGPath;
    
    topShaperLayer.lineDashPattern = @[@8,@4];
    topShaperLayer.transform = CATransform3DMakeRotation(K_ANGLE_START(270), 0, 0, 1);
    
    [_backView.layer addSublayer:topShaperLayer];
    
}

#pragma mark - 动画
- (void)animationStart {
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(-1);
    strokeStartAnimation.toValue = @(1);
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0);
    strokeEndAnimation.toValue = @(1);
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
    animationGroup.duration = k_ANIMATION_TIME;
    animationGroup.repeatCount = CGFLOAT_MAX;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [topShaperLayer addAnimation:animationGroup forKey:nil];
    
}

#pragma mark - 添加
+ (void)showLoadingWithTitle:(NSString *)title {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [MLMLoading lm_shareLoading];
    loadingView.center = window.center;
    loadingView.msgLabel.text = title;
    [window addSubview:loadingView];
    [loadingView animationStart];
}

#pragma mark - 移除
+ (void)hidenLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [loadingView removeFromSuperview];
    });
}




@end
