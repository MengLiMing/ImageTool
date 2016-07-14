//
//  AnimationManager.h
//  ImageTool
//
//  Created by my on 16/6/19.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AnimationManagerType) {
    AnimationManagerTypeNav,//push
    AnimationManagerTypeModel//model
};

@interface AnimationManager : NSObject <UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>

///请尽量设置，有些情况下push和prensent的手势使用会照成逻辑问题,默认NO
@property (nonatomic, assign) BOOL pushOrPrenset;

+ (AnimationManager *)manager;

- (void)transitionType:(AnimationManagerType)type
                fromVC:(UIViewController *)fromVC
                  toVC:(UIViewController *)toVC;

@end
