//
//  GetImageViewController.m
//  ImageTool
//
//  Created by my on 16/6/7.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "GetImageViewController.h"
#import "PhotoAlbumManager.h"

#import "ImagesView.h"

#import "ImagesShowQQ.h"

#import "UIView+FrameChange.h"

#import "AlertViewShow.h"

#import "PhotoModel.h"
#import "AlbumModel.h"

@interface GetImageViewController ()
{
    NSArray *source;
}
@end

@implementation GetImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)show:(UIButton *)sender {

    PHOTOMANAGER.maxSelect = 4;
    PHOTOMANAGER.percentage = .5;
    [PHOTOMANAGER showPhotoCamera:^(UIImage *image) {
        NSLog(@"%@",image);
    } photoAlbums:^(NSArray *result) {
        NSLog(@"%@",result);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
