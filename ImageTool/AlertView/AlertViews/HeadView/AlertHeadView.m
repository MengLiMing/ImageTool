//
//  AlertHeadView.m
//  AlertView
//
//  Created by my on 16/5/19.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "AlertHeadView.h"

/**
 * 提示信息单例
 */
static AlertHeadView *hintView = nil;

//图片字体间距
static const CGFloat lineSpace = 5;

static const CGFloat bottomMargin = 5;



@interface AlertHeadView ()
{
    
    UILabel *alertTitle;
    UIImageView *alertImage;
    
    
    //图片宽,文字宽
    CGFloat imageWidth;
    CGFloat titlWidth;
}
//提示框是否已经显示
@property (nonatomic, assign) BOOL hasShow;

/**
 * AlertHeadView样式
 */
@property (nonatomic, assign) AlertHeadType headType;

/**
 * AlertHeadGraphicType样式
 * 需要在图文样式下使用
 */
@property (nonatomic, assign) AlertHeadGraphicType graphicType;

@end

@implementation AlertHeadView

#pragma mark - 提示信息
+ (instancetype)shareHint {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hintView = [[AlertHeadView alloc] initHint];
    });
    return hintView;
}

- (instancetype)initHint {
    self = [[AlertHeadView alloc] initWithType:AlertHeadTypeCustom title:@"" image:nil];
    alertTitle.backgroundColor = [UIColor clearColor];
    alertTitle.font = [UIFont systemFontOfSize:14];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithWhite:.5 alpha:.8];
    return self;
}
+ (void)showHint:(NSString *)str {
    [AlertHeadView showHint:str offSetY:0];
}

+ (void)showHint:(NSString *)str offSetY:(CGFloat)offsetY{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    AlertHeadView *hint = [AlertHeadView shareHint];
    hint.title = str;
    hint.MaxSelfWidth = SCREEN_WIDTH - 40;
    
    
    [window addSubview:hint];
    [hint updateHeadLayout];
    [hint titleWidth];
    hint.sd_layout
    .centerXIs(window.center.x)
    .centerYIs(window.center.y - offsetY)
    .widthIs(hint.MaxSelfWidth)
    .heightIs([hint titleHeight]);
    [hint updateHeadLayout];
    
    //判断添加的偏移量是否使view超出屏幕
    if (hint.frame.origin.y <= 0) {
        offsetY = (SCREEN_HEIGHT - hint.frame.size.height)/2;
        hint.sd_layout
        .centerYIs(window.center.y - offsetY);
        [hint updateLayout];
    }
    
    if (hint.frame.origin.y >= (SCREEN_HEIGHT - hint.frame.size.height)) {
        offsetY = -(SCREEN_HEIGHT - hint.frame.size.height)/2;
        hint.sd_layout
        .centerYIs(window.center.y - offsetY);
        [hint updateLayout];
    }
    
    if (!hint.hasShow) {
        hint.hasShow = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hint removeFromSuperview];
            hint.hasShow = NO;
        });
    }

}


#pragma mark - 工厂方法
- (instancetype)initWithType:(AlertHeadType)type
                       title:(NSString *)title
                       image:(UIImage *)image {
    if (self = [super init]) {
        self.headType = type;
        [self initTitle:title image:image];
    }
    return self;
}


- (instancetype)initWithGraphic:(AlertHeadGraphicType)type
                          title:(NSString *)title
                          image:(UIImage *)image {
    if (self = [super init]) {
        _graphicType = type;
        self.headType = AlertHeadTypeGraphic;
        [self initTitle:title image:image];
    }
    return self;
}

- (void)initTitle:(NSString *)title image:(UIImage *)image {
    _MaxImageHeight = 50.f;
    _MaxSelfWidth = 0;
    self.image = image;
    self.title = title;
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 属性设置
- (void)setHeadType:(AlertHeadType)headType {
    _headType = headType;
    switch (headType) {
        case AlertHeadTypeCustom:
        {
            [self initCustomView];
            [self sd_addSubviews:@[alertTitle]];
        }
            break;
        case AlertHeadTypeImage:
        {
            [self initImage];
            [self sd_addSubviews:@[alertImage]];
        }
            break;
        case AlertHeadTypeGraphic:
        {
            [self initGraphic];
            [self sd_addSubviews:@[alertTitle,alertImage]];
        }
            break;
        default:
            break;
    }
}

//文字
- (void)setTitle:(NSString *)title {
    _title = title;
    alertTitle.text = title;
}

//图片
- (void)setImage:(UIImage *)image {
    _image = image;
    alertImage.image = image;
}

//字体
- (void)setFont:(UIFont *)font {
    _font = font;
    alertTitle.font = font;
}

//颜色
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    alertTitle.textColor = titleColor;
}

//居中样式
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    alertTitle.textAlignment = textAlignment;
}

#pragma mark - 初始化
//文字
- (void)initCustomView {
    //默认样式
    if (!alertTitle) {
        alertTitle = [UILabel new];
        alertTitle.numberOfLines = 0;
        self.titleColor = [UIColor blackColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.title = @"提示";
        self.font = [UIFont systemFontOfSize:16];
    }
}

//图片
- (void)initImage {
    
    if (!alertImage) {
        alertImage = [UIImageView new];
        alertImage.image = [UIImage imageNamed:@"alert"];
    }
}

//图文
- (void)initGraphic {
    [self initCustomView];
    [self initImage];
}

#pragma mark - 布局
//更新布局
- (void)updateHeadLayout {
    //得到self和self.superView的frame
    if (self.superview) {
        [self.superview updateLayout];
    }
    [self updateLayout];
    
    if (self.MaxSelfWidth == 0) {
        if (self.superview) {
            _MaxSelfWidth = self.superview.frame.size.width;
        }
    }
    
    if (!alertTitle && !alertImage) {
        return;
    }
    
    //子视图
    NSArray *subViews;
    
    switch (_headType) {
        case AlertHeadTypeCustom:
        {
            alertTitle.sd_layout
            .topSpaceToView(self,lineSpace)
            .leftSpaceToView(self,lineSpace)
            .rightSpaceToView(self,lineSpace)
            .heightIs([self titleHeight]);
            subViews = @[alertTitle];
        }
            break;
        case AlertHeadTypeImage:
        {
            [self changeMaxImageHeight];
            
            alertImage.sd_layout
            .topSpaceToView(self,lineSpace)
            .centerXEqualToView(self)
            .heightIs(_MaxImageHeight)
            .widthIs(imageWidth);
            subViews = @[alertImage];
        }
            break;
        case AlertHeadTypeGraphic:
        {
            [self layoutGraphic];
            subViews = @[alertTitle,alertImage];
        }
            break;
        default:
            break;
    }
    [self setupAutoHeightWithBottomViewsArray:subViews bottomMargin:bottomMargin];
    [self updateLayout];
    
    //
    if (self.superview && ![self.superview isEqual:[UIApplication sharedApplication].keyWindow]) {
        //可能添加到父视图上时，superview已经含有子视图
        self.superview.sd_layout.heightIs(self.frame.size.height + self.superview.frame.size.height);
        [self.superview updateLayout];
    }
}


//布局图文
- (void)layoutGraphic {
    [self changeMaxImageHeight];
    switch (_graphicType) {
        case AlertHeadGraphicLeft:
        {
            //判断高度，使用不同约束，否则可能父视图无法确定自身frame
            if (_MaxImageHeight > [self titleHeight]) {
                alertImage.sd_layout
                .leftSpaceToView(self,lineSpace)
                .topSpaceToView(self,lineSpace)
                .heightIs(_MaxImageHeight)
                .widthIs(imageWidth);
                
            } else {
                alertImage.sd_layout
                .leftSpaceToView(self,lineSpace)
                .centerYEqualToView(self)
                .heightIs(_MaxImageHeight)
                .widthIs(imageWidth);
            }
            alertTitle.sd_layout
            .topSpaceToView(self,lineSpace)
            .leftSpaceToView(alertImage,lineSpace)
            .rightSpaceToView(self,lineSpace)
            .heightIs(MAX(_MaxImageHeight, [self titleHeight]));

        }
            break;
        case AlertHeadGraphicRight:
        {
            //判断高度，使用不同约束，否则可能父视图无法确定自身frame
            if (_MaxImageHeight > [self titleHeight]) {
                alertImage.sd_layout
                .rightSpaceToView(self,lineSpace)
                .topSpaceToView(self,lineSpace)
                .heightIs(_MaxImageHeight)
                .widthIs(imageWidth);
            } else {
                alertImage.sd_layout
                .rightSpaceToView(self,lineSpace)
                .centerYEqualToView(self)
                .heightIs(_MaxImageHeight)
                .widthIs(imageWidth);
            }

            alertTitle.sd_layout
            .topSpaceToView(self,lineSpace)
            .leftSpaceToView(self,lineSpace)
            .rightSpaceToView(alertImage,lineSpace)
            .heightIs(MAX(_MaxImageHeight, [self titleHeight]));
        }
            break;
        case AlertHeadGraphicTop:
        {
            alertImage.sd_layout
            .topSpaceToView(self,lineSpace)
            .heightIs(_MaxImageHeight)
            .widthIs(imageWidth)
            .centerXEqualToView(self);
            
            alertTitle.sd_layout
            .topSpaceToView(alertImage,lineSpace)
            .leftSpaceToView(self,lineSpace)
            .rightSpaceToView(self,lineSpace)
            .heightIs([self titleHeight]);
        }
            break;
        case AlertHeadGraphicBottom:
        {
            alertTitle.sd_layout
            .topSpaceToView(self,lineSpace)
            .leftSpaceToView(self,lineSpace)
            .rightSpaceToView(self,lineSpace)
            .heightIs([self titleHeight]);
            
            alertImage.sd_layout
            .topSpaceToView(alertTitle,lineSpace)
            .heightIs(_MaxImageHeight)
            .widthIs(imageWidth)
            .centerXEqualToView(self);
        }
            break;
        case AlertHeadGraphicCenterLeft:
        {
            self.textAlignment = NSTextAlignmentLeft;
            //图片文字距离两边间隔
            CGFloat space = (self.frame.size.width - [self titleWidth] - imageWidth - lineSpace)/2;
            
            //判断高度，使用不同约束，否则可能父视图无法确定自身frame
            if (_MaxImageHeight > [self titleHeight]) {
                alertImage.sd_layout
                .topSpaceToView(self,lineSpace)
                .leftSpaceToView(self,space)
                .heightIs(_MaxImageHeight)
                .widthIs(imageWidth);
                
            } else {
                alertImage.sd_layout
                .leftSpaceToView(self,space)
                .centerYEqualToView(self)
                .heightIs(_MaxImageHeight)
                .widthIs(imageWidth);
            }
            
            alertTitle.sd_layout
            .topSpaceToView(self,lineSpace)
            .leftSpaceToView(alertImage,lineSpace)
            .centerYEqualToView(self)
            .widthIs([self titleWidth])
            .heightIs([self titleHeight]);
        }
            break;
        case AlertHeadGraphicCenterRight:
        {
            self.textAlignment = NSTextAlignmentRight;
            //图片文字距离两边间隔
            CGFloat space = (self.frame.size.width - [self titleWidth] - imageWidth - lineSpace)/2;
            
            if (_MaxImageHeight > [self titleHeight]) {
                alertImage.sd_layout
                .topSpaceToView(self,lineSpace)
                .rightSpaceToView(self,space)
                .heightIs(_MaxImageHeight)
                .widthIs(imageWidth);
                
            } else {
                alertImage.sd_layout
                .rightSpaceToView(self,space)
                .centerYEqualToView(self)
                .heightIs(_MaxImageHeight)
                .widthIs(imageWidth);
            }

            
            alertTitle.sd_layout
            .topSpaceToView(self,lineSpace)
            .rightSpaceToView(alertImage,lineSpace)
            .centerYEqualToView(self)
            .widthIs([self titleWidth])
            .heightIs([self titleHeight]);
        }
            break;
        default:
            break;
    }
}

//图片宽度，高度
- (void)changeMaxImageHeight {
    CGFloat width = self.superview?self.superview.frame.size.width:self.frame.size.width;

    
    //根据传入的图片高度计算图片宽度
    imageWidth = _MaxImageHeight * _image.size.width/_image.size.height;
    
    //文字最少显示宽度
    CGFloat titleMinWidth = self.font.lineHeight;
    
    //图片显示最大宽度
    CGFloat imageMaxWidth;
    
    //根据图片比例和MaxImageHeight计算图片宽度
    if (_headType == AlertHeadTypeImage) {
        //图片显示最大宽度
        imageMaxWidth = width - 2 * lineSpace;
    } else {
        switch (_graphicType) {
            case AlertHeadGraphicLeft:
            case AlertHeadGraphicRight:
            case AlertHeadGraphicCenterLeft:
            case AlertHeadGraphicCenterRight:
            {
                imageMaxWidth = width - 3 * lineSpace - titleMinWidth;
                
            }
                break;
            case AlertHeadGraphicTop:
            case AlertHeadGraphicBottom:
            {
                //图片显示最大宽度
                imageMaxWidth = width - 2 * lineSpace;
            }
                break;
            default:
                break;
        }
    }

    //超出范围，重新设置图片宽高
    if (imageWidth > imageMaxWidth) {
        imageWidth = imageMaxWidth;
        _MaxImageHeight = imageMaxWidth * _image.size.height/_image.size.width;
    }
}


#pragma mark - 提示label高度
- (CGFloat)titleHeight {
    if (_headType == AlertHeadTypeCustom) {
        return MAX(self.font.lineHeight + 8,[self.title stringSizeWithFont:self.font Size:CGSizeMake(self.superview.frame.size.width - 2 * lineSpace, MAXFLOAT)].height);
    } else {
        switch (_graphicType) {
            case AlertHeadGraphicLeft:
            case AlertHeadGraphicRight:
            {
                return MAX(self.font.lineHeight + 8,[self.title stringSizeWithFont:self.font Size:CGSizeMake(self.superview.frame.size.width - 2 * lineSpace - alertImage.frame.size.width - lineSpace, MAXFLOAT)].height);
            }
                break;
            case AlertHeadGraphicTop:
            case AlertHeadGraphicBottom:
            {
                return MAX(self.font.lineHeight + 8,[self.title stringSizeWithFont:self.font Size:CGSizeMake(self.superview.frame.size.width - 2 * lineSpace, MAXFLOAT)].height);
            }
                break;
            case AlertHeadGraphicCenterLeft:
            case AlertHeadGraphicCenterRight:
            {
                return MAX(self.font.lineHeight + 8,[self.title stringSizeWithFont:self.font Size:CGSizeMake([self titleWidth], MAXFLOAT)].height);
            }
                break;
            default:
                break;
        }
    }
}

- (CGFloat)titleWidth {
    CGFloat width = [self.title stringSizeWithFont:self.font Size:CGSizeMake(MAXFLOAT, self.font.lineHeight)].width;
    width = MIN(_MaxSelfWidth - imageWidth - 2*lineSpace, width);
    _MaxSelfWidth = width + imageWidth + 2 * lineSpace;
    return width;
}

@end
