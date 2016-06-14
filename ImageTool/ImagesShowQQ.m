//
//  ImagesShowQQ.m
//  ImageTool
//
//  Created by my on 16/6/8.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "ImagesShowQQ.h"

#import <AVFoundation/AVFoundation.h>

#import "ImagesView.h"
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


@interface ImagesShowQQ () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //buttonView
    UIView *bottomView;
    
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


- (void)initBottom {
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,IMAGES_VIEW_H, SCREEN_WIDTH, BOTTOM_VIEW_H)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor blackColor];
    [bottomView addSubview:lineView];
    
    lineView.sd_layout
    .topSpaceToView(bottomView,0)
    .leftSpaceToView(bottomView,0)
    .rightSpaceToView(bottomView,0)
    .heightIs(1);
    
    albumsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [albumsButton setTitle:@"相册" forState:UIControlStateNormal];
    albumsButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [albumsButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [bottomView addSubview:albumsButton];
    
    
    editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [editButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [bottomView addSubview:editButton];
    editButton.enabled = NO;
    
    
    
    chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseButton setTitle:@"确定" forState:UIControlStateNormal];
    chooseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [chooseButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [bottomView addSubview:chooseButton];
    
    albumsButton.layer.borderWidth = editButton.layer.borderWidth = chooseButton.layer.borderWidth = 1;
    albumsButton.layer.borderColor = editButton.layer.borderColor = chooseButton.layer.borderColor = [UIColor darkTextColor].CGColor;
    albumsButton.layer.cornerRadius = editButton.layer.cornerRadius = chooseButton.layer.cornerRadius = 5;
    
    [chooseButton handle:^{
        [self dismiss];
        [PhotoAlbumManager backChooseImages];
    }];
    
    
    
    
    albumsButton.sd_layout
    .topSpaceToView(bottomView,5)
    .bottomSpaceToView(bottomView,5)
    .leftSpaceToView(bottomView,5)
    .widthIs(60);
    
    editButton.sd_layout
    .topSpaceToView(bottomView,5)
    .bottomSpaceToView(bottomView,5)
    .leftSpaceToView(albumsButton,5)
    .widthIs(60);
    
    
    chooseButton.sd_layout
    .topSpaceToView(bottomView,5)
    .bottomSpaceToView(bottomView,5)
    .rightSpaceToView(bottomView,10)
    .widthIs(60);
    
}


- (UIView *)cover {
    if (!_cover) {
        _cover = [[UIView alloc] initWithFrame:KEYWINDOW.bounds];
        _cover.backgroundColor = RGBACOLOR(.8, .8, .8, .3);
        _cover.alpha = 0;
        [_cover tapHandle:^{
            [self dismiss];
        }];
    }
    return _cover;
}


- (void)show {
    [KEYWINDOW addSubview:self.cover];
    [KEYWINDOW addSubview:self];
    
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


@end
