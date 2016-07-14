//
//  AlphaPanManager.m
//  CustomAnimationDemo
//
//  Created by my on 16/3/31.
//  Copyright © 2016年 base. All rights reserved.
//

#import "AlphaPanManager.h"

@interface AlphaPanManager() <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIViewController *vc;//转场操作的VC控制器

@property (nonatomic, assign) AlphaPanManagerGestureDirection direction;
@property (nonatomic, assign) AlphaPanManagerType type;

@end

@implementation AlphaPanManager

+ (instancetype)managerWithDirection:(AlphaPanManagerGestureDirection)direction type:(AlphaPanManagerType)type {
    return [[self alloc] initWithDirection:direction type:type];
}

- (instancetype)initWithDirection:(AlphaPanManagerGestureDirection)direction type:(AlphaPanManagerType)type {
    self = [super init];
    if (self) {
        _direction = direction;
        _type = type;
    }
    return self;
}

- (void)addPanGestureToVC:(UIViewController *)viewController {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(beginGesture:)];
    pan.delegate = self;
    self.vc = viewController;
    [viewController.view addGestureRecognizer:pan];
}



- (void)beginGesture:(UIPanGestureRecognizer *)sender {
    //动画百分比控制，根据滑动的方向计算百分比，左上负，右下正
    CGFloat percent = 0;
    switch (_direction) {
        case AlphaPanManagerGestureDirectionLeft:
        {
            CGFloat transitionX = -[sender translationInView:sender.view].x;
            percent = transitionX / sender.view.frame.size.width;
        }
            break;
        case AlphaPanManagerGestureDirectionRight:
        {
            CGFloat transitionX = [sender translationInView:sender.view].x;
            percent = transitionX / sender.view.frame.size.width;
        }
            break;
        case AlphaPanManagerGestureDirectionUp:
        {
            CGFloat transitionY = -[sender translationInView:sender.view].y;
            percent = transitionY / sender.view.frame.size.height;
        }
            break;
        case AlphaPanManagerGestureDirectionDown:
        {
            CGFloat transitionY = [sender translationInView:sender.view].y;
            percent = transitionY / sender.view.frame.size.height;
        }
            break;
        default:
            break;
    }
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            //手势开始时，标记手势开始,并且开始事件
            self.interactiving = YES;
            [self startAction];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //手势过程中更新百分比
            [self updateInteractiveTransition:percent];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            self.interactiving = NO;
            //判断状态和百分比，从而选择结束转场还是取消转场
            if (percent < 0.3 || sender.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
        }
            break;
        default:
            break;
    }
}

- (void)startAction {
    switch (_type) {
        case AlphaPanManagerTypePresent:
        {
            if (self.presentAction) {
                self.presentAction();
            }
        }
            break;
        case AlphaPanManagerTypeDismiss:
        {
            [_vc dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case AlphaPanManagerTypePush:
        {
            if (self.pushAction) {
                self.pushAction();
            }
        }
            break;
        case AlphaPanManagerTypePop:
        {
            [_vc.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}

@end
