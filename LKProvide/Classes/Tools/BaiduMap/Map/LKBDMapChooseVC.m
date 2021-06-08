//
//  LKBDMapChooseVC.m
//  LiemsMobileEnterprise
//
//  Created by wangzheng on 2018/4/25.
//  Copyright © 2018年 Luculent. All rights reserved.
//

#import "LKBDMapChooseVC.h"
#import <Masonry/Masonry.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BMKLocationkit/BMKLocationAuth.h>

#define BMKSafeString(A) A?A:@""

#define BMK_UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]// rgb颜色转换（16进制->10进制）
@implementation LKBDMapChooseModel

@end

@interface LKBDMapChooseVC ()<BMKMapViewDelegate,BMKLocationManagerDelegate,BMKGeoCodeSearchDelegate,UISearchBarDelegate>

@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) BMKMapView *mapView;

@property (nonatomic, assign) LKMapType mapTyp;

@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象

@property (strong, nonatomic) BMKGeoCodeSearch *geoCodeSearch;//编码服务
@property (strong, nonatomic) BMKPointAnnotation* pointAnnotation;//大头钉
@property (strong, nonatomic) LKBDMapChooseModel *resultModel;


@end

@implementation LKBDMapChooseVC

- (instancetype)initWithMapTyp:(LKMapType)mapTyp
                originLocation:(LKBDMapChooseModel *)origin{
    self = [super init];
    if (self) {
        self.mapTyp = mapTyp;
        self.resultModel = [LKBDMapChooseModel new];
        self.resultModel.address = BMKSafeString(origin.address);
        self.resultModel.latitude = BMKSafeString(origin.latitude);
        self.resultModel.longitude = BMKSafeString(origin.longitude);
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.resultModel = [LKBDMapChooseModel new];
        self.mapTyp = LKMapTypeLocationChoose;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.mapTyp == LKMapTypeLocationChoose) {
        self.title = @"位置选择";
        UIBarButtonItem *confirmBar = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:self action:@selector(confirmAction)];
        self.navigationItem.rightBarButtonItem = confirmBar;
    }else{
        self.title = @"位置展示";
        UIBarButtonItem *naviBar = [[UIBarButtonItem alloc] initWithTitle:@"导航" style:(UIBarButtonItemStylePlain) target:self action:@selector(naviAction)];
        self.navigationItem.rightBarButtonItem = naviBar;
    }
    
    self.locationLabel.text = [NSString stringWithFormat:@"%@",SafeString(self.resultModel.address)];
    [self configUI];
    [self.locationManager startUpdatingLocation];
    
    
    if (self.mapTyp == LKMapTypeLocationShow) {
        double latitude = [self.resultModel.latitude doubleValue];
        double longitude = [self.resultModel.longitude doubleValue];
        NSString *address = self.resultModel.address;
        CLLocationCoordinate2D pt=(CLLocationCoordinate2D){latitude,longitude};
        [_mapView setCenterCoordinate:pt animated:YES];
        self.pointAnnotation = [[BMKPointAnnotation alloc]init];
        self.pointAnnotation.title = address;
        self.pointAnnotation.coordinate = pt;
        [_mapView addAnnotation:self.pointAnnotation];
    }
    
}

- (void)configUI{
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.offset(0);
    }];
    
    if (self.mapTyp == LKMapTypeLocationShow) {
        
        [self.headView addSubview:self.locationLabel];
        [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(16);
            make.trailing.mas_offset(-16);
            make.top.mas_offset(10);
            make.bottom.mas_offset(-10);
        }];
        
    }else{
        
        [self.headView addSubview:self.searchBar];
        [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(16);
            make.leading.offset(12);
            make.trailing.offset(-12);
            make.height.offset(36);
        }];
        [self.headView addSubview:self.locationLabel];
        [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(16);
            make.trailing.mas_offset(-16);
            make.top.equalTo(self.searchBar.mas_bottom).mas_offset(10);
            make.bottom.mas_offset(-10);
        }];
    }
}

#pragma mark - Action
- (void)naviAction{

    NSString *lat = self.resultModel.latitude ? : @"";
    NSString *lng = self.resultModel.longitude ? : @"";
    
    
    NSMutableArray *maps = [NSMutableArray array];
    //苹果原生地图-苹果原生地图方法和其他不一样
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%@,%@|name=北京&mode=driving&coord_type=gcj02",lat,lng] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%@&lon=%@&dev=0&style=2",@"导航功能",@"nav123456",lat,lng] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
    
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%@,%@&directionsmode=driving",@"导航测试",@"nav123456",lat,lng] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%@,%@&to=终点&coord_type=1&policy=0",lat,lng] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    //选择
    UIAlertController * alert = [UIAlertController LK_AlertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSInteger index = maps.count;
    
    for (int i = 0; i < index; i++) {
        
        NSString * title = maps[i][@"title"];
        
        //苹果原生地图方法
        if (i == 0) {
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self navAppleMap:lat lng:lng];
            }];
            [alert addAction:action];
            
            continue;
        }
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *urlString = maps[i][@"url"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
                
            }];
        }];
        
        [alert addAction:action];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    [alert addAction:cancelAction];
    
    [[HTHelper getAppCurrentVC] presentViewController:alert animated:YES completion:nil];
}


//苹果地图
- (void)navAppleMap:(NSString *)lat lng:(NSString *)lng{
    //终点坐标
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat.doubleValue, lng.doubleValue);
    
    //用户位置
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    //终点位置
    MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:loc addressDictionary:nil] ];
    
    
    NSArray *items = @[currentLoc,toLocation];
    
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

- (void)confirmAction{
    
    if (self.needLocationImg) {
        
        UIImage *image = [self.mapView takeSnapshot];
        self.resultModel.locationImgData = UIImageJPEGRepresentation(image,0.8);
        !self.chooseBlock ? : self.chooseBlock(self.resultModel);
        [self popOrDismiss];
    }else{
        !self.chooseBlock ? : self.chooseBlock(self.resultModel);
        [self popOrDismiss];
    }
}

#pragma mark - BMKLocationManagerDelegate
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (error) {
        HTLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    self.userLocation.location = location.location;
    [_mapView updateLocationData:self.userLocation];
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
    if (self.mapTyp == LKMapTypeLocationChoose) {
        // 如果是选地址:
        [_mapView setCenterCoordinate:location.location.coordinate animated:YES];
        NSString *country = SafeString(location.rgcData.country);
        NSString *province = SafeString(location.rgcData.province);
        NSString *city = SafeString(location.rgcData.city);
        NSString *district = SafeString(location.rgcData.district);
        NSString *street = SafeString(location.rgcData.street);
        NSString *locationDescribe = SafeString(location.rgcData.locationDescribe);
        NSString *address = [NSString stringWithFormat:@"%@%@%@%@%@%@",country,province,city,district,street,locationDescribe];
        self.resultModel.address = address;
        self.resultModel.latitude = @(location.location.coordinate.latitude).description;
        self.resultModel.longitude = @(location.location.coordinate.longitude).description;
        
        self.locationLabel.text = [NSString stringWithFormat:@"选中地址：%@",address];
        
        // 设置大头针:
        CLLocationCoordinate2D pt = location.location.coordinate;
        [_mapView setCenterCoordinate:pt animated:YES];
        self.pointAnnotation = [[BMKPointAnnotation alloc]init];
        self.pointAnnotation.title = address;
        self.pointAnnotation.coordinate = pt;
        [_mapView addAnnotation:self.pointAnnotation];
        
    }
}


#pragma mark - BMKMapViewDelegate
/**
 *点中底图空白处会回调此接口
 *@param mapView 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    
    if (self.mapTyp == LKMapTypeLocationShow){
        return;
    }
    
    CLLocationCoordinate2D pt = coordinate;
    self.pointAnnotation.coordinate = pt;
    [_mapView setCenterCoordinate:pt animated:YES];
    // 点击成功获取经纬度,发送反编码请求
    [self loadLocation:pt];
}

//poi点击
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi{
    
    self.pointAnnotation.coordinate = mapPoi.pt;
    _mapView.centerCoordinate = mapPoi.pt;
    //点击成功获取经纬度,发送反编码请求
    [self loadLocation:mapPoi.pt];
}


-(void)loadLocation:(CLLocationCoordinate2D)pt{
    //发送反编码请求
    BMKReverseGeoCodeSearchOption *reverseGeoCodeOption = [[BMKReverseGeoCodeSearchOption alloc] init];
    reverseGeoCodeOption.location = pt;
    reverseGeoCodeOption.isLatestAdmin = YES;
    [self searchData:reverseGeoCodeOption];
}

- (void)searchData:(BMKReverseGeoCodeSearchOption *)option{
    //初始化请求参数类BMKReverseGeoCodeOption的实例
    BMKReverseGeoCodeSearchOption *reverseGeoCodeOption = [[BMKReverseGeoCodeSearchOption alloc] init];
    // 待解析的经纬度坐标（必选）
    reverseGeoCodeOption.location = option.location;
    //是否访问最新版行政区划数据（仅对中国数据生效）
    reverseGeoCodeOption.isLatestAdmin = option.isLatestAdmin;
    /**
     根据地理坐标获取地址信息：异步方法，返回结果在BMKGeoCodeSearchDelegate的
     onGetAddrResult里
     reverseGeoCodeOption 反geo检索信息类
     成功返回YES，否则返回NO
     */
    BOOL flag = [self.geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    
#ifdef DEBUG
    if (flag) {
        NSLog(@"反地理编码检索成功");
    } else {
        NSLog(@"反地理编码检索失败");
    }
#endif
    
}

#pragma mark - BMKGeoCodeSearchDelegate
// 反向地理编码检索结果回调
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    
    BMKPoiInfo *POIInfo = result.poiList[0];
    BMKSearchRGCRegionInfo *regionInfo = [[BMKSearchRGCRegionInfo alloc] init];
    if (result.poiRegions.count > 0) {
        regionInfo = result.poiRegions[0];
    }
    
    
    self.resultModel.address = result.address;
    self.resultModel.latitude = [NSString stringWithFormat:@"%f",result.location.latitude];
    self.resultModel.longitude = [NSString stringWithFormat:@"%f",result.location.longitude];
    self.locationLabel.text = [NSString stringWithFormat:@"选中地址：%@",result.address];
    
    _mapView.centerCoordinate = result.location;
    
    [_mapView removeAnnotation:self.pointAnnotation];
    self.pointAnnotation.title = result.address;
    self.pointAnnotation.coordinate = result.location;
    [_mapView addAnnotation:self.pointAnnotation];
    
}


#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    [_mapView removeAnnotation:self.pointAnnotation];
    if (error == BMK_SEARCH_NO_ERROR){
        // 发送反编码请求获取到编码后的位置信息
        [self loadLocation:result.location];
    }
}



#pragma mark - Search Delegate
// 点击搜索栏时:
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    UIView *targetView = [HTHelper findViewWithClassName:@"UINavigationButton" inView:searchBar];
    if(targetView){
        UIButton * cancel =(UIButton *)targetView;
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:HT_MAIN_Theme_COLOR forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    return YES;
}

// 点击搜索栏旁边的取消按钮时:
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    //根据地址信息转换成经纬度:发送geo检索
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= @"";
    geoCodeSearchOption.address = searchBar.text;
    [self.geoCodeSearch geoCode:geoCodeSearchOption];
    
}

- (void)dealloc{
    _mapView.delegate = nil;
    _locationManager.delegate = nil;
    _geoCodeSearch.delegate = nil;
    _mapView = nil;
    _locationManager = nil;
    _geoCodeSearch = nil;
}


#pragma mark - Lazy loading
- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        //初始化BMKLocationManager类的实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置定位管理类实例的代理
        _locationManager.delegate = self;
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设定定位精度，默认为 kCLLocationAccuracyBest
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //指定定位是否会被系统自动暂停，默认为NO
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        _locationManager.allowsBackgroundLocationUpdates = NO;
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        _locationManager.locationTimeout = 10;
    }
    return _locationManager;
}

- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}

- (BMKGeoCodeSearch *)geoCodeSearch{
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
    }
    return _geoCodeSearch;
}

- (BMKPointAnnotation *)pointAnnotation{
    if(!_pointAnnotation){
        _pointAnnotation = [[BMKPointAnnotation alloc]init];
    }
    return _pointAnnotation;
}

- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [BMKMapView new];
        _mapView.delegate = self;
        [_mapView setMapType:BMKMapTypeStandard];
        _mapView.showsUserLocation = YES;
        _mapView.zoomLevel=17;
        BMKLocationViewDisplayParam *_param = [BMKLocationViewDisplayParam new];
        _param.isAccuracyCircleShow = NO;
        [_mapView updateLocationViewWithParam:_param];
    }
    return _mapView;
}

- (UIView *)headView{
    
    if (!_headView) {
        _headView = [UIView new];
        _headView.backgroundColor = [BMK_UIColorFromRGB(0xFFFFFF) colorWithAlphaComponent:1];
        UIView *line = [UIView new];
        line.backgroundColor = BMK_UIColorFromRGB(0xF5F5F5);
        [_headView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.offset(0);
            make.bottom.offset(0);
            make.height.offset(1);
        }];
    }
    return _headView;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        
        _searchBar = [UISearchBar new];
        _searchBar.tintColor = HT_MAIN_Theme_COLOR;
        _searchBar.barTintColor = BMK_UIColorFromRGB(0xFFFFFF);
        _searchBar.layer.borderWidth = 0.5f;
        _searchBar.layer.borderColor = BMK_UIColorFromRGB(0xFFFFFF).CGColor;
        _searchBar.backgroundColor = BMK_UIColorFromRGB(0xFFFFFF);
        _searchBar.placeholder = @"查找地点";
        _searchBar.delegate = self;
        
        UIView *targetView = [self findViewWithClassName:@"UISearchBarTextField" inView:self.searchBar];
        if(targetView){
            
            UITextField *textField = (UITextField *)targetView;
            textField.backgroundColor = BMK_UIColorFromRGB(0xF5F5F5);
            textField.layer.cornerRadius = 2.0f;
        }
        
    }
    return _searchBar;
    
}

- (UILabel *)locationLabel{
    
    if (!_locationLabel) {
        _locationLabel = [UILabel new];
        _locationLabel.numberOfLines = 0;
        _locationLabel.textColor = BMK_UIColorFromRGB(0x333333);
        _locationLabel.font = [UIFont systemFontOfSize: (14)];
    }
    return _locationLabel;
}
    

    - (UIView *)findViewWithClassName:(NSString *)className inView:(UIView *)view{
        Class specificView = NSClassFromString(className);
        if ([view isKindOfClass:specificView]) {
            return view;
        }
        
        if (view.subviews.count > 0) {
            for (UIView *subView in view.subviews) {
                UIView *targetView = [self findViewWithClassName:className inView:subView];
                if (targetView != nil) {
                    return targetView;
                }
            }
        }
        return nil;
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
