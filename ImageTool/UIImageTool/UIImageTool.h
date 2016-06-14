//
//  UIImageTool.h
//  BaseProject
//
//  Created by my on 16/4/20.
//  Copyright © 2016年 base. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageTool : NSObject


+ (instancetype)manager;


///保存图片
+ (void)saveImage:(UIImage *)image;

///生成图片
+ (UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size;

///生成二维码
+ (UIImage *)createCodeImageWithSize:(CGFloat)size;

///下载图片
+ (void)loadImageWithUrl:(NSString *)urlStr completion:(void (^)(UIImage *image))backImage;

///压缩照片
+ (NSData *)compressImage:(UIImage *)image percentage:(NSInteger)percentage;

///打开相册或相机
- (void)openAlbumOrPhotoInVC:(UIViewController *)vc completion:(void(^)(UIImage *image))backImage;


///单独使用打开相机
- (void)openCamera:(void(^)(UIImage *image))backImage;

@end
