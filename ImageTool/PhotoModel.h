//
//  PhotoModel.h
//  ImageTool
//
//  Created by my on 16/6/7.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface PhotoModel : NSObject

@property (nonatomic, strong) UIImage *preview;//图片
@property (nonatomic, strong) ALAsset *asset;//图片的属性

@property (nonatomic, copy) NSString *modelIndex;//下标
@property (nonatomic, strong) NSIndexPath *modelIndexPaht;//对应cell上的位置

+ (instancetype)libraryPhotoFromAsset:(ALAsset *)theAsset;
@end
