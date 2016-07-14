//
//  PhotoAlbumManager.m
//  ImageTool
//
//  Created by my on 16/6/7.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "PhotoAlbumManager.h"
#import "PhotoAlbumHeader.h"

#import "ImagesShowQQ.h"
#import "PhotoListViewController.h"
#import "ImagesDetailViewController.h"
#import "UIImageTool.h"
#import "MLMLoading.h"
#import "AnimationManager.h"

static PhotoAlbumManager *manager = nil;

@interface PhotoAlbumManager () <ImagesViewDelegate>

@property (nonatomic, weak) ChooseImage resultBlock;

@property (nonatomic, strong) ALAssetsLibrary *assetsLibray;

//相册数组
@property (nonatomic, strong) NSMutableArray *photoAlbums;

//所有相片的数组
@property (nonatomic, strong) NSMutableArray *photos;

//主控制器
@property (nonatomic, strong) UIViewController *superVC;

@end

@implementation PhotoAlbumManager

#pragma mark - 单例和设置
+ (PhotoAlbumManager *)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.assetsLibray = [ALAssetsLibrary new];
        //默认最大选择
        manager.maxSelect = 5;
        //默认是否是原图
        manager.isOriginal = YES;
        //默认比例
        manager.dataMaxLength = .5;
        
        manager.loadArray = [NSMutableArray array];
    });
    return manager;
}

#pragma mark - 整体使用
+ (void)showPhotoCamera:(void(^)(UIImage *image))backImage
            photoAlbums:(ChooseImage)result
       atViewController:(UIViewController *)vc {
    
    PHOTOMANAGER.superVC = vc;
    __block AlertViewShow *alertView = [[AlertViewShow alloc] initWithGraphic:AlertHeadGraphicCenterLeft title:@"请选择选取图片方式" image:[UIImage imageNamed:@"alert"] buttonType:@[@(2),@(1)] buttonsArray:@[@"打开照相机",@"打开手机相册",@"取消"] tapBlock:^(NSInteger index) {
        [alertView dismiss];
        switch (index)
        {
            case 0:  //打开照相机拍照
                [PhotoAlbumManager openCamera:backImage];
                break;
            case 1:  //打开本地相册
            {
                [PhotoAlbumManager showPhotoAlbumResult:result];
            }
                break;
            default:
                break;
        }
    }];
    alertView.lineColor = [UIColor groupTableViewBackgroundColor];
    alertView.lineHeight = 1;
    alertView.tapCoverDismiss = NO;
    alertView.headView.MaxImageHeight = 20;
    alertView.coverColor = RGBACOLOR(.8, .8, .8, .3);
    [alertView show:AlertViewAnimationLeft];
}

#pragma mark - 列表样式相册
+ (void)presentPhotoAlbum {
    //处理已经得到的数据源
    PhotoListViewController *vc = [[PhotoListViewController alloc] init];
    vc.photoList = PHOTOMANAGER.photoAlbums;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [PHOTOMANAGER setNav:nav];
    [PHOTOMANAGER.superVC presentViewController:nav animated:YES completion:nil];
}

- (void)setNav:(UINavigationController *)nav {
    UINavigationBar *navBar = nav.navigationBar;
    navBar.barTintColor = [UIColor darkTextColor];
    navBar.barStyle = UIBarStyleBlackOpaque;
    
    //设置导航条标题的字体和颜色
    NSDictionary *titleAttr = @{
                                NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:16]
                                };
    [navBar setTitleTextAttributes:titleAttr];
    
    //设置返回按钮的样式
    //tintColor是用于导航条的所有Item
    navBar.tintColor = [UIColor whiteColor];

}

#pragma mark - 编辑
+ (void)editPhoto {
    
}

#pragma mark - 获取相册block
+ (void)getPhotoAlbums:(void (^)(NSArray *))resultBlock {
    //创建数组保存相册
    PHOTOMANAGER.photoAlbums = [NSMutableArray array];
    
    //通过block，遍历资源中的相册
    NSAssert(PHOTOMANAGER.assetsLibray != nil, @"assetsLibray为nil");
    [PHOTOMANAGER.assetsLibray enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group == nil) {
            //返回整数据
            resultBlock(PHOTOMANAGER.photoAlbums);
            return ;
        }
        //创建相册对象
        AlbumModel *albumModel = [AlbumModel new];
        //设置model 的title
        [albumModel setTitle:[group valueForProperty:ALAssetsGroupPropertyName]];
        
        //新建一个数组保存每个相册中的相片
        NSMutableArray *photos = [NSMutableArray new];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result == nil) {
                return ;
            }
            //得到相片的结果属性
            NSString *type = [result valueForProperty:ALAssetPropertyType];
            //判断如果属性类型和用户保存的图片类型不一致，则返回
            if (![type isEqualToString:ALAssetTypePhoto]) {
                return;
            }
            //否则，将照片存放在一个model中，然后保存在数组中
            [photos addObject:[PhotoModel libraryPhotoFromAsset:result]];
        }];
        //将得到的数组保存在相册model的数组中
        [albumModel setPhotos:photos];
        //然后将相册对象添加到数组中
        [PHOTOMANAGER.photoAlbums addObject:albumModel];
//        //返回整数据
//        resultBlock(PHOTOMANAGER.photoAlbums);
    } failureBlock:NULL];
}


#pragma mark - 图片选择
+ (void)showPhotoAlbumResult:(ChooseImage)result {
    PHOTOMANAGER.resultArray = [NSMutableArray array];
    PHOTOMANAGER.resultBlock = result;
    ImagesShowQQ *imagesView = [[ImagesShowQQ alloc] initImagesQQ];
    
    [imagesView addImagesArray];
    [imagesView setDelegate:PHOTOMANAGER];
    
    [PhotoAlbumManager getPhotoAlbums:^(NSArray *photoAlbums) {
        PHOTOMANAGER.photos = [NSMutableArray array];
        for (AlbumModel *model in photoAlbums) {
            [PHOTOMANAGER.photos addObjectsFromArray:model.photos];
        }
        [imagesView reloadDataWith:PHOTOMANAGER.photos];
    }];
    [imagesView show];

}

#pragma mark - 相机选择
+ (void)openCamera:(void(^)(UIImage *image))backImage {
    [[UIImageTool manager] openCameraInVC:PHOTOMANAGER.superVC resultImage:^(UIImage *image) {
        NSLog(@"%@",image);
    }];
}


#pragma mark - 处理选择的Photo
+ (void)dealImage:(PhotoModel *)model
      sourceArray:(NSArray *)sourceArray
        afterDeal:(void(^)(NSIndexPath *resultIndex))deal
        withSelf:(UIView *)imagesView {
    
    //此处更新其他页面的ImageView
    
    for (ImagesView *view in PHOTOMANAGER.loadArray) {
        if (![view isEqual:imagesView]) {
            [view reloadModel:model];
            for (PhotoModel *model in PHOTOMANAGER.resultArray ) {//避免其他bug
                [view reloadModel:model];
            }
        }
    }
    //通过index判断是否是已经选中的Photo
    NSIndexPath *indexPath;
    indexPath = [NSIndexPath indexPathForRow:[sourceArray indexOfObject:model] inSection:0];
    
    if (!model.modelIndex) {
        //添加
        //1.判断是否超过最大选择数
        if (PHOTOMANAGER.resultArray.count >= PHOTOMANAGER.maxSelect) {
            [AlertHeadView shareHint].backgroundColor = [UIColor whiteColor];
            [AlertHeadView shareHint].titleColor = [UIColor darkTextColor];
            [AlertHeadView shareHint].layer.borderColor = [UIColor darkGrayColor].CGColor;
            [AlertHeadView shareHint].layer.borderWidth = 1;
            [AlertHeadView showHint:[NSString stringWithFormat:@"亲,最多选择%ld张",(long)manager.maxSelect]];

        } else {
            [PHOTOMANAGER.resultArray addObject:model];
            model.modelIndex = [NSString stringWithFormat:@"%lu",(unsigned long)manager.resultArray.count];
        }
        deal(indexPath);
    } else {
        //移除
        //改变其他数值model的index
        NSInteger index = [model.modelIndex integerValue];
        NSIndexPath *changeIndex;
        for (PhotoModel *chooseModel in manager.resultArray) {
            indexPath = [NSIndexPath indexPathForRow:[sourceArray indexOfObject:model] inSection:0];
            if ([chooseModel.modelIndex integerValue] > index) {
                chooseModel.modelIndex = [NSString stringWithFormat:@"%ld",[chooseModel.modelIndex integerValue] - 1];
                changeIndex = [NSIndexPath indexPathForRow:[sourceArray indexOfObject:chooseModel] inSection:0];
                deal(changeIndex);
            }
        }
        [manager.resultArray removeObject:model];
        model.modelIndex = nil;
        deal(indexPath);
    }
}

#pragma mark - 返回选择的数组
+ (void)backChooseImages {
    if (PHOTOMANAGER.showBlcok) {
        PHOTOMANAGER.showBlcok();
    } else {
        [MLMLoading showLoadingWithTitle:@"正在处理..."];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *chooseArray = [NSMutableArray array];
        for (PhotoModel *chooseModel in PHOTOMANAGER.resultArray) {
            UIImage *chooseImage;
            if (PHOTOMANAGER.isOriginal) {
                chooseImage = chooseModel.fullResolutionImage;
                NSData *imageData =[UIImageTool compressImage:chooseImage maxLength:PHOTOMANAGER.dataMaxLength];
                chooseImage = [UIImage imageWithData:imageData];
            } else {
                chooseImage = chooseModel.aspectRatioThumbnail;
            }
            [chooseArray addObject:chooseImage];
        }
        if (PHOTOMANAGER.resultBlock) {
            if (PHOTOMANAGER.dismissBlcok) {
                PHOTOMANAGER.dismissBlcok();
            } else {
                [MLMLoading hidenLoading];
            }
            
            PHOTOMANAGER.resultBlock(chooseArray);
        }
    });
}

#pragma mark -单独处理一个PhotoModel(blcok可以写入自定义的动画)
+ (void)fullResolutionImageModel:(PhotoModel *)model
                       backImage:(void(^)(UIImage *image))backImage
                            show:(void(^)())show
                         dismiss:(void(^)())dismiss {
    if (show) {
        show();
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *chooseImage = model.fullResolutionImage;
        if (dismiss) {
            dismiss();
        }
        if (backImage) {
            backImage(chooseImage);
        }
    });

}


#pragma mark - ImagesViewDelegate
- (void)didSelectPhoto:(PhotoModel *)model atIndexPath:(NSIndexPath *)indexPath {
    ImagesDetailViewController *vc = [[ImagesDetailViewController alloc] init];
    vc.currentModel = model;
    vc.isPush = NO;
    vc.sourceArray = PHOTOMANAGER.photos;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [PHOTOMANAGER setNav:nav];
    
    [[AnimationManager manager] transitionType:AnimationManagerTypeModel fromVC:self.superVC toVC:nav];
}

///获取superView
+ (UIView *)superView {
    return PHOTOMANAGER.superVC.view;
}

@end
