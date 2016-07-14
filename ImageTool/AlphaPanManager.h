//
//  AlphaPanManager.h
//  CustomAnimationDemo
//
//  Created by my on 16/3/31.
//  Copyright © 2016年 base. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureBlock)();
/**手势方向*/
typedef NS_ENUM(NSUInteger, AlphaPanManagerGestureDirection) {
    AlphaPanManagerGestureDirectionLeft = 0,
    AlphaPanManagerGestureDirectionRight,
    AlphaPanManagerGestureDirectionUp,
    AlphaPanManagerGestureDirectionDown
};

/**手势控制哪种转场*/
typedef NS_ENUM(NSUInteger, AlphaPanManagerType) {
    AlphaPanManagerTypePresent = 0,
    AlphaPanManagerTypeDismiss,
    AlphaPanManagerTypePush,
    AlphaPanManagerTypePop
};

@interface AlphaPanManager : UIPercentDrivenInteractiveTransition

/**用于标记手势是否结束*/
@property (nonatomic, assign) BOOL interactiving;

//如果是push动画或者pop动画，需要在实现动画的控制器中实现present或者push(也可以将push或者present的下个视图控制器传入)
@property (nonatomic, copy) GestureBlock presentAction;
@property (nonatomic, copy) GestureBlock pushAction;

//添加手势
- (void)addPanGestureToVC:(UIViewController *)viewController;

//工厂方法
+ (instancetype)managerWithDirection:(AlphaPanManagerGestureDirection)direction type:(AlphaPanManagerType)type;
- (instancetype)initWithDirection:(AlphaPanManagerGestureDirection)direction type:(AlphaPanManagerType)type;

@end
