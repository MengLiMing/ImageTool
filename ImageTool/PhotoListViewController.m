//
//  PhotoListViewController.m
//  ImageTool
//
//  Created by my on 16/6/16.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "PhotoListViewController.h"

#import "PhotosViewController.h"

#import "AlbumModel.h"
#import "PhotoModel.h"
@interface PhotoListViewController ()

@end

@implementation PhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = 0;
    self.tableView.bounces = NO;
    [self initNav];
}

- (void)initNav {
    self.title = @"选择相册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
}


- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.photoList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    AlbumModel *albumModel = self.photoList[indexPath.section];
    //相册中的第一个图片
    UIImage *titImage;
    if (albumModel.photos.count > 0) {
        PhotoModel *photoModel = albumModel.photos[0];
        titImage = photoModel.thumbnail;
    } else {
        
    }
    
    cell.selectionStyle = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",albumModel.title,@(albumModel.photos.count)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.imageView setImage:titImage];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumModel *albumModel = self.photoList[indexPath.section];
    PhotosViewController *vc = [[PhotosViewController alloc] init];
    vc.photos = albumModel.photos;
    vc.title = albumModel.title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.f;
}

@end
