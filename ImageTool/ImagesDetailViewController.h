//
//  ImagesDetailViewController.h
//  ImageTool
//
//  Created by my on 16/6/18.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

@interface ImagesDetailViewController : UIViewController

@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, strong) PhotoModel *currentModel;//点击进入的model

@property (nonatomic, strong) NSArray *sourceArray;
@end
