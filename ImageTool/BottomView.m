//
//  BottomView.m
//  ImageTool
//
//  Created by my on 16/6/16.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "BottomView.h"

@interface BottomView ()
{
    __weak IBOutlet UIButton *photoAlbum;
    __weak IBOutlet UIButton *edit;
    __weak IBOutlet UIButton *confirm;
}

@end

@implementation BottomView


- (void)awakeFromNib {
    photoAlbum.layer.borderWidth = edit.layer.borderWidth = confirm.layer.borderWidth = 1;
    photoAlbum.layer.borderColor = edit.layer.borderColor = confirm.layer.borderColor = [UIColor darkTextColor].CGColor;
    photoAlbum.layer.cornerRadius = edit.layer.cornerRadius = confirm.layer.cornerRadius = 5;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle] loadNibNamed:@"BottomView" owner:self options:nil][0];
    self.frame = frame;
    return self;
}

- (IBAction)photoAlbumAction:(UIButton *)sender {
    [self blockAction:0];
}
- (IBAction)editAction:(UIButton *)sender {
    [self blockAction:1];
}
- (IBAction)confirmAction:(UIButton *)sender {
    [self blockAction:2];
}

- (void)blockAction:(NSInteger)index {
    if (self.backAction) {
        self.backAction(index);
    }
}

- (void)changeEditEnabled {
    
}

@end
