//
//  PhotosViewController.m
//  ImageTool
//
//  Created by my on 16/6/16.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "PhotosViewController.h"
#import "ImagesView.h"
#import "PhotoAlbumManager.h"
#import "ImagesDetailViewController.h"

#import "AnimationManager.h"

@interface PhotosViewController () <ImagesViewDelegate>
{
    ImagesView *imagesView;
}
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    
    imagesView = [[ImagesView alloc] initWithFrame:self.view.bounds type:ImageShowTypeCustom];
    imagesView.photoSource = [_photos copy];
    imagesView.selectDelegate = self;
    [self.view addSubview:imagesView];
    [PHOTOMANAGER.loadArray addObject:imagesView];
}

- (void)initNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
}

- (void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
    [PHOTOMANAGER.loadArray removeObject:imagesView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ImagesViewDelegate
- (void)didSelectPhoto:(PhotoModel *)model atIndexPath:(NSIndexPath *)indexPath {
    ImagesDetailViewController *vc = [[ImagesDetailViewController alloc] init];
    vc.currentModel = model;
    vc.isPush = YES;
    vc.sourceArray = imagesView.photoSource;
    
    [[AnimationManager manager] transitionType:AnimationManagerTypeNav fromVC:self toVC:vc];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
