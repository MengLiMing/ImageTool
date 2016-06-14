//
//  AlertViewAnimation.h
//  AlertView
//
//  Created by my on 16/5/19.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AlertViewHead.h"

typedef NS_ENUM(NSInteger,AlertViewAnimationType) {
    AlertViewAnimationIncrease,//淡入，由小变大
    AlertViewAnimationReduce,//淡入，由大变小
    AlertViewAnimationLeft,//从左至有，有弹簧效果
    AlertViewAnimationRight,
    AlertViewAnimationTop,
    AlertViewAnimationBottom
};

@interface AlertViewAnimation : NSObject

+ (void)animationWith:(AlertViewAnimationType)type
             mainView:(UIView *)main
                cover:(UIView *)cover;

+ (void)animationWith:(AlertViewAnimationType)type
             mainView:(UIView *)main
                cover:(UIView *)cover
           completion:(void(^)())completion;

@end
