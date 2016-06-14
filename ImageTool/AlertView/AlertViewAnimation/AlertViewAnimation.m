//
//  AlertViewAnimation.m
//  AlertView
//
//  Created by my on 16/5/19.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "AlertViewAnimation.h"

@interface AlertViewAnimation ()
{
    UIView *mainView;
    UIView *coverView;
    void(^completionBlock)();
}

@end

@implementation AlertViewAnimation

+ (void)animationWith:(AlertViewAnimationType)type
             mainView:(UIView *)main
                cover:(UIView *)cover {
    [[[AlertViewAnimation alloc] init] animationWith:type mainView:main cover:cover completion:nil];
}


+ (void)animationWith:(AlertViewAnimationType)type
             mainView:(UIView *)main
                cover:(UIView *)cover
           completion:(void(^)())completion {
    [[[AlertViewAnimation alloc] init] animationWith:type mainView:main cover:cover completion:completion];
}



- (void)animationWith:(AlertViewAnimationType)type
             mainView:(UIView *)main
                cover:(UIView *)cover
           completion:(void(^)())completion {
    mainView = main;
    coverView = cover;
    completionBlock = completion;
    switch (type) {
        case AlertViewAnimationIncrease:
        {
            [self showAlertViewAnimationIncrease];
        }
            break;
        case AlertViewAnimationReduce:
        {
            [self showAlertViewAnimationReduce];
        }
            break;
        case AlertViewAnimationLeft:
        {
            [self showAlertViewAnimationLeft];
        }
            break;
        case AlertViewAnimationRight:
        {
            [self showAlertViewAnimationRight];
        }
            break;
        default:
            break;
    }
}



#pragma mark - AlertViewAnimationIncrease
- (void)showAlertViewAnimationIncrease {
    coverView.alpha = 0;
    mainView.alpha = 0;
    mainView.transform = CGAffineTransformMakeScale(.6, .6);
    
    [UIView animateWithDuration:.3 animations:^{
        mainView.alpha = 1;
        mainView.transform = CGAffineTransformIdentity;
        coverView.alpha = 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endAnimation];
        });
    } completion:^(BOOL finished) {
    }];
}

#pragma mark -AlertViewAnimationReduce
- (void)showAlertViewAnimationReduce {
    coverView.alpha = 0;
    mainView.alpha = 0;
    mainView.transform = CGAffineTransformMakeScale(1.4, 1.4);
    
    [UIView animateWithDuration:.3 animations:^{
        mainView.alpha = 1;
        mainView.transform = CGAffineTransformIdentity;
        coverView.alpha = 1;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endAnimation];
        });
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - AlertViewAnimationLeft
- (void)showAlertViewAnimationLeft {
    
    coverView.alpha = 0;
    CGRect frame = mainView.frame;
    frame.origin.x -= ((SCREEN_WIDTH - frame.size.width)/2 + frame.size.width);
    mainView.frame = frame;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self endAnimation];
    });
    [UIView animateWithDuration:.3
                          delay:.1
         usingSpringWithDamping:.5 //震动幅度(0-1),数值越小震动越明显
          initialSpringVelocity:1/.5 //表示初始的速度，数值越大一开始移动越快
                        options:UIViewAnimationOptionOverrideInheritedCurve
                     animations:^{
                         coverView.alpha = 1;

                         CGRect frame = mainView.frame;
                         frame.origin.x += ((SCREEN_WIDTH - frame.size.width)/2 + frame.size.width);
                         mainView.frame = frame;
                         
                     } completion:^(BOOL finished) {
                     }];
}


#pragma mark - AlertViewAnimationRight
- (void)showAlertViewAnimationRight {
    coverView.alpha = 0;
    CGRect frame = mainView.frame;
    frame.origin.x += ((SCREEN_WIDTH - frame.size.width)/2 + frame.size.width);
    mainView.frame = frame;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self endAnimation];
    });
    [UIView animateWithDuration:.3
                          delay:.2
         usingSpringWithDamping:.5
          initialSpringVelocity:1/.5
                        options:UIViewAnimationOptionOverrideInheritedCurve
                     animations:^{
                         coverView.alpha = 1;

                         CGRect frame = mainView.frame;
                         frame.origin.x -= ((SCREEN_WIDTH - frame.size.width)/2 + frame.size.width);
                         mainView.frame = frame;
                         
                     } completion:^(BOOL finished) {
                     }];

}


#pragma mark - 动画结束执行
- (void)endAnimation {
    if (completionBlock) {
        completionBlock();
    }
}
@end
