//
//  BottomView.h
//  ImageTool
//
//  Created by my on 16/6/16.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

//我懒，请允许我用xib

@interface BottomView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, copy) void(^backAction)(NSInteger);//0相册 1编辑 2确定

@end
