//
//  ViewController.m
//  ZBarTest
//
//  Created by biznest on 15/8/5.
//  Copyright (c) 2015年 xf. All rights reserved.
//

#import "ViewController.h"
#import "ZBarSDK.h"
//扫描框
#import "ZBarRectView.h"
//网格动画
#import "GridAnimationView.h"

@interface ViewController () <ZBarReaderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    ZBarReaderViewController *_zbarCtr;
    BOOL _isPhotoScan;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//二维码扫描
- (IBAction)bt:(id)sender {
    _isPhotoScan = NO;
    _zbarCtr = [ZBarReaderViewController new];
    _zbarCtr.readerDelegate = self;
    //关闭捏合手势
//    _zbarCtr.readerView.allowsPinchZoom = NO;
    //关闭闪光灯
    _zbarCtr.readerView.torchMode = 0;
    //显示帧率
    //    _zbarCtr.readerView.showsFPS = YES;
    //隐藏tabbar
    //    _zbarCtr.hidesBottomBarWhenPushed = YES;
    //隐藏底部控制按钮
//    _zbarCtr.showsZBarControls = YES;
    //自定义扫描界面
    [self setOverlayPickerView:_zbarCtr];
    ZBarImageScanner *scanner = _zbarCtr.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:_zbarCtr animated:YES];

}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    //横屏
    //    CGFloat x,y,width,height;
    //
    //    x = rect.origin.x / readerViewBounds.size.width;
    //    y = rect.origin.y / readerViewBounds.size.height;
    //    width = rect.size.width / readerViewBounds.size.width;
    //    height = rect.size.height / readerViewBounds.size.height;
    //
    //    return CGRectMake(x, y, width, height);
    
    //竖屏
    CGFloat x,y,width,height;
    x = rect.origin.y / readerViewBounds.size.height;
    y = 1 - (rect.origin.x + rect.size.width) / readerViewBounds.size.width;
    width = (rect.origin.y + rect.size.height) / readerViewBounds.size.height;
    height = 1 - rect.origin.x / readerViewBounds.size.width;
    return CGRectMake(x, y, width, height);
}

//自定义扫描界面
- (void)setOverlayPickerView:(ZBarReaderViewController *)reader
{
    //清除原有控件
    for (UIView *temp in [reader.view subviews]) {
        for (UIButton *button in [temp subviews]) {
            if ([button isKindOfClass:[UIButton class]]) {
                [button removeFromSuperview];
            }
        }
        
        for (UIToolbar *toolbar in [temp subviews]) {
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                [toolbar setHidden:YES];
                [toolbar removeFromSuperview];
            }
        }
    }

    //扫描框
    ZBarRectView *zbarRectView = [[ZBarRectView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.width - 100)];
    zbarRectView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    zbarRectView.backgroundColor = [UIColor clearColor];
    [reader.view addSubview:zbarRectView];
    //设置扫描区域
    _zbarCtr.readerView.scanCrop = [self getScanCrop:zbarRectView.frame readerViewBounds:self.view.bounds];
    //方格动画
    GridAnimationView *gridAnimationView = [[GridAnimationView alloc] initWithFrame:CGRectInset(zbarRectView.frame, 2, 2)];
    [reader.view addSubview:gridAnimationView];
    
    //功能按钮
    NSArray *btArr = @[@"相册", @"闪光灯", @"退出"];
    for (int i = 0; i < 3; i ++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeSystem];
        [bt setTitle:btArr[i] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.backgroundColor = [UIColor whiteColor];
        bt.layer.cornerRadius = 25.0f;
        bt.layer.masksToBounds = YES;
        bt.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/7 * (2 * i + 1), zbarRectView.frame.origin.y - 50 - 20, 50, 50);
        bt.tag = 100 + i;
        [bt addTarget:self action:@selector(zbarClick:) forControlEvents:UIControlEventTouchUpInside];
        [reader.view addSubview:bt];
    }

    //提示说明
    UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, zbarRectView.frame.origin.y + zbarRectView.frame.size.height + 30, [UIScreen mainScreen].bounds.size.width, 40)];
    remindLabel.numberOfLines = 0;
    remindLabel.text = @"将二维码放到框内";
    remindLabel.textColor = [UIColor whiteColor];
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [reader.view addSubview:remindLabel];
}

- (void)zbarClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
        {
            //相册
            [self photoScan];
        }
            break;
        case 101:
        {
            //闪光灯
            _zbarCtr.readerView.torchMode = (_zbarCtr.readerView.torchMode==0?1:0);
        }
            break;
        case 102:
        {
            //退出
            [_zbarCtr.navigationController popViewControllerAnimated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)photoScan
{
    _isPhotoScan = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        [_zbarCtr presentViewController:imagePickerController animated:YES completion:nil];
    }else{
        NSLog(@"相册不能用。。。");
    }
}

//扫描结果
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    ZBarSymbol *symbol = nil;

    if (_isPhotoScan) {
        //照片
        [self dismissViewControllerAnimated:YES completion:nil];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        ZBarReaderController* read = [ZBarReaderController new];
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        for(symbol in [read scanImage:cgImageRef])
            break;
        if (symbol == nil) {
            NSLog(@"扫描失败!");
        }else{
            NSLog(@"%@",symbol.data);
        }
    }else{
        //相机
        id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
        for (symbol in results) {
            break ;
        }
        NSLog(@"%@",symbol.data);
    }
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
    lb.numberOfLines = 0;
    lb.backgroundColor = [UIColor purpleColor];
    lb.center = _zbarCtr.view.center;
    lb.text = [symbol data];
    lb.textAlignment = NSTextAlignmentCenter;
    [_zbarCtr.view addSubview:lb];
    [lb performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
}


@end
