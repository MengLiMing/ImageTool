//
//  ImagesShowQQ.m
//  ImageTool
//
//  Created by my on 16/6/8.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "ImagesShowQQ.h"
#import "BottomView.h"

#import <AVFoundation/AVFoundation.h>

#import "PhotoAlbumManager.h"
#import "AlbumModel.h"

#import "UIView+Category.h"
#import "UIView+FrameChange.h"
#import "UIButton+Category.h"

#import "UIView+SDAutoLayout.h"
#import "PhotoModel.h"

#import "PhotoAlbumManager.h"


#define ALL_HEIGHT (IMAGES_VIEW_H+BOTTOM_VIEW_H)
#define IMAGES_VIEW_H SCREEN_HEIGHT/4
#define BOTTOM_VIEW_H 40

#define SUPERVIEW [PhotoAlbumManager superView]
@interface ImagesShowQQ () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //buttonView
    BottomView *bottomView;
    
    UIButton *albumsButton;//相册
    UIButton *editButton;//编辑
    UIButton *chooseButton;//选择
    
    //图片选择
    ImagesView *imagesView;
    
    NSMutableArray *imagesArray;
}

@property (nonatomic, strong) UIView *cover;

@end

@implementation ImagesShowQQ

- (instancetype)initImagesQQ {
    if (self = [super init]) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ALL_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        [self initView];
        [self initBottom];
    }
    return self;
}



- (void)initView {

    imagesView = [[ImagesView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IMAGES_VIEW_H) type:ImageShowTypeQQ];
    if (imagesArray.count > 0) {
        imagesView.photoSource = [imagesArray copy];
    }
    [self addSubview:imagesView];
}

- (void)setDelegate:(id)delegate {
    imagesView.selectDelegate = delegate;
}


- (void)initBottom {
    __weak typeof(self) weakself = self;
    
    bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0,IMAGES_VIEW_H, SCREEN_WIDTH, BOTTOM_VIEW_H)];
    bottomView.backAction= ^(NSInteger index) {
        switch (index) {
            case 0:
            {
                [PhotoAlbumManager presentPhotoAlbum];
            }
                break;
            case 1:
            {
                [PhotoAlbumManager editPhoto];
            }
                break;
            case 2:
            {
                [weakself dismiss];
                [PhotoAlbumManager backChooseImages];
            }
                break;
            default:
                break;
        }
    };
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
}




- (UIView *)cover {
    if (!_cover) {
        _cover = [[UIView alloc] initWithFrame:SUPERVIEW.bounds];
        _cover.backgroundColor = RGBACOLOR(.8, .8, .8, 0);
        _cover.alpha = 0;
        [_cover tapHandle:^{
            [self dismiss];
        }];
    }
    return _cover;
}


- (void)show {
    [SUPERVIEW addSubview:self.cover];
    [SUPERVIEW addSubview:self];
    
    [UIView animateWithDuration:.3 animations:^{
        self.cover.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 animations:^{
            self.y -= ALL_HEIGHT;
        }];
    }];
}


- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        self.cover.alpha = 0;
        self.y += ALL_HEIGHT;
    } completion:^(BOOL finished) {
        [self.cover removeFromSuperview];
        [self removeFromSuperview];
    }];
}


- (void)reloadDataWith:(NSArray *)source {
    imagesView.photoSource = [source copy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [imagesView reloadData];
    });
}

- (void)addImagesArray {
    [PHOTOMANAGER.loadArray addObject:imagesView];
}

@end
