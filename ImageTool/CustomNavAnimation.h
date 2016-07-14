//
//  CustomNavAnimation.h
//  CustomAnimationDemo
//
//  Created by my on 16/4/6.
//  Copyright © 2016年 base. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,CustomNavAnimationType) {
    CustomNavAnimationTypePushOrPresent = 0,
    CustomNavAnimationTypePopOrDismiss
};

@interface CustomNavAnimation : NSObject <UIViewControllerAnimatedTransitioning>


+ (instancetype)animationWithType:(CustomNavAnimationType)type;
- (instancetype)initWithAnimationType:(CustomNavAnimationType)type;

@end
