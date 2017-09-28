//
//  HomeViewController.m
//  Longhaoli
//
//  Created by 亿缘 on 2017/7/8.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeSearchViewController.h" // 搜素
#import "CityTableViewController.h"  // 城市选择
#import "AutoPlay.h"    // 轮播图
#import "ConTableViewCell.h"    // 滚动小喇叭
#import "HomeHotTableViewCell.h" // 龙好礼
#import "HomeTypeTableViewCell.h" // 类型
#import "HomeFoodLifePlayViewController.h" // 三个模块列表
#import "HomeTempleTableViewController.h"   // 善行天下
#import "HomeLuckGiftViewController.h"  // 抽奖
#import "HomeFriendPresenterViewController.h"  // 好友赠送
 


 

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource,CityTableViewControllerDelegate,AutoPlayDelegate,HomeHotTableViewCellDelegate,HomeTypeTableViewCellDelegate,ConTableViewCellDelegate>{
    AutoPlay *autos;
}



@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)UIButton *cityBtn;


@property (nonatomic, retain)NSMutableArray *adDataMarr; // 轮播图
@property (nonatomic, retain)NSMutableArray *headLineDataMarr; // 头条
@property (nonatomic, assign)int page;  //页数

@property (nonatomic, retain)NSMutableArray *rollApps; // 彩泥喜欢
@property (nonatomic, retain)UIImageView *images;

@end


/**
 
 */
@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _headLineDataMarr = [NSMutableArray array];
    self.adDataMarr = [NSMutableArray array];
    _rollApps = [NSMutableArray array];
    self.page = 1;
    [self setTableView];
    [self getMassage];
    [self setNav];
    addObserver(@selector(isWhiteUser), @"whiteUserAlert");
     NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"login"] isEqualToString:@"1"]){
        [self isWhiteUser];
    }
    //    192.168.0.46
 
}


- (void)dealloc{
    removeObserver();
}


- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSLog(@"%@",[user objectForKey:@"city"]);
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tabBarController.tabBar.hidden = NO;
    if (autos) {
        [autos stop];
        [autos play];
    }
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (![user objectForKey:@"city"]) {
        CityTableViewController *city = [[CityTableViewController alloc] init];
        city.delegate = self;
        if (autos) {
            [autos stop];
        }
        [self.navigationController pushViewController:city animated:NO];
    }
}

- (void)getMassage{
    NSUserDefaults *use = [NSUserDefaults standardUserDefaults];
    NSDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setValue:[use objectForKey:@"city"] forKey:@"address"];
    [mdic setValue:[use objectForKey:@"id"] forKey:@"userId"];
    [mdic setValue:[NSString stringWithFormat:@"%f",APPDELEGATE.latitude] forKey:@"latitudeX"];
    [mdic setValue:[NSString stringWithFormat:@"%f",APPDELEGATE.longitude] forKey:@"latitudeY"];
    [mdic setValue:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
    
    [MJPush postWithURLString:LIKR parameters:mdic success:^(id sucess) {
     
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
     
            
            // 判断轮播
            NSArray *arr = [NSArray arrayWithArray:[[sucess objectForKey:@"data"] objectForKey:@"adData"]];
            if (arr.count>0) {
                if (![self.adDataMarr isEqualToArray:arr] ) {
                    self.adDataMarr = [NSMutableArray arrayWithArray:arr];
                    [self setScroll];
                }
            }
            // 判断头条
            NSArray *headArr = [NSArray arrayWithArray:[[sucess objectForKey:@"data"] objectForKey:@"headLineData"]];
            if (headArr.count > 0) {
                self.headLineDataMarr = [NSMutableArray arrayWithArray:headArr];
            }
            
            NSArray *rollArr = [NSArray arrayWithArray:[[sucess objectForKey:@"data"] objectForKey:@"rollApps"]];
            if (rollArr.count > 0) {
                for (NSDictionary *dic in rollArr) {
                    TicketModel *model = [TicketModel setModelWithDictionary:dic];
                    [self.rollApps addObject: model];
                }
            }
            
            [self.tableView reloadData];
            
            
        }else if ([[sucess objectForKey:@"code"] isEqualToString:@"001"]){
            ALERT([sucess objectForKey:@"message"]);
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if (autos) {
        [autos stop];
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    
}

- (void)isWhiteUser{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    
    [mdic setObject:[user objectForKey:@"id"] forKey:@"userId"];

    [MJPush postWithURLString:SENDROLL parameters:mdic success:^(id sucess) {
        if ([sucess[@"code"] isEqualToString:@"000"]) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            image.image = [UIImage imageNamed:@"home_white_user.png"];
            [APPDELEGATE.window.rootViewController.view addSubview: image];
            image.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remooveWhite)];
            [image addGestureRecognizer: tap];
            self.images = image;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = RECTMACK(120, 400, 180, 30);
            [btn addTarget:self action:@selector(tabBarControllergift) forControlEvents:UIControlEventTouchUpInside];
            
            [self.images addSubview: btn];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)tabBarControllergift{
    [_images removeFromSuperview];
    self.tabBarController.selectedIndex=3;
    postNotification(@"tabBarControllergift");
}

- (void)remooveWhite{
    [self.images removeFromSuperview];
}


// 设置导航控制器
-(void)setNav{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    backView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:backView];
    //城市
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(0, 20, 60, 44);
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [cityBtn setTitle:[user objectForKey:@"city"] forState:UIControlStateNormal];
    [cityBtn addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cityBtn];
    self.cityBtn = cityBtn;
    
    //搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(60,27,SCREEN_WIDTH - 110, 30)];
    searchView.backgroundColor = COLOUR(255 , 255  , 255);
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 14;
    [backView addSubview:searchView];
    // 添加搜索手势
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(search)];
    [searchView addGestureRecognizer: taps];
    //
    
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250, 30)];
    //    placeHolderLabel.font = [UIFont boldSystemFontOfSize:13];
    placeHolderLabel.text = @"🔍请输入您要搜素内容";
    placeHolderLabel.font = FONT(15);
    placeHolderLabel.textColor = COLOUR(199, 199, 205);
    [searchView addSubview:placeHolderLabel];
    
    
    // 礼品
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = CGRectMake(SCREEN_WIDTH - 35, 29.5, 25, 25);
//    [mapBtn setTitle:@"礼品"  forState:UIControlStateNormal];
    [mapBtn setImage:[UIImage imageNamed:@"home_gift.png"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(OnMapBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:mapBtn];
    
}



- (void)location{
    CityTableViewController *city = [[CityTableViewController alloc] init];
    city.delegate = self;
    [self.navigationController pushViewController:city animated:YES];
    
    
}

- (void)passValueWithDic:(NSDictionary *)dic{
    
    [self.cityBtn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
    [self getMassage];
    
}




- (void)setScroll{
    if (self.adDataMarr.count < 1) {
        return;
    }
    if (autos) {
        [autos removeFromSuperview];
    }
    autos = [[AutoPlay alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 177) ImageArray:self.adDataMarr AutoPaly:YES placeholdrImageName:@"loadingimg.png"];
    self.tableView.tableHeaderView = autos;
    autos.delegate = self;
    
}



- (void)setTableView{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT+20 ) style:UITableViewStyleGrouped];
    
    table.delegate = self;
    table.dataSource = self;
    self.tableView = table;
//    [self.tableView registerNib:[UINib nibWithNibName:@"HomeHotTableViewCell" bundle:nil] forCellReuseIdentifier:@"hot"];
    //    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"type"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeHotCommodityTableViewCell" bundle:nil] forCellReuseIdentifier:@"like"];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: table];
    table.showsVerticalScrollIndicator = NO;
    // Do any additional setup after loading the view.
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    // Do any additional setup after loading the view.
   
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 1;
    }else{
        return self.rollApps.count + 1;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        
        static NSString *cellIndentifier = @"xiaolaba";
        ConTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[ConTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.delegate = self;
        }
        if (self.headLineDataMarr.count > 0) {
            
            [cell setArr:self.headLineDataMarr];
        }
        //        [cell setNameLable:@"海底捞入驻"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        static NSString *cellIndentifier = @"hot";
        HomeHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeHotTableViewCell" owner:self options:nil]lastObject];
            [self setCellViewFrame:RECTMACK(0, 84, 138, 18) text:@"美食" imageFrame:RECTMACK(40, 20, 58, 58) name:@"home_food.png" addView:cell];
            [self setCellViewFrame:RECTMACK(138, 84, 138, 18) text:@"生活" imageFrame:RECTMACK(178, 20, 58, 58) name:@"home_life.png" addView:cell];
            [self setCellViewFrame:RECTMACK(276, 84, 138, 18) text:@"娱乐" imageFrame:RECTMACK(316, 20, 58, 58) name:@"home_play.png" addView:cell];
            cell.delegate = self;
        }
        return cell;
    }else if (indexPath.section == 2){
        static NSString *cellIndentifier = @"type";
        HomeTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeTypeTableViewCell" owner:self options:nil]lastObject];
            cell.delegate = self;
            [self setCellViewTitleFrame:RECTMACK(0, 35, 172, 19) text:@"龙好礼" textalian:NSTextAlignmentCenter subFrame:RECTMACK(0, 65, 172, 15) text1:@"百万豪礼相送" font:15 subAlian:NSTextAlignmentCenter imageFrame:RECTMACK(38, 111, 96, 81) name:@"home_dragon.png" addView:cell];
            [self setCellViewTitleFrame:RECTMACK(180, 17, 110, 18) text:@"好友赠送" textalian:NSTextAlignmentLeft subFrame:RECTMACK(180, 40, 110, 14) text1:@"来自好友的福利" font:13 subAlian:NSTextAlignmentLeft imageFrame:RECTMACK(312, 8, 68, 60) name:@"home_friend.png" addView:cell];
            [self setCellViewTitleFrame:RECTMACK(180, 99, 99, 18) text:@"善行天下" textalian:NSTextAlignmentLeft subFrame:RECTMACK(180, 120, 99, 14) text1:@"轻松理财走天下" font:13 subAlian:NSTextAlignmentLeft imageFrame:RECTMACK(174, 164, 112, 43) name:@"home_temple.png" addView:cell];
            [self setCellViewTitleFrame:RECTMACK(286, 99, 128, 18) text:@"时尚购" textalian:NSTextAlignmentCenter subFrame:RECTMACK(286, 120, 128, 14) text1:@"引领时尚潮流" font:15 subAlian:NSTextAlignmentCenter imageFrame:RECTMACK(326, 142, 67, 56) name:@"home_shopping.png" addView:cell];
        }
        return cell;
        
    }else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                [self setCellViewFrameaddView:cell];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            HomeHotCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"like"];
            cell.headImage.layer.masksToBounds = YES;
            cell.headImage.layer.cornerRadius = 5;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            TicketModel *model = self.rollApps[indexPath.row - 1];
            cell.headImage.layer.masksToBounds = YES;
            cell.headImage.layer.cornerRadius = 5;
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[MyBase64 stringConpanSteing:model.photo ]]] placeholderImage:[UIImage imageNamed:@"loadingimg"] options:SDWebImageAllowInvalidSSLCertificates];
            cell.name.text = model.name;
            cell.num.text = [NSString stringWithFormat:@"剩余%d份",model.surplusCount];
            [self changeStringColor:cell.num.text lable:cell.num changeString:[NSString stringWithFormat:@"%d",model.surplusCount] forColor:[UIColor redColor] andFont:16];
            cell.address.text = model.addressShop;
            cell.price.text = [NSString stringWithFormat:@"%.2f元",model.salePrice];
            cell.shopprice.text = [NSString stringWithFormat:@"门市价%.2f",model.originalPrice];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            return cell;
        }
        
    }
    
    
}


- (void)changeStringColor:(NSString *)allString lable:(UILabel *)hintLabel changeString:(NSString *)str forColor:(UIColor *)color andFont:(float)font{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:allString];
    NSRange range1=[[hintString string]rangeOfString:str];
    [hintString addAttribute:NSForegroundColorAttributeName value:color range:range1];
    UIFont *f = FONT(font);
    [hintString addAttribute:NSFontAttributeName value:f range:range1];
    hintLabel.attributedText=hintString;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 46*SCREEN_WIDTH/414;
    }else if (indexPath.section == 1){
        return 116*SCREEN_WIDTH/414;
    }else if (indexPath.section == 2){
        return 207*SCREEN_WIDTH/414;
    }else{
        if (indexPath.row == 0) {
            return 56*SCREEN_WIDTH/414;
        }else {
            return 130*SCREEN_WIDTH/414;
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:RECTMACK(0, 0, 414, 8)];
    view.backgroundColor = COLOUR(243, 243, 243);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section < 3) {
        return 8*SCREEN_WIDTH/414;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        if (indexPath.row > 0) {
            TicketModel *model = self.rollApps[indexPath.row - 1];
            HomeTiceketDetialViewController *detial = [[HomeTiceketDetialViewController alloc] init];
            detial.type = [NSString stringWithFormat:@"%d", model.modelType];
            detial.rollId =[NSString stringWithFormat:@"%@",model.rollId];
            [self.navigationController pushViewController:detial animated:YES];
        }
    }
}

// 龙好礼，好友赠送试图设置
- (void)setCellViewTitleFrame:(CGRect)rect text:(NSString *)str textalian:(NSTextAlignment)alian subFrame:(CGRect)rect1 text1:(NSString *)str1 font:(float )font subAlian:(NSTextAlignment)subAlian imageFrame:(CGRect)imagef name:(NSString *)name addView:(UIView *)cell{
    UILabel *tit = [[UILabel alloc] initWithFrame:rect];
    tit.text = str;
    tit.textColor = COLOUR(47, 47, 47);
    tit.textAlignment = alian;
    tit.font = FONT(18);
    UILabel *sub = [[UILabel alloc] initWithFrame:rect1];
    sub.text = str1;
    sub.font = FONT(font);
    sub.textColor = COLOUR(147, 147, 147);
    sub.textAlignment = subAlian;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:imagef];
    image.image = [UIImage imageNamed:name];
    
    [cell addSubview: tit];
    [cell addSubview: sub];
    [cell addSubview: image];
    
}

// 美食，生活界面设置
- (void)setCellViewFrame:(CGRect)rect text:(NSString *)str imageFrame:(CGRect)imagef name:(NSString *)name addView:(UIView *)cell{
    UILabel *tit = [[UILabel alloc] initWithFrame:rect];
    tit.text = str;
    tit.textColor = COLOUR(47, 47, 47);
    tit.textAlignment = NSTextAlignmentCenter;
    tit.font = FONT(17);
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:imagef];
    image.image = [UIImage imageNamed:name];
    
    [cell addSubview: tit];
    [cell addSubview: image];
}

// 猜你喜欢设置
- (void)setCellViewFrameaddView:(UIView *)cell{
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:RECTMACK(10, 18, 20, 20)];
    image.image = [UIImage imageNamed:@"home_redHeart.png"];
    
    UILabel *tit = [[UILabel alloc] initWithFrame:RECTMACK(36, 0, 80, 56)];
    tit.text = @"猜你喜欢";
    tit.textColor = COLOUR(47, 47, 47);
    tit.font = FONT(17);
    
    UILabel *sub = [[UILabel alloc] initWithFrame:RECTMACK(123, 0, 200, 56)];
    sub.text = @"好吃的 好玩的";
    sub.font = FONT(14);
    sub.textColor = COLOUR(147, 147, 147);
    
    [cell addSubview: tit];
    [cell addSubview: sub];
    [cell addSubview: image];
}

// 轮播图
- (void)imageClickWithIndex:(NSInteger)index{
    
 
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.adDataMarr[index - 1]];
    NSString *str = [dic objectForKey:@"rollId"];
    NSString *url = [dic objectForKey:@"url"];
    
    if (str.length > 0) {
        HomeTiceketDetialViewController *detial = [[HomeTiceketDetialViewController alloc] init];
        detial.rollId = [dic objectForKey:@"rollId"];
        detial.type = [dic objectForKey:@"modelType"];
        [self.navigationController pushViewController:detial animated:YES];
    }else if(url.length > 0){
        WebServerViewController *web = [[WebServerViewController alloc] init];
        web.url = [dic objectForKey:@"url"];
        [self.navigationController pushViewController:web animated:YES];
    }else{
        
    }
    
    
   
    
}

// 搜索按钮
- (void)search{
    HomeSearchViewController *search = [[HomeSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

// 头条
- (void)passMassage:(NSDictionary *)dic{
    HomeTiceketDetialViewController *detial = [[HomeTiceketDetialViewController alloc] init];
    NSString *str = [dic objectForKey:@"rollId"];
//    NSString *url = [dic objectForKey:@"url"];
    
    if (str.length > 0) {
        detial.rollId = [dic objectForKey:@"rollId"];
        detial.type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"modelType"]];
        [self.navigationController pushViewController:detial animated:YES];
     
    }
//    NSLog(@"%@",dic);
}


// 美食
- (void)dragonA{
    HomeFoodLifePlayViewController *food = [[HomeFoodLifePlayViewController alloc] init];
    food.type = @"0";
    [self.navigationController pushViewController:food animated:YES];
    
}
// 生活
- (void)friendA{
    HomeFoodLifePlayViewController *food = [[HomeFoodLifePlayViewController alloc] init];
    food.type = @"1";
    [self.navigationController pushViewController:food animated:YES];
}
// 娱乐
- (void)templeA{
    HomeFoodLifePlayViewController *food = [[HomeFoodLifePlayViewController alloc] init];
    food.type = @"2";
    [self.navigationController pushViewController:food animated:YES];
}

// 龙好礼
- (void)foodA{
    self.tabBarController.selectedIndex=3;
    postNotification(@"tabBarControllerDragon");
}



// 好友赠送
- (void)playA{
    HomeFriendPresenterViewController *friend = [[HomeFriendPresenterViewController alloc] init];
    friend.type = @"4";
    [self.navigationController pushViewController:friend animated:YES];
}

// 善行天下
- (void)lifeA{
    HomeTempleTableViewController *temple = [[HomeTempleTableViewController alloc] init];
    
    [self.navigationController pushViewController:temple animated:YES];
}

// 时尚购
- (void)shoppingA{
    HomeFoodLifePlayViewController *food = [[HomeFoodLifePlayViewController alloc] init];
    food.type = @"3";
    [self.navigationController pushViewController:food animated:YES];
}

- (void)OnMapBtnTap:(UIButton *)btn{
    ISLOGIN;
    HomeLuckGiftViewController *gift = [[HomeLuckGiftViewController alloc] init];
    [self.navigationController pushViewController:gift animated:YES];
 
}

- (void)refresh{
    
    _page = 1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rollApps removeAllObjects];
            [self.adDataMarr removeAllObjects];
            [self getMassage];
        });
    });
}


- (void)loadMore{
    _page++;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getMassage];
        });
    });
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
