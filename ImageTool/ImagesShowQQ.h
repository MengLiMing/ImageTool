//
//  ImagesShowQQ.h
//  ImageTool
//
//  Created by my on 16/6/8.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesShowQQ : UIView


@property (nonatomic, copy) void (^backImages)(NSArray *);

- (instancetype)initImagesQQ;

- (void)show;
- (void)dismiss;

//刷新
- (void)reloadDataWith:(NSArray *)source;

@end
