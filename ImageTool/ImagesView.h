//
//  ImagesView.h
//  ImageTool
//
//  Created by my on 16/6/7.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbumHeader.h"

//选择相册图片的样式
typedef NS_ENUM(NSUInteger,ImageShowType) {
    ImageShowTypeCustom,//默认样式，苹果系统样式
    ImageShowTypeQQ//qq选择样式
};

@protocol ImagesViewDelegate <NSObject>

- (void)didSelectPhoto:(PhotoModel *)model atIndexPath:(NSIndexPath *)indexPath;

@end

@interface ImagesView : UICollectionView

/**
 * 数据源
 */
@property (nonatomic, strong) NSArray *photoSource;

@property (nonatomic, weak) id<ImagesViewDelegate> selectDelegate;

- (instancetype)initWithFrame:(CGRect)frame type:(ImageShowType)type;

- (void)reloadModel:(PhotoModel *)model;

@end
