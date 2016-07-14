//
//  AlertViewShow.m
//  AlertView
//
//  Created by my on 16/5/19.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "AlertViewShow.h"
#import "AlertViewHead.h"

typedef NS_ENUM(NSInteger,AlertShowType) {
    AlertShowTypeHead,//只要头部
    AlertShowTypeHeadContent,//头部和内容
    AlertShowTypeHeadButtons,//头部和按钮
    AlertShowTypeAll//头，内容，按钮
};

@interface AlertViewShow ()
{
    AlertShowType showType;
}
/**
 * 用于展示弹出视图的view
 */
@property (nonatomic, strong) UIView *showView;

/**
 * 背景层
 */
@property (nonatomic, strong) UIToolbar *cover;

/**
 * 偏移量
 * 默认为0
 */
@property (nonatomic, assign) CGFloat offsetY;

@end

@implementation AlertViewShow
#pragma mark -提示框
+ (void)showHint:(NSString *)str {
    [AlertHeadView showHint:str];
}

+ (void)showHint:(NSString *)str offSetY:(CGFloat)offsetY {
    [AlertHeadView showHint:str offSetY:offsetY];
}

#pragma mark - 工厂方法
- (instancetype)initWithType:(AlertHeadType)type
                       title:(NSString *)title
                       image:(UIImage *)image {
    if (self = [super init]) {
        _headView = [[AlertHeadView alloc] initWithType:type title:title image:image];
        showType = AlertShowTypeHead;
    }
    return self;
}

- (instancetype)initWithGraphic:(AlertHeadGraphicType)type
                          title:(NSString *)title
                          image:(UIImage *)image {
    if (self = [super init]) {
        _headView = [[AlertHeadView alloc] initWithGraphic:type title:title image:image];
        showType = AlertShowTypeHead;
    }
    return self;
}

- (instancetype)initHeadType:(AlertHeadGraphicType)headType
                   headTitle:(NSString *)headTitle
                   headImage:(UIImage *)headImage
                 contentType:(AlertHeadGraphicType)contentType
                contentTitle:(NSString *)contentTitle
                contentImage:(UIImage *)contentImage {
    if (self = [super init]) {
        if (headTitle && headImage) {
            _headView = [[AlertHeadView alloc] initWithGraphic:headType title:headTitle image:headImage];
        } else {
            if (headTitle) {
                _headView = [[AlertHeadView alloc] initWithType:AlertHeadTypeCustom title:headTitle image:headImage];
            }
            if (headImage) {
                _headView = [[AlertHeadView alloc] initWithType:AlertHeadTypeImage title:headTitle image:headImage];
            }
        }
        
        if (contentTitle && contentImage) {
            _contentView = [[AlertHeadView alloc] initWithGraphic:contentType title:contentTitle image:contentImage];
        } else {
            if (contentTitle) {
                _contentView = [[AlertHeadView alloc] initWithType:AlertHeadTypeCustom title:contentTitle image:contentImage];
            }
            if (contentImage) {
                _contentView = [[AlertHeadView alloc] initWithType:AlertHeadTypeImage title:contentTitle image:contentImage];
            }
        }
        showType = AlertShowTypeHeadContent;
    }
    return self;
}

- (instancetype)initHeadTitle:(NSString *)title contentTitle:(NSString *)content {
    self = [[AlertViewShow alloc] initHeadType:0 headTitle:title headImage:nil contentType:0 contentTitle:content contentImage:nil];
    return self;
}

- (instancetype)initWithGraphic:(AlertHeadGraphicType)type title:(NSString *)title image:(UIImage *)image buttonType:(NSArray *)typeArray buttonsArray:(NSArray *)buttons tapBlock:(TapIndex)block {
    self = [[AlertViewShow alloc] initWithGraphic:type title:title image:image];
    _buttonsView = [[AlertButtonsView alloc] initWithTypeArray:typeArray buttonsArray:buttons tapBlock:block];
    showType = AlertShowTypeHeadButtons;

    return self;
}

- (instancetype)initHeadTitle:(NSString *)title contentTitle:(NSString *)content buttonType:(NSArray *)typeArray buttonsArray:(NSArray *)buttons tapBlock:(TapIndex)block {
    self = [[AlertViewShow alloc] initHeadTitle:title contentTitle:content];
    _buttonsView = [[AlertButtonsView alloc] initWithTypeArray:typeArray buttonsArray:buttons tapBlock:block];
    showType = AlertShowTypeAll;
    return self;
}


- (instancetype)initHeadType:(AlertHeadGraphicType)headType headTitle:(NSString *)headTitle headImage:(UIImage *)headImage contentType:(AlertHeadGraphicType)contentType contentTitle:(NSString *)contentTitle contentImage:(UIImage *)contentImage buttonType:(NSArray *)typeArray buttonsArray:(NSArray *)buttons tapBlock:(TapIndex)block {
    self = [[AlertViewShow alloc] initHeadType:headType headTitle:headTitle headImage:headImage contentType:contentType contentTitle:contentTitle contentImage:contentImage];
    _buttonsView = [[AlertButtonsView alloc] initWithTypeArray:typeArray buttonsArray:buttons tapBlock:block];
    showType = AlertShowTypeAll;
    return self;
}

#pragma mark - 布局和设置
- (void)defaultSetting {
    self.showView.backgroundColor = _lineColor?_lineColor:[UIColor groupTableViewBackgroundColor];
}

- (void)layoutSubViews {
    //设置
    [self defaultSetting];
    
    //默认布局
    UIWindow *window = [AlertViewShow keyWindow];
    [window addSubview:self.cover];
    [window addSubview:self.showView];
    
    self.cover.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    self.showView.sd_layout
    .centerXIs(window.center.x)
    .centerYIs(window.center.y - _offsetY)
    .rightSpaceToView(window,SCREEN_WIDTH/10)
    .leftSpaceToView(window,SCREEN_WIDTH/10);
    

    //子视图布局
    NSArray *subViews;
    
    switch (showType) {
        case AlertShowTypeHead:
        {
            subViews = @[_headView];
            [self layoutAlertShowTypeHead];
        }
            break;
        case AlertShowTypeHeadContent:
        {
            subViews = @[_headView,_contentView];
            [self layoutAlertShowTypeHeadContent];
        }
            break;
        case AlertShowTypeHeadButtons:
        {
            subViews = @[_headView,_buttonsView];
            [self layoutAlertShowTypeHeadButtons];
        }
            break;
        case AlertShowTypeAll:
        {
            subViews = @[_headView,_contentView,_buttonsView];
            [self layoutAlertShowTypeAll];
        }
            break;
        default:
            break;
    }
    
    
    [self.showView setupAutoHeightWithBottomViewsArray:subViews bottomMargin:0];
    [self.showView updateLayout];

    //判断添加的偏移量是否使view超出屏幕
    if (self.showView.frame.origin.y <= 0) {
        _offsetY = (SCREEN_HEIGHT - self.showView.frame.size.height)/2;
        self.showView.sd_layout
        .centerYIs(window.center.y - _offsetY);
        [self.showView updateLayout];
    }
    
    if (self.showView.frame.origin.y >= (SCREEN_HEIGHT - self.showView.frame.size.height)) {
        NSLog(@"%f",SCREEN_HEIGHT);
        _offsetY = -(SCREEN_HEIGHT - self.showView.frame.size.height)/2;
        self.showView.sd_layout
        .centerYIs(window.center.y - _offsetY);
        [self.showView updateLayout];
    }
}

#pragma mark - 约束
//AlertShowTypeHead
- (void)layoutAlertShowTypeHead {
    //头部
    [self.showView addSubview:_headView];
    _headView.sd_layout
    .topSpaceToView(self.showView,0)
    .leftSpaceToView(self.showView,0)
    .rightSpaceToView(self.showView,0);
    [_headView updateHeadLayout];
}

//AlertShowTypeHeadContent
- (void)layoutAlertShowTypeHeadContent {
    //头部
    [self.showView addSubview:_headView];
    _headView.sd_layout
    .topSpaceToView(self.showView,0)
    .leftSpaceToView(self.showView,0)
    .rightSpaceToView(self.showView,0);
    [_headView updateHeadLayout];
    
    //内容
    [self.showView addSubview:_contentView];
    _contentView.sd_layout
    .topSpaceToView(_headView,_lineHeight)
    .leftSpaceToView(self.showView,0)
    .rightSpaceToView(self.showView,0);
    [_contentView updateHeadLayout];
}

//AlertShowTypeHead
- (void)layoutAlertShowTypeHeadButtons {
    //头部
    [self layoutAlertShowTypeHead];
    
    //buttons
    [self.showView addSubview:_buttonsView];
    _buttonsView.sd_layout
    .topSpaceToView(_headView,_lineHeight)
    .leftSpaceToView(self.showView,-1)
    .rightSpaceToView(self.showView,0);
    [_buttonsView updateButtonsLayout];
}

//AlertShowTypeHead
- (void)layoutAlertShowTypeAll {
    //头部,内容
    [self layoutAlertShowTypeHeadContent];

    //buttons
    [self.showView addSubview:_buttonsView];
    _buttonsView.sd_layout
    .topSpaceToView(_contentView,_lineHeight)
    .leftSpaceToView(self.showView,-1)
    .rightSpaceToView(self.showView,0);
    [_buttonsView updateButtonsLayout];
}


#pragma mark 获取keywindow
+ (UIWindow *)keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}


#pragma mark - 属性设置
- (void)setCoverColor:(UIColor *)coverColor {
    self.cover.backgroundColor = coverColor;
}

#pragma mark - 懒加载
- (UIView *)cover {
    if (!_cover) {
        
        _tapCoverDismiss = YES;
        
        _cover = [UIToolbar new];
        _cover.barStyle = UIBarStyleBlackTranslucent;

        _cover.backgroundColor = RGBACOLOR(.8, .8, .8, .8);
        [_cover tapHandle:^{
            [self tapCover];
        }];
        
    }
    return _cover;
}

- (UIView *)showView {
    if (!_showView) {
        _showView = [UIView new];
    }
    return _showView;
}


#pragma mark - 动画
- (void)show:(AlertViewAnimationType)type completion:(void(^)())completion {
    [self show:type offsetY:0 completion:completion];
}

- (void)show:(AlertViewAnimationType)type offsetY:(CGFloat)offsetY {
    [self show:type offsetY:offsetY completion:nil];
}

- (void)show:(AlertViewAnimationType)type {
    [self show:type offsetY:0];
}

- (void)show:(AlertViewAnimationType)type offsetY:(CGFloat)offsetY completion:(void(^)())completion{
    _offsetY = offsetY;
    [self layoutSubViews];

    [AlertViewAnimation animationWith:type mainView:self.showView cover:self.cover completion:completion];
}

- (void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3 animations:^{
            self.cover.alpha = 0;
            self.showView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.showView removeFromSuperview];
            [self.cover removeFromSuperview];
        }];
    });

}

#pragma mark - 点击背景
- (void)tapCover {
    if (_tapCoverDismiss) {
        [self dismiss];
    }
}

@end
