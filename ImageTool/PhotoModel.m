//
//  PhotoModel.m
//  ImageTool
//
//  Created by my on 16/6/7.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

//调用方法返回对象
+ (instancetype)libraryPhotoFromAsset:(ALAsset *)theAsset {
    PhotoModel *photo = [PhotoModel new];
    [photo setAsset:theAsset];
    //通过得到的CGImageRef类型的照片，复制给UIImage类型
    [photo setPreview:[UIImage imageWithCGImage:[theAsset thumbnail]]];
    return photo;
}

@end
