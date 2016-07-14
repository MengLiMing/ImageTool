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
@class ImagesView;
///单例
#define PHOTOMANAGER [PhotoAlbumManager manager]

typedef void(^ChooseImage)(NSArray *result);

@interface PhotoAlbumManager : NSObject


///最多选择多少张图片,默认5
@property (nonatomic, assign) NSInteger maxSelect;

///最终获取的图片是否是原图，默认为YES(设置为NO即返回等比例的缩略图)
@property (nonatomic, assign) BOOL isOriginal;

///原图是设置此值有效（默认为 .5M）
@property (nonatomic, assign) CGFloat dataMaxLength;

///用来存储需要更新的ImageView
@property (nonatomic, strong) NSMutableArray *loadArray;

//可用于设置自定义的动画
@property (nonatomic, copy) void(^showBlcok)();
@property (nonatomic, copy) void(^dismissBlcok)();

///单例
+ (PhotoAlbumManager *)manager;

///整体使用
+ (void)showPhotoCamera:(void(^)(UIImage *image))backImage
            photoAlbums:(ChooseImage)result
       atViewController:(UIViewController *)vc;
///列表样式相册
+ (void)presentPhotoAlbum;
///编辑
+ (void)editPhoto;



/*单独使用时*/
///打开相册
+ (void)showPhotoAlbumResult:(ChooseImage)result;
///打开相机
+ (void)openCamera:(void(^)(UIImage *image))backImage;


/*内部使用*/
///导航栏
- (void)setNav:(UINavigationController *)nav;
///单独处理一个PhotoModel(blcok可以写入自定义的动画)
+ (void)fullResolutionImageModel:(PhotoModel *)model
                       backImage:(void(^)(UIImage *image))backImage
                            show:(void(^)())show
                         dismiss:(void(^)())dismiss;
///选择的图片数组
@property (nonatomic, strong) NSMutableArray *resultArray;
///处理选中
+ (void)dealImage:(PhotoModel *)model
      sourceArray:(NSArray *)sourceArray
        afterDeal:(void(^)(NSIndexPath *resultIndex))deal
         withSelf:(UIView *)imagesView;
///返回选择的图片数组
+ (void)backChooseImages;
///获取superView
+ (UIView *)superView;

@end
