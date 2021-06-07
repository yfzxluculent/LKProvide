//
//  LKCaptivePortalCheck.m
//  LiemsMobile70
//
//  Created by WZheng on 2019/8/30.
//  Copyright © 2019 Luculent. All rights reserved.
//

#import "LKCaptivePortalCheck.h"
#import <WebKit/WebKit.h>
#import <SafariServices/SafariServices.h>

@interface LKCaptivePortalCheck()<WKNavigationDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, copy) void(^networkCheckComplection)(BOOL needAuthPassword);
@property (assign, nonatomic) BOOL needAlert;
/// 预期加载的url
@property (copy, nonatomic) NSURL *expectUrl;
/// 实际加载的url
@property (copy, nonatomic) NSURL *trueUrl;
@end

@implementation LKCaptivePortalCheck

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKCaptivePortalCheck *manager = nil;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[LKCaptivePortalCheck alloc] init];
            manager.expectUrl = [NSURL URLWithString:@"http://captive.apple.com/hotspotdetect.html"];
        }
    });
    return manager;
}

/// 检查当前wifi是否需要验证密码
- (void)checkIsWifiNeedAuthPasswordWithComplection:(void (^)(BOOL needAuthPassword))complection needAlert:(BOOL)needAlert {
    _needAlert = needAlert;
    _networkCheckComplection = complection;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.expectUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    [self.webView loadRequest:request];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.frame = CGRectZero;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
    
    self.trueUrl = navigationAction.request.URL;
    // 过滤异常url & 不能打开的url
    if (!self.trueUrl || ![[UIApplication sharedApplication] canOpenURL:self.trueUrl]) {
        self.trueUrl = self.expectUrl;
    }
    
    if (self.openTestMode) { // 测试用未认证时访问所有网页都会被重定向到该地址
        self.trueUrl= [NSURL URLWithString:@"http://www.baidu.com"];
    }
    if ([self.trueUrl.host containsString:@"captive.apple.com"]) {
        if (_networkCheckComplection) {
            _networkCheckComplection(NO);
            _networkCheckComplection = nil;
        }
    } else { // 网页被重定向到了self.trueUrl，wifi需要认证
        if (_networkCheckComplection) {
            _networkCheckComplection(YES);
            _networkCheckComplection = nil;
        }
        
        if (_needAlert) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            
            UIViewController *currentVc = [UIApplication sharedApplication].delegate.window.rootViewController;
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"WI-FI认证提醒" message:@"检测到当前WI-FI需要认证才能使用，请尝试去认证网络" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"认证" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
               
                CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
                if (systemVersion >= 9.0){
                    @try {
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:self.trueUrl];
                            if (currentVc.presentedViewController) {
                                [currentVc.presentedViewController presentViewController:safariVc animated:YES completion:nil];
                            } else if (currentVc) {
                                [currentVc presentViewController:safariVc animated:YES completion:nil];
                            }
                        });
                        
                        
                    } @catch (NSException *exception) {
#ifdef DEBUG
                        NSLog(@"CaptivePortalCheck 弹出SFSafariViewController异常：%@",exception);
#endif
                    }
                }else{
                    if ([[UIApplication sharedApplication] canOpenURL:self.trueUrl]) {
                        [[UIApplication sharedApplication] openURL:self.trueUrl];
                    }
                }
            }];
            [alert addAction:action];
            [alert addAction:action1];
            [currentVc presentViewController:alert animated:YES completion:nil];
            _needAlert = NO;
        }
    }
}

#pragma clang diagnostic pop

@end
