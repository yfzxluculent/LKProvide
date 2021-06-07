//
//  LKSignaTureViewController.m
//  LKSignatureDome
//
//  Created by 张军 on 2021/4/28.
//

#import "LKSignaTureViewController.h"
#import "LKSignaTureView.h"
#import "Masonry.h"
@interface LKSignaTureViewController ()

@property (nonatomic, strong) LKSignaTureView *signView;
@property(strong, nonatomic) UIButton *clearBtn;
@property(strong, nonatomic) UIButton *saveBtn;
@property(strong, nonatomic) UILabel *tipLabel;

@end

@implementation LKSignaTureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.title = @"个人签名";
    [self.view addSubview:self.signView];
    [self createView];
}

-(void)createView{
    [self.view addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.left.equalTo(self.view.mas_centerX);
        make.height.equalTo(@60);
        make.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:self.clearBtn];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_centerX);
        make.height.equalTo(@60);
        make.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:self.signView];
    [self.signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(98);
        make.bottom.equalTo(self.clearBtn.mas_top).offset(-10);
    }];
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.signView);
        make.height.equalTo(@15);
    }];


    
}
#pragma mark 初始化
- (LKSignaTureView *)signView
{
    if (!_signView) {
        _signView = [[LKSignaTureView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100)];
        _signView.panColor = self.panColor;
        _signView.panWidth = self.panWidth;
        _signView.backgroundColor = [UIColor whiteColor];
        [self.view sendSubviewToBack:_signView];
    }
    return _signView;
}
#pragma mark 按钮点击方法
- (void)btnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
            
            break;
        case 101:
            [_signView revoke];
            break;
        case 102:
            [_signView clear];
        
            break;
        case 103:

           self.saveImage([_signView saveDraw]);
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}

-(UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc]init];
        [_saveBtn setBackgroundColor:[UIColor colorWithRed:82/255.0 green:130/255.0 blue:246/255.0 alpha:1.0]];
        [_saveBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn.tag = 103;
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _saveBtn;
}

-(UIButton *)clearBtn{
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc]init];
        _clearBtn.backgroundColor = [UIColor whiteColor];
        [_clearBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _clearBtn.tag = 102;
        [_clearBtn setTitleColor:[UIColor colorWithRed:82/255.0 green:130/255.0 blue:246/255.0 alpha:1.0] forState:UIControlStateNormal];

    }
    return _clearBtn;
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel  = [[UILabel alloc]init];
        _tipLabel.text = @"请在屏幕上签下你的名字";
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:14];
    }
    return _tipLabel;
}
-(UIColor *)panColor{
    if (!_panColor) {
        _panColor = [UIColor blackColor];
    }
    return _panColor;
    
}
-(CGFloat)panWidth{
    if (!_panWidth) {
        _panWidth = 8;
    }
    return _panWidth;
}

@end
