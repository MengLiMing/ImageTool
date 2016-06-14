//
//  AlbumModel.h
//  ImageTool
//
//  Created by my on 16/6/7.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumModel : NSObject

@property (nonatomic, strong) NSArray *photos;//相册中的所有图片
@property (nonatomic, copy) NSString *title;//相册的title

@end
