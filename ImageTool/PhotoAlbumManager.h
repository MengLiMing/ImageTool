//
//  PhotoAlbumManager.h
//  ImageTool
//
//  Created by my on 16/6/7.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class PhotoModel;
///单例
#define PHOTOMANAGER [PhotoAlbumManager manager]

typedef void(^ChooseImage)(NSArray *result);

@interface PhotoAlbumManager : NSObject


///最多选择多少张图片,默认5
@property (nonatomic, assign) NSInteger maxSelect;

///最终获取的图片是否是原图,(未设置压缩比例，默认为0.5)
@property (nonatomic, assign) BOOL isOriginal;

///图片压缩比例(小于1的小数)当设置的值小于1时自动设置isOriginal为NO
@property (nonatomic, assign) CGFloat percentage;



///单例
+ (PhotoAlbumManager *)manager;

///整体使用
- (void)showPhotoCamera:(void(^)(UIImage *image))backImage photoAlbums:(ChooseImage)result;

/*单独使用时*/
///相册
- (void)showPhotoAlbumResult:(ChooseImage)result;
///打开相机
- (void)openCamera:(void(^)(UIImage *image))backImage;


/*内部使用*/
///选择的图片数组
@property (nonatomic, strong) NSMutableArray *resultArray;
//处理选中
- (void)dealImage:(PhotoModel *)model indexPath:(NSIndexPath *)indexPath afterDeal:(void(^)(NSIndexPath *resultIndex))deal;
///返回选择的图片数组
+ (void)backChooseImages;

@end
