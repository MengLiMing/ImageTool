//
//  ImagesDetailViewController.m
//  ImageTool
//
//  Created by my on 16/6/18.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "ImagesDetailViewController.h"
#import "PhotoModel.h"
#import "ImagesDetailCell.h"
#import "PhotoAlbumManager.h"

#import "UIView+Category.h"

@interface ImagesDetailViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    UILabel *selectIndexLab;
    UICollectionView *collection;
}
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation ImagesDetailViewController

static NSString * const reuseIdentifier = @"ImagesDetailCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initCollection];
    
    if (_currentModel) {
        self.currentIndexPath = [NSIndexPath indexPathForRow:[self.sourceArray indexOfObject:_currentModel] inSection:0];
        [collection scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    } else {
        self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
}

- (void)initCollection {
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.itemSize = self.view.frame.size;
    
    collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [collection registerClass:[ImagesDetailCell class] forCellWithReuseIdentifier:reuseIdentifier];
    collection.pagingEnabled = YES;
    collection.dataSource = self;
    collection.delegate = self;
    [self.view addSubview:collection];
}
#pragma mark - 初始化navbar
- (void)initNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    [self initLabelItem];
}

//init RightItem
- (void)initLabelItem {
    if (!selectIndexLab) {
        selectIndexLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        selectIndexLab.textColor = [UIColor whiteColor];
        selectIndexLab.layer.cornerRadius = 25/2;
        selectIndexLab.layer.masksToBounds = YES;
        selectIndexLab.layer.borderWidth = 2;
        selectIndexLab.textAlignment = NSTextAlignmentCenter;
        selectIndexLab.font = [UIFont systemFontOfSize:17];
        selectIndexLab.layer.borderColor = [UIColor whiteColor].CGColor;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:selectIndexLab];
        [selectIndexLab tapHandle:^{
            [PhotoAlbumManager dealImage:_currentModel sourceArray:_sourceArray afterDeal:^(NSIndexPath *resultIndex) {
                selectIndexLab.text = _currentModel.modelIndex;
            } withSelf:self.view];
        }];
        
    }
    self.currentModel = _currentModel;
}

- (void)setCurrentModel:(PhotoModel *)currentModel {
    _currentModel = currentModel;
    selectIndexLab.text = _currentModel.modelIndex;
}


- (void)dismiss {
    if (_isPush) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath {
    _currentIndexPath = currentIndexPath;
    self.currentModel = _sourceArray[currentIndexPath.row];
    self.title = [NSString stringWithFormat:@"%@/%@",@(currentIndexPath.row+1),@(self.sourceArray.count)];
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _sourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoModel *model = _sourceArray[indexPath.row];

    ImagesDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.zoomScroll.singleTap = ^(){
        //单击隐藏导航栏和底部
        [self setNavHiden];
    };
    
    [cell.zoomScroll setImage:nil];
    
    [PhotoAlbumManager fullResolutionImageModel:model backImage:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.zoomScroll setImage:image];
        });
    } show:^{
        [cell.zoomScroll showIndicator];
    } dismiss:^{
        [cell.zoomScroll hidenIndicator];
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    ImagesDetailCell *detailCell = (ImagesDetailCell *)cell;
    detailCell.zoomScroll.zoomScale = 1;
}



#pragma mark - scroll
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == (UIScrollView *)collection) {//UICollectionView是继承于UIScrollView的
        NSInteger current = scrollView.contentOffset.x / self.view.frame.size.width;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:current inSection:0];
        self.currentIndexPath = indexPath;
    }
}

#pragma mark - 单击隐藏
- (void)setNavHiden {
    if (self.navigationController.navigationBar.isHidden) {
        self.navigationController.navigationBar.hidden = NO;
        [UIApplication sharedApplication].statusBarHidden = NO;
    }else{
        self.navigationController.navigationBar.hidden = YES;
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
}

@end
