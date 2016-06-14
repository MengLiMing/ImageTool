//
//  AlertButtonsView.m
//  AlertView
//
//  Created by my on 16/5/19.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "AlertButtonsView.h"

static const CGFloat space = 1;//默认间隔
static const CGFloat height = 40;//button高

#define DEFAULT_CELLID @"defaultCell"

@interface AlertButtonsView () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    TapIndex tapBlcok;
    
    //按钮总数
    NSInteger itemsCount;

}

@end

@implementation AlertButtonsView

- (instancetype)initWithTypeArray:(NSArray *)typeArr buttonsArray:(NSArray *)buttonArr tapBlock:(TapIndex)block {
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]]) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:DEFAULT_CELLID];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Identifierhead"];

        self.buttonsLayout = [NSMutableArray arrayWithArray:typeArr];
        self.buttonsArray = [NSMutableArray arrayWithArray:buttonArr];
        tapBlcok = block;
        _buttonHeight = height;
        [self initData];
        [self dealWithData];
    }
    return self;
}


#pragma mark - 默认数据
- (void)initData {
    _buttongroundColor = [UIColor whiteColor];
    _titleFont = [UIFont systemFontOfSize:14];
    _titleColor = [UIColor grayColor];
}

#pragma mark - 懒加载
- (void)setButtonsLayout:(NSMutableArray *)buttonsLayout {
    _buttonsLayout = buttonsLayout;
}
- (void)setButtonsArray:(NSMutableArray *)buttonsArray {
    _buttonsArray = buttonsArray;
}


#pragma mark - 属性设置
- (void)setButtonHeight:(CGFloat)buttonHeight {
    _buttonHeight = buttonHeight;
}

- (void)setButtongroundColor:(UIColor *)buttongroundColor {
    _buttongroundColor = buttongroundColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
}




#pragma mark - 处理按钮避免，编辑时使用出错
- (void)dealWithData {
    //根据布局样式得到的按钮个数
    __block CGFloat typeNum = 0;
    [_buttonsLayout enumerateObjectsUsingBlock:^(NSNumber *lineCount, NSUInteger idx, BOOL * _Nonnull stop) {
        typeNum += [lineCount integerValue];
    }];
    
    //根据按钮数组得到按钮个数
    CGFloat titleNum = _buttonsArray.count;
    

    //布局样式按钮个数输入过多
    if (typeNum > titleNum) {
        for (NSInteger i = 0; i < typeNum - titleNum; i ++) {
            [_buttonsArray addObject:@"设置出错"];
        }
    }
    
    //按钮个数多，则未设置样式的按钮均默认为每行一个
    if (titleNum > typeNum) {
        for (NSInteger i = 0; i < titleNum - typeNum; i ++) {
            [_buttonsLayout addObject:@(1)];
        }
    }
    
    //总按钮个数去最大值
    itemsCount = MAX(typeNum, titleNum);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return itemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DEFAULT_CELLID forIndexPath:indexPath];
    [cell.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            [obj removeFromSuperview];
        }
    }];
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;

    label.numberOfLines = 0;
    [cell addSubview:label];

    label.textColor = _titleColor;
    label.font = _titleFont;
    label.backgroundColor = _buttongroundColor;
    
    label.text = _buttonsArray[indexPath.row];
    label.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //当前行显示多少个cell
    NSInteger index = [self number:indexPath.row atArray:_buttonsLayout];
    NSInteger howMany = [_buttonsLayout[index] integerValue];
    
    //根据当前显示几个cell设置间距
    CGFloat itemWidth = (self.superview.frame.size.width - (howMany - 1)*space)/howMany;
    
    return CGSizeMake(itemWidth,_buttonHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.superview.frame.size.width, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (tapBlcok) {
        tapBlcok(indexPath.row);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Identifierhead" forIndexPath:indexPath];
    headView.backgroundColor = [UIColor whiteColor];
    return headView;
}


//是否应该高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 判断一个数在布局样式数组中的第几行
- (NSInteger)number:(NSInteger)index atArray:(NSArray *)array {
    //
    NSInteger count = 0;
    for (NSInteger i = 0; i < array.count; i ++) {
        count += [array[i] integerValue];
        if (count > index) {
            return i;
        }
    }
    return array.count - 1;
}

- (void)updateButtonsLayout {
    CGFloat selfH = _buttonsLayout.count * _buttonHeight + (_buttonsLayout.count - 1) * space + 0;
    self.sd_layout.heightIs(selfH);
    [self updateLayout];
    if (self.superview) {
        self.superview.sd_layout.heightIs(selfH + self.superview.frame.size.height);
        [self.superview updateLayout];
    }
}


#pragma mark - 替换button方法
- (void)changeButtonAtIndex:(NSInteger)index withDIYButton:(UIView *)button {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    for (UILabel *label in cell.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            button.frame = label.frame;
            [label removeFromSuperview];
            [cell addSubview:button];
        }
    }
}

@end
