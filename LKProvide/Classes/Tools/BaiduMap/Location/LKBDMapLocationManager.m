//
//  LKBDMapLocationManager.m
//  LiemsMobileEnterprise
//
//  Created by wangzheng on 2018/4/20.
//  Copyright © 2018年 Luculent. All rights reserved.
//

#import "LKBDMapLocationManager.h"
@interface LKBDMapLocationManager() <BMKLocationManagerDelegate,BMKGeoCodeSearchDelegate>

@property(nonatomic, strong) BMKLocationManager *locationManager;

@property(nonatomic, strong)BMKGeoCodeSearch *geocodesearch; //编码服务

@property (copy, nonatomic) BMKLocatingCompletionBlock locationAssitBlock;

@property (copy, nonatomic) LKBDMapGeoBlock geoAssitBlock;

@property (copy, nonatomic) LKBDMapReGeoBlock regeoAssitBlock;

@end

@implementation LKBDMapLocationManager

- (instancetype)init{
    
    self = [super init];
    if(self){
        _locationManager = [[BMKLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation; 
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.allowsBackgroundLocationUpdates = YES;
        _locationManager.locationTimeout = 10;
        _locationManager.reGeocodeTimeout = 10;
        
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
        _geocodesearch.delegate = self;
        
    }
    return self;
}

- (void)getCurrentLocationInfoCompletionBlock:(BMKLocatingCompletionBlock)completion{
    
    [self.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:completion];
}

- (void)getSustainCurrentLocationInfoWithDistanceFilter:(CLLocationDistance)distanceConfig
                                        CompletionBlock:(BMKLocatingCompletionBlock)completion{
    
    self.locationAssitBlock = completion;
    self.locationManager.distanceFilter = distanceConfig;
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
    
}

- (void)getLocationPointByAddress:(NSString *)address
                  CompletionBlock:(LKBDMapGeoBlock)completion{
    
    self.geoAssitBlock = completion;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.address = address;
    [self.geocodesearch geoCode:geoCodeSearchOption];
}

- (void)getLocationAddressByLatitude:(NSString *)latitude
                           Longitude:(NSString *)longitude
                     CompletionBlock:(LKBDMapReGeoBlock)completion{
    
    self.regeoAssitBlock = completion;
    
    BMKReverseGeoCodeSearchOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeocodeSearchOption.location = CLLocationCoordinate2DMake([latitude doubleValue],[longitude doubleValue]);
    [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
}

#pragma mark - Location
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error{
    
    !self.locationAssitBlock ? : self.locationAssitBlock(nil,BMKLocationNetworkStateUnknown,error);
    
}


- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error{
    
    !self.locationAssitBlock ? : self.locationAssitBlock(location,BMKLocationNetworkStateUnknown,error);
}


#pragma mark - BMKGeoCodeSearchDelegate
// 编码
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    
    !self.geoAssitBlock ? : self.geoAssitBlock(result,error);
}
// 逆编码
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    !self.regeoAssitBlock ? : self.regeoAssitBlock(result,error);
}


- (void)stopUpdatingLocation{
    [self.locationManager stopUpdatingLocation];
}

- (void)deallocManager{
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
    _geocodesearch = nil;
    _locationAssitBlock = nil;
    _geoAssitBlock = nil;
    _regeoAssitBlock = nil;
}

@end
