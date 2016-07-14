
//
//  AnimationManager.m
//  ImageTool
//
//  Created by my on 16/6/19.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "AnimationManager.h"
#import "CustomNavAnimation.h"
#import "AlphaPanManager.h"

static AnimationManager *manger = nil;

@interface AnimationManager ()
{
    //push
    AlphaPanManager *pushManager;
    AlphaPanManager *popManager;
    
    //model
    AlphaPanManager *presentManager;
    AlphaPanManager *dismissManager;
    
    
    //fromVC
    UIViewController *fromVC;
    //toVC
    UIViewController *toVC;
    
    //type
    AnimationManagerType managerType;
}
@property (nonatomic, assign) UINavigationControllerOperation operation;

@end


@implementation AnimationManager

+ (AnimationManager *)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[AnimationManager alloc] init];
        manger.pushOrPrenset = NO;
    });
    return manger;
}


- (void)transitionType:(AnimationManagerType)type
                fromVC:(UIViewController *)from
                  toVC:(UIViewController *)to {
    
    managerType = type;
    fromVC = from;
    toVC = to;
    
    switch (type) {
        case AnimationManagerTypeNav:
        {
            [self push];
        }
            break;
        case AnimationManagerTypeModel:
        {
            [self present];
        }
            break;
        default:
            break;
    }

}

- (void)push {
    if (self.pushOrPrenset) {
        pushManager = [AlphaPanManager managerWithDirection:AlphaPanManagerGestureDirectionUp type:AlphaPanManagerTypePush];
        __weak typeof(self) weakself= self;
        pushManager.pushAction = ^(){
            [weakself push];
        };
        [pushManager addPanGestureToVC:fromVC];
    }

    popManager = [AlphaPanManager managerWithDirection:AlphaPanManagerGestureDirectionDown type:AlphaPanManagerTypePop];
    [popManager addPanGestureToVC:toVC];
    fromVC.navigationController.delegate = self;
    [fromVC.navigationController pushViewController:toVC animated:YES];
}


- (void)present {
    if (self.pushOrPrenset) {
        presentManager = [AlphaPanManager managerWithDirection:AlphaPanManagerGestureDirectionUp type:AlphaPanManagerTypePresent];
        __weak typeof(self) weakself= self;
        presentManager.presentAction = ^(){
            [weakself present];
        };
        [presentManager addPanGestureToVC:toVC];
    }

    
    dismissManager = [AlphaPanManager managerWithDirection:AlphaPanManagerGestureDirectionDown type:AlphaPanManagerTypeDismiss];
    [dismissManager addPanGestureToVC:toVC];
    toVC.transitioningDelegate = self;
//    toVC.modalPresentationStyle = UIModalPresentationCustom;
    [fromVC presentViewController:toVC animated:YES completion:nil];
}


#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    _operation = operation;
    return [CustomNavAnimation animationWithType:operation == UINavigationControllerOperationPush ? CustomNavAnimationTypePushOrPresent : CustomNavAnimationTypePopOrDismiss];
}


- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (_operation == UINavigationControllerOperationPush) {
        return pushManager.interactiving ? pushManager : nil;
    } else {
        return popManager.interactiving ? popManager : nil;
    }
}


#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [CustomNavAnimation animationWithType:CustomNavAnimationTypePushOrPresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [CustomNavAnimation animationWithType:CustomNavAnimationTypePopOrDismiss];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return dismissManager.interactiving ? dismissManager : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    return presentManager.interactiving ? presentManager : nil;
}
@end
