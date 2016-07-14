//
//  ImageShowCell.m
//  ImageTool
//
//  Created by my on 16/6/7.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "ImageShowCell.h"
#import "PhotoModel.h"

@implementation ImageShowCell

- (void)awakeFromNib {
    _selectIndexLab.layer.cornerRadius = 25/2;
    _selectIndexLab.layer.masksToBounds = YES;
    _selectIndexLab.layer.borderWidth = 2;
    _selectIndexLab.layer.borderColor = [UIColor whiteColor].CGColor;
}


- (void)setCellWith:(PhotoModel *)model withImage:(UIImage *)image{
    [self.photoImage setImage:image];
    
    self.selectIndexLab.text = model.modelIndex;
    
    //绑定数据源
    if (!model.modelIndex) {
        _selectIndexLab.backgroundColor = [UIColor clearColor];
    } else {
        _selectIndexLab.textColor = [UIColor whiteColor];
        _selectIndexLab.backgroundColor = [UIColor darkTextColor];
    }
}
@end
