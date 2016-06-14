//
//  AlertViewShow.h
//  AlertView
//
//  Created by my on 16/5/19.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AlertHeadView.h"
#import "AlertButtonsView.h"
#import "AlertViewAnimation.h"


@interface AlertViewShow : NSObject

//subviews
@property (nonatomic, strong) AlertHeadView *headView;
@property (nonatomic, strong) AlertHeadView *contentView;
@property (nonatomic, strong) AlertButtonsView *buttonsView;

/**
 * 分割线颜色（背景色）
 */
@property (nonatomic, strong) UIColor *lineColor;
/**
 * 分割线高度
 */
@property (nonatomic, assign) CGFloat lineHeight;
/**
 * 背景颜色
 */
@property (nonatomic, strong) UIColor *coverColor;
/**
 * 背景是否支持点击消失,默认为YES
 */
@property (nonatomic, assign) BOOL tapCoverDismiss;

/**
 * 单独显示一个图文信息
 */
- (instancetype)initWithType:(AlertHeadType)type
                       title:(NSString *)title
                       image:(UIImage *)image;

- (instancetype)initWithGraphic:(AlertHeadGraphicType)type
                          title:(NSString *)title
                          image:(UIImage *)image;


/**
 * 标题内容样式
 */
- (instancetype)initHeadTitle:(NSString *)title
                 contentTitle:(NSString *)content;

- (instancetype)initHeadType:(AlertHeadGraphicType)headType
                   headTitle:(NSString *)headTitle
                   headImage:(UIImage *)headImage
                 contentType:(AlertHeadGraphicType)contentType
                contentTitle:(NSString *)contentTitle
                contentImage:(UIImage *)contentImage;

/**
 * 标题，按钮样式
 */
- (instancetype)initWithGraphic:(AlertHeadGraphicType)type
                          title:(NSString *)title
                          image:(UIImage *)image
                     buttonType:(NSArray *)typeArray
                   buttonsArray:(NSArray *)buttons
                       tapBlock:(TapIndex)block;
/**
 * 标题，内容，按钮样式
 */
- (instancetype)initHeadTitle:(NSString *)title
                 contentTitle:(NSString *)content
                   buttonType:(NSArray *)typeArray
                 buttonsArray:(NSArray *)buttons
                     tapBlock:(TapIndex)block;

- (instancetype)initHeadType:(AlertHeadGraphicType)headType
                   headTitle:(NSString *)headTitle
                   headImage:(UIImage *)headImage
                 contentType:(AlertHeadGraphicType)contentType
                contentTitle:(NSString *)contentTitle
                contentImage:(UIImage *)contentImage
                  buttonType:(NSArray *)typeArray
                buttonsArray:(NSArray *)buttons
                    tapBlock:(TapIndex)block;


/**
 * 提示框信息
 */
+ (void)showHint:(NSString *)str;
+ (void)showHint:(NSString *)str offSetY:(CGFloat)offsetY;


/**
 * 动画方法
 */
- (void)show:(AlertViewAnimationType)type;
- (void)show:(AlertViewAnimationType)type offsetY:(CGFloat)offsetY;
- (void)show:(AlertViewAnimationType)type completion:(void(^)())completion;

- (void)dismiss;
@end
