//
//  LKBDMapChooseVC.h
//  LiemsMobileEnterprise
//
//  Created by wangzheng on 2018/4/25.
//  Copyright © 2018年 Luculent. All rights reserved.
//
/*
⚠️⚠️⚠️
 常用的4个地图的 URL Scheme:
 1.苹果自带地图（不需要检测，所以不需要URL Scheme）
 2.百度地图 ：baidumap://
 3.高德地图 ：iosamap://
 4.谷歌地图 ：comgooglemaps://
 5.腾讯地图 ：qqmap://
⚠️⚠️⚠️
 */


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LKMapType){
    LKMapTypeLocationChoose = 0,
    LKMapTypeLocationShow
    
};


@interface LKBDMapChooseModel : NSObject

@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,strong) NSData *locationImgData;

@end

typedef void(^LKBDMapChooseBlock)(LKBDMapChooseModel *model);


@interface LKBDMapChooseVC : UIViewController

@property (nonatomic, assign, readonly) LKMapType mapTyp;
@property (nonatomic, assign) BOOL needLocationImg;

- (instancetype)initWithMapTyp:(LKMapType)mapTyp
                originLocation:(LKBDMapChooseModel *)origin;

@property (copy, nonatomic) LKBDMapChooseBlock chooseBlock;

@end
