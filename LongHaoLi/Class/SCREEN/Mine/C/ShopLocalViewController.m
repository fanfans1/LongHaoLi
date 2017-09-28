//
//  ShopLocalViewController.m
//  Foods
//
//  Created by yy on 2016/12/5.
//  Copyright © 2016年 fanfan. All rights reserved.
//

#import "ShopLocalViewController.h"
#import "CityViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "ReGeocodeAnnotation.h"

@interface ShopLocalViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *tips;
@property (nonatomic, retain)UITextField *textFile;
@property (nonatomic, strong)MAMapView *mapView;
@property (nonatomic, retain)MAPointAnnotation *pointAnnotation;
@property (nonatomic, retain)AMapSearchAPI *search;
@property (nonatomic, strong) ReGeocodeAnnotation *annotation;
@property (nonatomic, retain)MAUserLocation *userLogin;
@property (nonatomic, retain)UITableView *tableView;


@end

@implementation ShopLocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tips = [NSMutableArray array];
    self.view.backgroundColor = COLOUR(240, 240, 240);
    //    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setViewControll];
    
    [self setMap];
    
    UITableView *table = [[UITableView alloc] initWithFrame:RECTMACK(0,(94 + 64*414/SCREEN_WIDTH) , 414, (SCREEN_HEIGHT -64 - 94*SCREEN_WIDTH/414)*414/SCREEN_WIDTH)];
    table.dataSource = self;
    table.delegate = self;
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    table.hidden = YES;
    [self.view addSubview: table];
    self.tableView = table;
    // Do any additional setup after loading the view.
}

- (void)setViewControll{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taps)];
    UIView *first = [self setHeig:64*414/SCREEN_WIDTH type:@"所在地区"];
    [first addGestureRecognizer: tap];
    self.local = [[UILabel alloc ] initWithFrame:RECTMACK(100, 0, 200, 45)];
    //    self.local.font = FONT(16);
    [first addSubview: self.local];
    UILabel *select = [[UILabel alloc] initWithFrame:RECTMACK(335, 0, 80, 45)];
    
    select.text = @"请选择 >";
    select.font = FONT(14);
    select.textColor = COLOUR(192, 192, 192);
    [first addSubview: select];
    
    UIView *second = [self setHeig:(45 + 64*414/SCREEN_WIDTH) type:@"详细地址"];
    self.textFile = [[UITextField alloc] initWithFrame:RECTMACK(100, 0, 300, 45)];
    _textFile.placeholder = @"如XX路XX号，与地图匹配";
    self.textFile.delegate =self;
    self.textFile.font = FONT(13);
    
    self.textFile.returnKeyType = UIReturnKeySearch;
    [second addSubview: _textFile];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = RECTMACK(335, 10, 50, 30);
    [btn setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Search) forControlEvents:UIControlEventTouchUpInside];
    [second addSubview: btn];
    
    
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    save.frame = RECTMACK(0, SCREEN_HEIGHT - 90, 414, 90);
    [save setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    //       [save setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateSelected];
    save.adjustsImageWhenHighlighted = NO;
    [save addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: save];
}




- (void)setMap{
    _mapView = [[MAMapView alloc] initWithFrame:RECTMACK(0, (94 + 64*414/SCREEN_WIDTH) , 414, (SCREEN_HEIGHT -64 - 94*SCREEN_WIDTH/414 - 90*SCREEN_WIDTH/414)*414/SCREEN_WIDTH)];
    // 设置地图类型(标准)
    [_mapView setMapType: MAMapTypeStandard];
    // 地图logo控件
    _mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-55, 450);
    
    //指南针
    _mapView.showsCompass= YES; // 设置成NO表示关闭指南针；YES表示显示指南针
    _mapView.delegate = self;
    _mapView.zoomEnabled = YES;    //NO表示禁用缩放手势，YES表示开启
    // 缩放范围 3 - 19
    [_mapView setZoomLevel:17 animated:YES];
    _mapView.showsUserLocation = YES;
    
    _mapView.scrollEnabled = YES;    //NO表示禁用滑动手势，YES表示开启
    _pointAnnotation = [[MAPointAnnotation alloc] init];
    
    [_mapView addAnnotation:_pointAnnotation];
    [self.view addSubview: _mapView];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
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
        _mapView.showsUserLocation = YES;
        self.userLogin = userLocation;
        [_mapView setCenterCoordinate:userLocation.coordinate  animated:YES];
        //发起逆地理编码
        [self searchReGeocodeWithCoordinate:userLocation.coordinate];
    }
}



- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    self.lo = regeo.location.longitude;
    self.la = regeo.location.latitude;
    
    //    NSLog(@"%f  %f",self.la,self.lo);
    [self.search AMapReGoecodeSearch:regeo];
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        NSString *title = [NSString stringWithFormat:@"%@%@%@%@",
                           response.regeocode.addressComponent.province?: @"",
                           response.regeocode.addressComponent.city ?: @"",
                           response.regeocode.addressComponent.district?: @"",
                           response.regeocode.addressComponent.township?: @""];
        
        _pointAnnotation.title = title;
        
        _pointAnnotation.subtitle = response.regeocode.formattedAddress;
        
        self.local.text = response.regeocode.addressComponent.city;
        self.textFile.text = _pointAnnotation.subtitle;
        
        if (self.userLogin.title.length > 5) {
            
        }else{
            self.userLogin.title = title;
        }
    }
    else
    {
        [self.annotation setAMapReGeocode:response.regeocode];
        [self.mapView selectAnnotation:self.annotation animated:YES];
    }
}


- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    _pointAnnotation.coordinate = mapView.region.center;
    [self searchReGeocodeWithCoordinate:mapView.region.center];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}



//   实现 <MAMapViewDelegate> 协议中的 mapView:viewForAnnotation:回调函数，设置标注样式。 如下所示：
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}


- (void)save{
    if (self.textFile.text.length < 5) {
        ALERT(@"暂时未获取您当前位置，请重新定位");
        
        return;
    }
    [self.delegate passValue:self.la lo:self.lo city:self.local.text det:self.textFile.text];
    [self.navigationController popViewControllerAnimated:YES];
    //    NSLog(@"保存");
}



- (void)taps{
    CityViewController *controller = [[CityViewController alloc] init];
    if (_local.text.length > 0) {
        controller.currentCityString = _local.text;
    }else{
        
        controller.currentCityString = @"正在定位";
    }
    controller.selectString = ^(NSString *string){
        self.local.text = string;
    };
    [self presentViewController:controller animated:YES completion:nil];
    //    NSLog(@"哈哈哈哈");
    
}

- (UIView *)setHeig:(float)hei type:(NSString *)types{
    UIView *view = [[UIView alloc] initWithFrame:RECTMACK(0, hei, 414, 44)];
    UILabel *type = [[UILabel alloc] initWithFrame:RECTMACK(15, 14, 75, 16)];
    type.font = FONT(15);
    view.backgroundColor = [UIColor whiteColor];
    type.textColor = COLOUR(131, 131, 131);
    type.text = types;
    [view addSubview: type];
    
    [self.view addSubview: view];
    return view;
    
}


//// ## 搜索
- (void)Search{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = _textFile.text;
    [_textFile resignFirstResponder];
    request.city = _local.text;
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    [self.search AMapPOIKeywordsSearch:request];
    [self.tips removeAllObjects];
    //    NSLog(@"搜索");
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    //    NSLog(@"%@",response);
    if (response.pois.count == 0)
    {
        return;
    }
    for (AMapTip *p in response.pois) {
        
        [self.tips addObject:p];
    }
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    //解析response获取POI信息，具体解析见 Demo
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self Search];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AMapTip *p = self.tips[indexPath.row];
    self.lo = p.location.longitude;
    self.la = p.location.latitude;
    CLLocationCoordinate2D cll =  CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
    [_mapView setCenterCoordinate:cll animated:NO];
    [self searchReGeocodeWithCoordinate:cll];
    self.tableView.hidden = YES;
    //    NSLog(@"%f",p.location.latitude);
    //    NSLog(@"%f",p.location.longitude);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    AMapTip *p = self.tips[indexPath.row];
    cell.textLabel.text = p.name;
    cell.detailTextLabel.text = p.address;
    return cell;
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
