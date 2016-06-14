//
//  AlertButtonsView.h
//  AlertView
//
//  Created by my on 16/5/19.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertViewHead.h"

typedef void(^TapIndex)(NSInteger index);

@interface AlertButtonsView : UICollectionView

/**
 * button布局数组
 * 请使用NSNumber类型
 * 例子：@[1,2,1],用于设置每行显示几个按钮，默认为@[1,1,1...]
 * 按钮设置总数应与数组中值之和相同，不同时，根据情况变化
 */
@property (nonatomic, strong) NSMutableArray *buttonsLayout;
/**
 * buttons数组
 */
@property (nonatomic, strong) NSMutableArray *buttonsArray;

/**
 * 按钮高度
 */
@property (nonatomic, assign) CGFloat buttonHeight;

/**
 * button统一背景颜色
 */
@property (nonatomic, strong) UIColor *buttongroundColor;

/**
 * button字体大小
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 * button字体颜色
 */
@property (nonatomic, strong) UIColor *titleColor;


/**
 * 用自己定义button替换，默认button
 */
- (void)changeButtonAtIndex:(NSInteger)index withDIYButton:(UIView *)button;



/**
 * 更新约束
 */
- (void)updateButtonsLayout;

- (instancetype)initWithTypeArray:(NSArray *)typeArr
                     buttonsArray:(NSArray *)buttonArr
                         tapBlock:(TapIndex)block;

@end
