//
//  LKAlertMultiChooseView.m
//  LiemsMobileEnterprise
//
//  Created by zhanghaitao on 2018/4/9.
//  Copyright © 2018年 Jasper. All rights reserved.
//

#import "LKAlertMultiChooseView.h"

#define ALERT_COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define ALERT_TEXT_LIGHTCOLOR ALERT_COLOR(152, 152, 152, 1)
#define ALERT_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define ALERT_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface LKAlertMultiChooseView()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *dataArr;
    NSArray *selectedArr;
    NSString *titleName;
}


@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic) CGFloat margin;
@property (nonatomic) CGFloat rowHeight;
@property (nonatomic, copy) UIColor *blueOfSystem;
@end

@implementation LKAlertMultiChooseView

- (instancetype)initWithTitle:(NSString *)name referenceArr:(NSArray<LKAlertModel *> *)arr selectedArr:(NSArray<LKAlertModel *> *)sarr{
    
    self = [super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        dataArr = arr;
        
        selectedArr = sarr;

        if (![sarr isKindOfClass:[NSArray class]]) {
            selectedArr = @[];
        }
        titleName = name;
        
        for (LKAlertModel *model in dataArr) {
            model.selected = [self getSelectedStatusOfModel:model];
        }
        
        [self addTwoBtn];
        [self addSubview:self.bodyView];
        
    }
    
    return self;
}

#pragma-mark UI

- (UIColor *)blueOfSystem{
    
    if (!_blueOfSystem) {
        _blueOfSystem = ALERT_COLOR(0, 121, 255, 1);
    }
    
    return _blueOfSystem;
}

- (CGFloat)margin{
    return 10;
}

- (CGFloat)rowHeight{
    return 58;
}

- (UIView *)bodyView{
    
    if (!_bodyView) {
        
        CGFloat bodyViewHeight = CGRectGetHeight(self.tableView.bounds) + 44;
        
        
        CGFloat buttonViewHeight = self.rowHeight + ([self screenInsets].bottom>0?0:self.margin) + [self screenInsets].bottom;
        
        UIView *bodyView = [[UIView alloc] init];

        bodyView.frame = CGRectMake(self.margin, ALERT_SCREEN_HEIGHT - bodyViewHeight - self.margin - buttonViewHeight, ALERT_SCREEN_WIDTH-2*self.margin, bodyViewHeight);

        bodyView.layer.cornerRadius = 13;
        bodyView.layer.masksToBounds = YES;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ALERT_SCREEN_WIDTH-2*self.margin, 43.5)];
        titleLabel.textColor = ALERT_TEXT_LIGHTCOLOR;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = titleName ? : @"";
        titleLabel.backgroundColor = [UIColor whiteColor];
        [bodyView addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, ALERT_SCREEN_WIDTH-2*self.margin, 0.5)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [bodyView addSubview:lineView];
        
        [bodyView addSubview:self.tableView];
        
        _bodyView = bodyView;
    }
    
    return _bodyView;
}

-(void)addTwoBtn
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(self.margin, rect.size.height-self.rowHeight-([self screenInsets].bottom>0?0:self.margin) - [self screenInsets].bottom, rect.size.width-2*self.margin, self.rowHeight)];
    btnView.backgroundColor = [UIColor whiteColor];
    
    btnView.tag = 1000;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (CGRectGetWidth(rect)-2*self.margin-3)/2, self.rowHeight)];
    [cancelBtn setTitle:@"取   消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(touchCancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:self.blueOfSystem forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(rect)-2*self.margin-3)/2 + 3, 0, (CGRectGetWidth(rect)- 2*self.margin-3)/2, self.rowHeight)];
    [okBtn setTitle:@"确   定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(touchOK) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitleColor:self.blueOfSystem forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];

    UILabel *blankLab2 = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(rect)-2*self.margin-3)/2 + 1, self.rowHeight/4, 1, self.rowHeight/2)];
    blankLab2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [btnView addSubview:blankLab2];
    [btnView addSubview:cancelBtn];
    [btnView addSubview:okBtn];
    
    btnView.layer.cornerRadius = 13;
    btnView.clipsToBounds = YES;
    [self addSubview:btnView];
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        
        CGFloat maxHeight = ALERT_SCREEN_HEIGHT *2/3;
        
        CGFloat tableViewHeight = self.rowHeight*dataArr.count;
        
        tableViewHeight = tableViewHeight > maxHeight?maxHeight:tableViewHeight;
        
        CGRect rect = CGRectMake(0, 44, ALERT_SCREEN_WIDTH - 2*self.margin, tableViewHeight);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView setEditing:YES animated:YES];
        _tableView.estimatedRowHeight = self.rowHeight;
        _tableView.rowHeight = UITableViewAutomaticDimension;

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ALERT_SCREEN_WIDTH - 2*self.margin, CGFLOAT_MIN)];
        _tableView.tableFooterView = view;
    }
    
    return _tableView;
}

#pragma-mark Action

- (void)updateFrameOfTableViewAndBodyView{
    
    CGFloat maxHeight = ALERT_SCREEN_HEIGHT *2/3;
    
    CGFloat tableViewHeight = _tableView.contentSize.height;
    
    tableViewHeight = tableViewHeight > maxHeight?maxHeight:tableViewHeight;
    
    CGRect rect = CGRectMake(0, 44, ALERT_SCREEN_WIDTH - 2*self.margin, tableViewHeight);
    
    _tableView.frame = rect;
    
    CGFloat bodyViewHeight = CGRectGetHeight(self.tableView.bounds) + 44;
    
    CGFloat buttonViewHeight = self.rowHeight + ([self screenInsets].bottom>0?0:self.margin) + [self screenInsets].bottom;
    
    
    
    __block CGRect frame = CGRectMake(self.margin, ALERT_SCREEN_HEIGHT - 0 - self.margin - buttonViewHeight, ALERT_SCREEN_WIDTH-2*self.margin, bodyViewHeight);
    _bodyView.frame = frame;
    

    UIView *btnView = [self viewWithTag:1000];
    __block CGRect btn_frame = btnView.frame;
    btn_frame.origin.y += bodyViewHeight;
    btnView.frame = btn_frame;

    [UIView animateWithDuration:0.25 delay:0.01 usingSpringWithDamping:5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        btn_frame.origin.y = [[UIScreen mainScreen] bounds].size.height-self.rowHeight-([self screenInsets].bottom>0?0:self.margin) - [self screenInsets].bottom;
        btnView.frame = btn_frame;
        
        
        frame.origin.y = ALERT_SCREEN_HEIGHT - bodyViewHeight - self.margin - buttonViewHeight;
        self.bodyView.frame = frame;

    } completion:nil];

    
}

- (BOOL)getSelectedStatusOfModel:(LKAlertModel *)model{
    
    BOOL selected = NO;
    
    for (LKAlertModel *selectModel in selectedArr) {
        
        if ([selectModel.value isEqualToString:model.value]) {
            selected = YES;
        }
    }
    
    return selected;
}

-(void)touchCancel{
    
    if (self.LKCancelBlock) {
        self.LKCancelBlock(self);
    }
    
    [self dismiss];
}

-(void)touchOK
{
    if (self.LKSubmitBlock) {
        
        NSMutableArray *selected = [NSMutableArray array];
        NSMutableArray *nameArr = [NSMutableArray array];
        NSMutableArray *idArr = [NSMutableArray array];

        for (LKAlertModel *model in dataArr) {
            
            if (model.selected) {
                [selected addObject:model];
                [nameArr addObject:model.label?:@""];
                [idArr addObject:model.value?:@""];
            }
        }
        
        self.LKSubmitBlock(selected,nameArr,idArr);
    }
    
    [self dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

- (void)dismiss{
    

    CGFloat bodyViewHeight = CGRectGetHeight(self.tableView.bounds) + 44;
    
    CGFloat buttonViewHeight = self.rowHeight + ([self screenInsets].bottom>0?0:self.margin) + [self screenInsets].bottom;
    
    UIView *btnView = [self viewWithTag:1000];
    __block CGRect btn_frame = btnView.frame;
    btn_frame.origin.y += bodyViewHeight;
    btnView.frame = btn_frame;
    
    __block CGRect frame = self.bodyView.frame;
    
    [UIView animateWithDuration:0.25 delay:0.01 usingSpringWithDamping:5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        btn_frame.origin.y += (bodyViewHeight + [self screenInsets].bottom);
        btnView.frame = btn_frame;
        
        frame.origin.y += (bodyViewHeight + self.margin + buttonViewHeight + [self screenInsets].bottom);
        self.bodyView.frame = frame;
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(void)show{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
//    self.alpha  = 0.001;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateFrameOfTableViewAndBodyView];
//        self.alpha  = 1;
//    });
}

#pragma-mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell1"];
        cell.textLabel.font = [UIFont systemFontOfSize:19];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = ALERT_COLOR(39, 123, 246, 1);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectedBackgroundView = [UIView new];
    }
    
    LKAlertModel *model = dataArr[indexPath.row];
    
    cell.textLabel.text = model.label;
    
    if (model.selected) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LKAlertModel *model = dataArr[indexPath.row];
    model.selected = YES;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LKAlertModel *model = dataArr[indexPath.row];
    model.selected = NO;
}



#pragma mark - safeArea
-(UIEdgeInsets)screenInsets {
    if (@available(iOS 11.0, *)) {
        return  [UIApplication sharedApplication].keyWindow.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
    /*
     //竖屏
     additionalSafeAreaInsets.top = 24.0
     additionalSafeAreaInsets.bottom = 34.0
     //竖屏, status bar 隐藏
     additionalSafeAreaInsets.top = 44.0
     additionalSafeAreaInsets.bottom = 34.0
     //横屏
     additionalSafeAreaInsets.left = 44.0
     additionalSafeAreaInsets.bottom = 21.0
     additionalSafeAreaInsets.right = 44.0
     */
}

@end
