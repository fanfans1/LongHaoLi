//
//  NearViewController.m
//  Longhaoli
//
//  Created by Guang shen on 2017/8/7.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import "NearViewController.h"
#import "RollShopInfoModel.h"


@interface NearViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, retain)NSMutableArray *marr;
@property (nonatomic, retain)MAUserLocation *userLogin;
//@property (nonatomic
@end

@implementation NearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.marr = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    [self.navigationController.navigationBar setBarTintColor: BACKGROUNDCOLOR];
}


- (void)viewWillAppear:(BOOL)animated{
        [self setMap];
        _mapView.showsCompass= YES; // 设置成NO表示关闭指南针；YES表示显示指南针
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
    if (self.marr.count == 0) {
        [self getMassage];
    }else{
       [_mapView addAnnotations:self.annotations];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_mapView) {
        _mapView.showsCompass= NO; // 设置成NO表示关闭指南针；YES表示显示指南针
        _mapView.delegate = nil;
        _mapView.showsUserLocation = NO;
        [_mapView removeFromSuperview];
    }
    
    [super viewWillDisappear:animated];
}


- (void)getMassage{
    
    [MJPush postWithURLString:NEARSHOP parameters:nil success:^(id sucess) {
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
            [self.mapView removeAnnotations:self.annotations];
            [self.annotations removeAllObjects];
            NSArray *arr = [NSArray arrayWithArray:[sucess objectForKey:@"data"] ];
            for (NSDictionary *dic in arr) {
                RollShopInfoModel *model = [RollShopInfoModel setModelWithDictionary:dic];
                [self.marr addObject: model];
            }
             [self initAnnotations];
            [_mapView addAnnotations:self.annotations];
        }else if ([[sucess objectForKey:@"code"] isEqualToString:@"001"]){
            ALERT([sucess objectForKey:@"message"]);
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)setMap{
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    

    [_mapView setMapType: MAMapTypeStandard];
    // 地图logo控件
    _mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-55, SCREEN_HEIGHT - 100);

    _mapView.zoomEnabled = YES;    //NO表示禁用缩放手势，YES表示开启
    // 缩放范围 3 - 19
    [_mapView setZoomLevel:17 animated:YES];
    
    _mapView.scrollEnabled = YES;
    [self.view addSubview:_mapView];
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    // 防止持续定位
    if (self.userLogin == userLocation) {
        return ;
    }

    if(updatingLocation)
    {
        //    地图平移时，缩放级别不变，可通过改变地图的中心点来移动地图
        [_mapView setCenterCoordinate:userLocation.coordinate  animated:YES];
        //发起逆地理编码
        self.userLogin = userLocation;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{

}

#pragma mark - Initialization
- (void)initAnnotations
{
    self.annotations = [NSMutableArray array];
    
    CLLocationCoordinate2D coordinates[self.marr.count];
    for (int i = 0; i < self.marr.count; i++) {
        RollShopInfoModel *model = self.marr[i];
        coordinates[i].latitude = [model.latitudeX floatValue];
        coordinates[i].longitude = [model.latitudeY floatValue];
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        a1.coordinate = coordinates[i];
        a1.title      = model.name;
        a1.subtitle   = model.address;
        [self.annotations addObject:a1];
    }


}





- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
   

//    NSLog(@"%@",view);
}


- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    for (int i = 0; i <self.annotations.count; i++) {
        MAPointAnnotation *a1 = self.annotations[i];
        
        if (view.annotation.coordinate.latitude == a1.coordinate.latitude && view.annotation.coordinate.longitude == a1.coordinate.longitude ) {
            RollShopInfoModel *shop = self.marr[i];
            HomeTiceketDetialViewController *detial = [[HomeTiceketDetialViewController alloc] init];
            detial.rollId = [NSString stringWithFormat:@"%@",shop.rollId];
          
            detial.type = [NSString stringWithFormat:@"%@", shop.modelType];
  
      
//            NSLog(@"%d",i);
            [self.navigationController pushViewController:detial animated:YES];
            return;
        }
        
    }
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = YES;
//        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.pinColor                     = MAPinAnnotationColorRed;
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        rightButton.backgroundColor = [UIColor grayColor];
        rightButton.frame = CGRectMake(0, 0, 80, 50);
        [rightButton setTitle:@"查看详情" forState:UIControlStateNormal];
        annotationView.rightCalloutAccessoryView = rightButton;
        return annotationView;
    }

    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
