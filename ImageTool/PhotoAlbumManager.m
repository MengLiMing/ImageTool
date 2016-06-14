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
#import "UIImageTool.h"

static PhotoAlbumManager *manager = nil;

@interface PhotoAlbumManager ()

@property (nonatomic, weak) ChooseImage resultBlock;

@property (nonatomic, strong) ALAssetsLibrary *assetsLibray;

//相册数组
@property (nonatomic,strong) NSMutableArray *photoAlbums;

//所有相片的数组
@property (nonatomic,strong) NSMutableArray *photos;

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
        manager.percentage = 1.0;
    });
    return manager;
}


- (void)setIsOriginal:(BOOL)isOriginal {
    _isOriginal = isOriginal;
    if (!isOriginal && self.percentage == 1) {
        _percentage = 0.5;
    }
}

- (void)setPercentage:(CGFloat)percentage {
    if (percentage >= 1) {
        _percentage = 1;
    } else {
        _isOriginal = NO;
        _percentage = percentage;
    }
}

#pragma mark - 获取相册block
- (void)getPhotoAlbums:(void (^)(NSArray *))resultBlock {
    //创建数组保存相册
    self.photoAlbums = [NSMutableArray array];
    self.photos = [NSMutableArray array];
    
    //通过block，遍历资源中的相册
    NSAssert(_assetsLibray != nil, @"assetsLibray为nil");
    [_assetsLibray enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group == nil) {
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
        [self.photoAlbums addObject:albumModel];
        //返回整数据
        resultBlock(self.photoAlbums);
    } failureBlock:NULL];
}


- (void)showPhotoAlbumResult:(ChooseImage)result {
    self.resultArray = [NSMutableArray array];
    self.resultBlock = result;
    
    ImagesShowQQ *imagesView = [[ImagesShowQQ alloc] initImagesQQ];
    
    [self getPhotoAlbums:^(NSArray *photoAlbums) {
        for (AlbumModel *model in photoAlbums) {
            [self.photos addObjectsFromArray:model.photos];
        }
        [imagesView reloadDataWith:self.photos];
    }];
    [imagesView show];

}

- (void)openCamera:(void(^)(UIImage *image))backImage {
    [[UIImageTool manager] openCamera:backImage];
}


//处理选择的Photo
- (void)dealImage:(PhotoModel *)model indexPath:(NSIndexPath *)indexPath afterDeal:(void(^)(NSIndexPath *resultIndex))deal{
    //通过index判断是否是已经选中的Photo
    if (!model.modelIndex) {
        //添加
        //1.判断是否超过最大选择数
        if (self.resultArray.count >= self.maxSelect) {
            [AlertHeadView shareHint].backgroundColor = [UIColor whiteColor];
            [AlertHeadView shareHint].titleColor = [UIColor darkTextColor];
            [AlertHeadView showHint:[NSString stringWithFormat:@"亲,最多选择%ld张",(long)manager.maxSelect]];

        } else {
            [self.resultArray addObject:model];
            model.modelIndex = [NSString stringWithFormat:@"%lu",(unsigned long)manager.resultArray.count];
            model.modelIndexPaht = indexPath;
        }
        deal(indexPath);
    } else {
        //移除
        //改变model的index
        NSInteger index = [model.modelIndex integerValue];
        for (PhotoModel *chooseModel in manager.resultArray) {
            if ([chooseModel.modelIndex integerValue] > index) {
                chooseModel.modelIndex = [NSString stringWithFormat:@"%ld",[chooseModel.modelIndex integerValue] - 1];
            }
            deal(chooseModel.modelIndexPaht);
        }
        [manager.resultArray removeObject:model];
        model.modelIndex = nil;
        deal(indexPath);
    }
}

#pragma mark - 返回选择的数组
+ (void)backChooseImages {
    NSMutableArray *chooseArray = [NSMutableArray array];
    for (PhotoModel *chooseModel in PHOTOMANAGER.resultArray) {
        UIImage *chooseImage = chooseModel.preview;
        if (!PHOTOMANAGER.isOriginal) {
            NSData *imageData =[UIImageTool compressImage:chooseImage percentage:PHOTOMANAGER.percentage];
            chooseImage = [UIImage imageWithData:imageData];
        }
        [chooseArray addObject:chooseImage];
    }
    if (PHOTOMANAGER.resultBlock) {
        PHOTOMANAGER.resultBlock(chooseArray);
    }
}

#pragma mark - 整体使用
- (void)showPhotoCamera:(void(^)(UIImage *image))backImage photoAlbums:(ChooseImage)result {
    __block AlertViewShow *alertView = [[AlertViewShow alloc] initWithGraphic:AlertHeadGraphicCenterLeft title:@"请选择选取图片方式" image:[UIImage imageNamed:@"alert"] buttonType:@[@(2),@(1)] buttonsArray:@[@"打开照相机",@"打开手机相册",@"取消"] tapBlock:^(NSInteger index) {
        [alertView dismiss];
        switch (index)
        {
            case 0:  //打开照相机拍照
                [PHOTOMANAGER openCamera:backImage];
                break;
            case 1:  //打开本地相册
            {
                [PHOTOMANAGER showPhotoAlbumResult:result];
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

@end
