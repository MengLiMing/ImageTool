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

///比例压缩照片
+ (NSData *)compressImage:(UIImage *)image percentage:(CGFloat)percentage;

///压缩为多大的图片
+ (NSData *)compressImage:(UIImage *)image maxLength:(CGFloat)maxLength;


///打开相册或相机,edit是否使用系统截图
- (void)openAlbumOrPhotoInVC:(UIViewController *)vc
                  completion:(void(^)(UIImage *image))backImage
                     canEdit:(BOOL)edit;


///单独使用打开相机
- (void)openCameraInVC:(UIViewController *)vc resultImage:(void(^)(UIImage *image))backImage;


///图片模糊
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
