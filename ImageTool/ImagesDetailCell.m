//
//  ImagesDetailCell.m
//  ImageTool
//
//  Created by my on 16/6/18.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "ImagesDetailCell.h"

@implementation ImagesDetailCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.zoomScroll = [[MlMZoomScroll alloc] initWithFrame:self.bounds];
        [self addSubview:self.zoomScroll];
    }
    return self;
}

@end
