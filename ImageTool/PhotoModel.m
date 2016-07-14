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
    return photo;
}

///缩略图
- (UIImage *)thumbnail {
    return [UIImage imageWithCGImage:[self.asset thumbnail]];
}
///宽高等比例缩略图
- (UIImage *)aspectRatioThumbnail {
    return [UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]];
}

///旋转过的图
- (UIImage *)fullScreenImage {
    return [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];

}
///原图
- (UIImage *)fullResolutionImage {
    return [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullResolutionImage]];

}
@end
