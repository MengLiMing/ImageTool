//
//  ImageShowCell.h
//  ImageTool
//
//  Created by my on 16/6/7.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoModel;

@interface ImageShowCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *selectIndexLab;

- (void)setCellWith:(PhotoModel *)model;

@end
