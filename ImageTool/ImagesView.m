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
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            layout.minimumLineSpacing = 1;
            layout.minimumInteritemSpacing = 1;
            layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
            self.collectionViewLayout = layout;
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
    
    switch (_showType) {
        case ImageShowTypeQQ:
        {
            [cell setCellWith:model withImage:model.aspectRatioThumbnail];
        }
            break;
        case ImageShowTypeCustom:
        {
            [cell setCellWith:model withImage:model.thumbnail];
        }
            break;
        default:
            break;
    }
    
    [cell.selectIndexLab tapHandle:^{
        [PhotoAlbumManager dealImage:model sourceArray:_photoSource afterDeal:^(NSIndexPath *resultIndex) {
            [self reloadIndexPath:resultIndex];
        } withSelf:self];
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoModel *model = _photoSource[indexPath.row];
    switch (_showType) {
        case ImageShowTypeCustom:
        {
            return CGSizeMake((self.frame.size.width - 4)/3,(self.frame.size.width - 4)/3);
        }
            break;
        case ImageShowTypeQQ:
        {
                return CGSizeMake((self.frame.size.height - 4) * model.aspectRatioThumbnail.size.width/model.aspectRatioThumbnail.size.height, self.frame.size.height - 4);
        }
            break;
        default:
            break;
    }

}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoModel *model = _photoSource[indexPath.row];
    [self.selectDelegate didSelectPhoto:model atIndexPath:indexPath];
}


//刷新indexPath
- (void)reloadIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadItemsAtIndexPaths:@[indexPath]];
    });
}

- (void)reloadModel:(PhotoModel *)model {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.photoSource indexOfObject:model] inSection:0];
    [self reloadIndexPath:indexPath];
}

@end
