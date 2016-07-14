//
//  MainViewController.m
//  ImageTool
//
//  Created by my on 16/6/7.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "MainViewController.h"
#import "IAPManager.h"

@interface MainViewController ()
{
    NSArray *listArray;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.hidesBarsOnSwipe = YES;
    
    listArray = @[@"获取图片",@"放大图片",@"应用内支付"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = listArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            [self.navigationController pushViewController:[NSClassFromString(@"GetImageViewController") new] animated:YES];
        }
            break;
        case 1:
        {
            [self.navigationController pushViewController:[NSClassFromString(@"ZoomViewController") new] animated:YES];

        }
            break;
        case 2:
        {
            [[IAPManager sharedIAPManager] purchaseProductForId:@"superpremiumversion"
                                                     completion:^(SKPaymentTransaction *transaction) {
                                                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                         UIAlertView *thanks = [[UIAlertView alloc] initWithTitle:@"Thanks!"
                                                                                                          message:@"The extra features are now available"
                                                                                                         delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                         [thanks show];
                                                     } error:^(NSError *err) {
                                                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                         
                                                         NSLog(@"An error occured while purchasing: %@", err.localizedDescription);
                                                         // show an error alert to the user.
                                                     }];
        }
            break;
        default:
            break;
    }
}

@end
