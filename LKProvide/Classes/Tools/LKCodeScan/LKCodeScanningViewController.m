//
//  LKCodeScanningViewController.h
//  LiemsMobile70
//
//  Created by WZheng on 2021/5/7.
//  Copyright © 2021 Luculent. All rights reserved.
//

#import "LKCodeScanningViewController.h"
#import "QiCodePreviewView.h"
#import "QiCodeManager.h"

@interface LKCodeScanningViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) QiCodePreviewView *previewView;
@property (nonatomic, strong) QiCodeManager *codeManager;
@property (nonatomic, strong) UIButton *ablumnButton;

@end

@implementation LKCodeScanningViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat rectSide = fminf(self.view.bounds.size.width, self.view.bounds.size.height) * 2 / 2.2;
    CGRect rectFrame = CGRectMake((self.view.bounds.size.width - rectSide) / 2, (self.view.bounds.size.height - rectSide) / 2, rectSide, rectSide);
    UIColor *rectColor = [UIColor colorWithRed:((float)((0x4880FF & 0xFF0000) >> 16))/255.0 green:((float)((0x4880FF & 0xFF00) >> 8))/255.0 blue:((float)(0x4880FF & 0xFF))/255.0 alpha:1.0];
    _previewView = [[QiCodePreviewView alloc] initWithFrame:self.view.bounds rectFrame:rectFrame rectColor:rectColor];
    _previewView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _previewView.showAlbum = self.isShowAlbum;
    [self.view addSubview:_previewView];
    __weak typeof(self) weakSelf = self;
    _previewView.didClickedAlbumBlock = ^{
        [weakSelf photo];
    };
    _codeManager = [[QiCodeManager alloc] initWithPreviewView:_previewView completion:^{
        [weakSelf startScanning];
    }];
    
    
    // 隐藏导航栏
    self.navigationController.delegate = self;
    // 自定义导航侧滑
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self; // 设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:panGesture];
    // 一定要禁止系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [backBtn setImage:[UIImage imageNamed:@"qi_arrow_back"] forState:(UIControlStateNormal)];;
    [backBtn addTarget:self action:@selector(goBackAction) forControlEvents:(UIControlEventTouchUpInside)];
        
    CGFloat HEIGHT = [self isAlienScreen] ? 44+44 : 20+44;
    backBtn.frame = CGRectMake(12, HEIGHT - 12 - 22, 22, 22);
    [self.view addSubview:backBtn];
    
   
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self startScanning];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [_codeManager stopScanning];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)goBackAction{
    if (self.navigationController) {

        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dismiss{
    [self goBackAction];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
    if(self.navigationController.childViewControllers.count == 1)
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - Private functions
- (void)photo {
    __weak typeof(self) weakSelf = self;
    [_codeManager presentPhotoLibraryWithRooter:self callback:^(NSString * _Nonnull code) {
        !weakSelf.didScanBlock?:weakSelf.didScanBlock(code, weakSelf);
    }];
}
- (void)startScanning {
    
    __weak typeof(self) weakSelf = self;
    [_codeManager startScanningWithCallback:^(NSString * _Nonnull code) {
        !weakSelf.didScanBlock?:weakSelf.didScanBlock(code, weakSelf);
    } autoStop:YES];
}

- (BOOL)isAlienScreen{
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

@end
