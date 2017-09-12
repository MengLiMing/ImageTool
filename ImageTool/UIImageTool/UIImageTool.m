//
//  UIImageTool.m
//  BaseProject
//
//  Created by my on 16/4/20.
//  Copyright © 2016年 base. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Accelerate/Accelerate.h>
#import "UIImageTool.h"
#import "AlertViewShow.h"



#define PHOTO_KEY @"photoVC"
#define PHOTOBLOCK_KEY @"photoBlcok"

static UIImageTool *manager;
@interface UIImageTool () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL edit;
@end

@implementation UIImageTool

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
        manager.edit = NO;
    });
    return manager;
}

#pragma mark - 保存图片
+ (void)saveImage:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//    [MBProgressHUDTool showWindowWith:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
//    [MBProgressHUDTool hideHuD];
    if (error) {
        NSLog(@"保存失败");
    } else {
        NSLog(@"保存成功");
    }
}

#pragma mark - 生成二维码
+ (UIImage *)createCodeImageWithSize:(CGFloat)size {
    UIImage *codeImage = [UIImage new];
    //二维码滤镜
    
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复滤镜的默认属性
    
    [filter setDefaults];
    
    //将字符串转换成NSData
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userName = [userDefaults objectForKey:@"userName"];
    
    //添加baishanghui区分是否是合法二维码
    NSData *data=[[NSString stringWithFormat:@"http://yzf.ftezu.com/wap/index.php?ctl=user&act=register&code=%@",userName] dataUsingEncoding:NSUTF8StringEncoding];
    
    //通过KVO设置滤镜inputmessage数据
    
    [filter setValue:data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    
    CIImage *outputImage=[filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    
    codeImage = [UIImageTool createNonInterpolatedUIImageFormCIImage:outputImage withSize:1000.0];
    
    return codeImage;
}

//改变二维码大小
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - 下载图片
+ (void)loadImageWithUrl:(NSString *)urlStr completion:(void (^)(UIImage *image))backImage{
    __block UIImage *image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *imageURL = [NSURL URLWithString:urlStr];
        NSData *data = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                image = [UIImage imageWithData:data];
                backImage(image);
            }
        });
    });
}

#pragma mark - 压缩照片
+ (NSData *)compressImage:(UIImage *)image percentage:(CGFloat)percentage {
    NSData *imagedata = UIImageJPEGRepresentation(image, percentage);
    return imagedata;
}

+ (NSData *)compressImage:(UIImage *)image maxLength:(CGFloat)maxLength {
    CGFloat max = maxLength * 1048576;
    NSData *imagedata = UIImageJPEGRepresentation(image, 1);
    if (imagedata.length > max) {
        imagedata = UIImageJPEGRepresentation(image, max/imagedata.length);
    }
    return imagedata;
}

#pragma mark - 生成图片
+ (UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0, 0, size.width, size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 打开相册或相机
- (void)openCameraInVC:(UIViewController *)vc resultImage:(void(^)(UIImage *image))backImage {
    objc_setAssociatedObject(self, PHOTO_KEY, vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, PHOTOBLOCK_KEY, backImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self takePhoto];
}

- (void)openAlbumOrPhotoInVC:(UIViewController *)vc completion:(void(^)(UIImage *image))backImage canEdit:(BOOL)edit {
    
    objc_setAssociatedObject(self, PHOTO_KEY, vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, PHOTOBLOCK_KEY, backImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.edit = edit;
    __block AlertViewShow *alertView = [[AlertViewShow alloc] initWithGraphic:AlertHeadGraphicCenterLeft title:@"请选择选取图片方式" image:[UIImage imageNamed:@"alert"] buttonType:@[@(1),@(1),@(1)] buttonsArray:@[@"打开照相机",@"打开手机相册",@"取消"] tapBlock:^(NSInteger index) {
        [alertView dismiss];
        switch (index)
        {
            case 0:  //打开照相机拍照
                [self takePhoto];
                break;
                
            case 1:  //打开本地相册
                [self LocalPhoto];
                break;
            default:
                break;
        }
    }];
    alertView.lineColor = [UIColor groupTableViewBackgroundColor];
    alertView.lineHeight = 1;
    alertView.tapCoverDismiss = NO;
    alertView.headView.MaxImageHeight = 20;
    alertView.coverColor = RGBACOLOR(.8, .8, .8, .3);
    [alertView show:AlertViewAnimationLeft];
}


//开始拍照
-(void)takePhoto
{
    UIViewController *vc = objc_getAssociatedObject(self, PHOTO_KEY);
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = self.edit;
    
    picker.editing = YES;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        picker.sourceType = sourceType;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            //判断相机是否能够使用
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if(status == AVAuthorizationStatusAuthorized) {
                // authorized
                [vc presentViewController:picker animated:YES completion:nil];
            } else if(status == AVAuthorizationStatusDenied){
                // denied
                return ;
            } else if(status == AVAuthorizationStatusRestricted){
                // restricted
            } else if(status == AVAuthorizationStatusNotDetermined){
                // not determined
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if(granted){
                        [vc presentViewController:picker animated:YES completion:nil];
                    } else {
                        return;
                    }
                }];
            }
        }
        
    }else
    {
        NSLog(@"模拟其中无法打开相机,请在真机中使用");
    }

}

//打开本地相册
-(void)LocalPhoto
{
    UIViewController *vc = objc_getAssociatedObject(self, PHOTO_KEY);
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [vc presentViewController:pickerImage animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    void (^backPhoto)(UIImage *) = objc_getAssociatedObject(self, PHOTOBLOCK_KEY);
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        SEL selectorToCall = @selector(image:didFinishSavingWithError:contextInfo:);
        // 将图像保存到相册（第三个参数需要传入上面格式的选择器对象）
        UIImageWriteToSavedPhotosAlbum(image, self, selectorToCall, NULL);
        backPhoto(image);
    } else {
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        if ([type isEqualToString:@"public.image"])
        {
            UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            backPhoto(image);
        }
    }
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 图片模糊
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}


#pragma mark - 剪切图片
-(UIImage *)cutFromImage:(UIImage *)image inRect:(CGRect)rect{
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

@end
