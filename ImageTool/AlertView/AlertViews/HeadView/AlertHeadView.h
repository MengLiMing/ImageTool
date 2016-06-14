//
//  AlertHeadView.h
//  AlertView
//
//  Created by my on 16/5/19.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertViewHead.h"

typedef NS_ENUM(NSInteger,AlertHeadType) {
    AlertHeadTypeCustom,//默认样式居中label显示title
    AlertHeadTypeImage,//图片提示
    AlertHeadTypeGraphic//图文提示，默认图片在左，文字在右
};

typedef NS_ENUM(NSInteger,AlertHeadGraphicType) {
    AlertHeadGraphicLeft,//图片左
    AlertHeadGraphicRight,//图片右
    AlertHeadGraphicTop,//图片上
    AlertHeadGraphicBottom,//图片下
    /**
     * 图文居中,可用于提示文字只有几个字不能展示一行的情况,此时文字默认距左或距右
     */
    AlertHeadGraphicCenterLeft,
    AlertHeadGraphicCenterRight
};

@interface AlertHeadView : UIView

//文字属性
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, copy) NSAttributedString *attributerString;


//图片属性
@property (nonatomic, strong) UIImage *image;

/**
 * 默认50
 * 图文时设置,不设置则根据self自身frame进行适配
 */
@property (nonatomic, assign) CGFloat MaxImageHeight;


/**
 * 显示的最大宽度,默认为0，此时宽为父视图的宽
 */
@property (nonatomic, assign) CGFloat MaxSelfWidth;

/**
 * 工厂方法
 *
 */
- (instancetype)initWithType:(AlertHeadType)type
                       title:(NSString *)title
                       image:(UIImage *)image;

- (instancetype)initWithGraphic:(AlertHeadGraphicType)type
                          title:(NSString *)title
                          image:(UIImage *)image;


//布局
- (void)updateHeadLayout;


+ (instancetype)shareHint;
+ (void)showHint:(NSString *)str;
+ (void)showHint:(NSString *)str offSetY:(CGFloat)offsetY;
@end
