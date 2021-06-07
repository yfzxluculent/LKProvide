//
//  LKBDMapLocationManager.h
//  LiemsMobileEnterprise
//
//  Created by wangzheng on 2018/4/20.
//  Copyright © 2018年 Luculent. All rights reserved.
//

/// 注意该类在使用的时候, 需设置成属性被持有 (不然定位权限弹框会自动消失), 注意 deallocManager 配套使用

#import <Foundation/Foundation.h>
@interface LKBDMapLocationManager : NSObject

// 地理编码 Block
typedef void(^LKBDMapGeoBlock)(BMKGeoCodeSearchResult *result, BMKSearchErrorCode error);

// 逆地理编码 Block
typedef void(^LKBDMapReGeoBlock)(BMKReverseGeoCodeSearchResult *result, BMKSearchErrorCode error);


- (void)deallocManager;

/**
 获取当前位置信息 (单次定位)
 
 @param completion completion
 */

- (void)getCurrentLocationInfoCompletionBlock:(BMKLocatingCompletionBlock)completion;

/**
 获取当前位置信息 (持续定位 会 cancel 掉所有的单次定位 , 需要主动停止定位)
 @param distanceConfig 多长距离更新
 @param completion completion
 */
- (void)getSustainCurrentLocationInfoWithDistanceFilter:(CLLocationDistance)distanceConfig
                                        CompletionBlock:(BMKLocatingCompletionBlock)completion;



/**
 输入地址的经纬度信息
 
 @param address 地址
 @param completion completion
 */

- (void)getLocationPointByAddress:(NSString *)address
                  CompletionBlock:(LKBDMapGeoBlock)completion;


/**
 根据经纬度获取地址信息
 
 @param latitude 纬度
 @param longitude 经度
 @param completion completion
 */
- (void)getLocationAddressByLatitude:(NSString *)latitude
                           Longitude:(NSString *)longitude
                     CompletionBlock:(LKBDMapReGeoBlock)completion;

/**
 停止定位
 */
- (void)stopUpdatingLocation;

@end
