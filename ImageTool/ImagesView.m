//
//  ImagesView.m
//  ImageTool
//
//  Created by my on 16/6/7.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "ImagesView.h"
#import "ImageShowCell.h"
#import "PhotoAlbumManager.h"

#define CELL_ID @"ImageShowCell"

@interface ImagesView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    PhotoAlbumManager *manager;
}
/**
 * 展现样式
 */
@property (nonatomic, assign) ImageShowType showType;

@end

@implementation ImagesView

- (instancetype)initWithFrame:(CGRect)frame type:(ImageShowType)type {
    
    if (self = [super initWithFrame:frame collectionViewLayout:[UICollectionViewLayout new]]) {
        
        [self registerNib:[UINib nibWithNibName:CELL_ID bundle:nil] forCellWithReuseIdentifier:CELL_ID];
        self.showType = type;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        
        manager = PHOTOMANAGER;
        
        [self initCollection];
    }
    
    return self;
}


#pragma mark - 初始化view
- (void)initCollection {
    switch (_showType) {
        case ImageShowTypeCustom:
        {
            
        }
            break;
        case ImageShowTypeWaterWall:
        {
            
        }
            break;
        case ImageShowTypeQQ:
        {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.minimumLineSpacing = 2;
            layout.minimumInteritemSpacing = 2;
            layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
            self.collectionViewLayout = layout;
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - collection代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];

    PhotoModel *model = _photoSource[indexPath.row];
    [cell setCellWith:model];

    [cell.selectIndexLab tapHandle:^{
        [[PhotoAlbumManager manager] dealImage:model indexPath:indexPath afterDeal:^(NSIndexPath *resultIndex) {
            [self reloadIndexPath:resultIndex];
        }];
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoModel *model = _photoSource[indexPath.row];
    return CGSizeMake((self.frame.size.height - 4) * model.preview.size.width/model.preview.size.height, self.frame.size.height - 4);
}


//刷新indexPath
- (void)reloadIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadItemsAtIndexPaths:@[indexPath]];
    });
}

@end
