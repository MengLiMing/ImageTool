//
//  ZoomViewController.m
//  ImageTool
//
//  Created by my on 16/6/18.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "ZoomViewController.h"
#import "MlMZoomScroll.h"
#import "UIImageTool.h"
#import "PhotoAlbumManager.h"

@interface ZoomViewController ()

@property (nonatomic, strong) MlMZoomScroll *scroll;

@end

@implementation ZoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择图片" style:UIBarButtonItemStylePlain target:self action:@selector(chooseImage)];
    _scroll = [[MlMZoomScroll alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scroll];
    
    //毛玻璃
//    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    blurView.frame = self.view.bounds;
//    [self.view addSubview:blurView];
    

    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.view.bounds];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [self.view addSubview:toolbar];
}

- (void)chooseImage {
    [[UIImageTool manager] openAlbumOrPhotoInVC:self completion:^(UIImage *image) {
        [_scroll setImage:image];
    } canEdit:NO];
}
@end
