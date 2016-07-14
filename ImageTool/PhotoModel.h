//
//  PhotoModel.h
//  ImageTool
//
//  Created by my on 16/6/7.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface PhotoModel : NSObject

@property (nonatomic, strong) ALAsset *asset;//图片的属性

///缩略图
@property (nonatomic, strong, readonly) UIImage *thumbnail;
///高宽比缩略图
@property (nonatomic, strong, readonly) UIImage *aspectRatioThumbnail;
///旋转过的图
@property (nonatomic, strong, readonly) UIImage *fullScreenImage;
///原图
@property (nonatomic, strong, readonly) UIImage *fullResolutionImage;

@property (nonatomic, copy) NSString *modelIndex;//下标


+ (instancetype)libraryPhotoFromAsset:(ALAsset *)theAsset;
@end
