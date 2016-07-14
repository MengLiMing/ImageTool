//
//  CustomNavAnimation.m
//  CustomAnimationDemo
//
//  Created by my on 16/4/6.
//  Copyright © 2016年 base. All rights reserved.
//

#import "CustomNavAnimation.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface CustomNavAnimation ()

@property (nonatomic, assign) CustomNavAnimationType type;

@end

@implementation CustomNavAnimation

+ (instancetype)animationWithType:(CustomNavAnimationType)type {
    return [[self alloc] initWithAnimationType:type];
}

- (instancetype)initWithAnimationType:(CustomNavAnimationType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return .2f;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_type) {
        case CustomNavAnimationTypePushOrPresent:
        {
            [self pushAnimationWith:transitionContext];
        }
            break;
        case CustomNavAnimationTypePopOrDismiss:
        {
            [self popAnimationWith:transitionContext];
        }
            break;
        default:
            break;
    }
}


//pushOrPresent
- (void)pushAnimationWith:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    toView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

//popOrDismiss
- (void)popAnimationWith:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;

    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toView atIndex:0];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
