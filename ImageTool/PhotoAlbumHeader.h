//
//  PhotoAlbumHeader.h
//  ImageTool
//
//  Created by my on 16/6/13.
//  Copyright © 2016年 MS. All rights reserved.
//

#ifndef PhotoAlbumHeader_h
#define PhotoAlbumHeader_h

#import "AlbumModel.h"
#import "PhotoModel.h"
#import "UIView+FrameChange.h"
#import "UIView+Category.h"
#import "AlertViewShow.h"

#import <Photos/Photos.h>
#endif /* PhotoAlbumHeader_h */


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define KEYWINDOW [UIApplication sharedApplication].keyWindow

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define IOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

