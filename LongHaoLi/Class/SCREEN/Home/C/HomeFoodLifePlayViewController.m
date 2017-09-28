//
//  HomeFoodLifePlayViewController.m
//  LongHaoLi
//
//  Created by Guang shen on 2017/8/16.
//  Copyright © 2017年 fanfan. All rights reserved.
//

#import "HomeFoodLifePlayViewController.h"

@interface HomeFoodLifePlayViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, retain)UITextField *textField;
@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)NSMutableArray *searchArr;
@property (nonatomic, retain)NSMutableArray *dataArr;
@property (nonatomic, assign)int page;
@property (nonatomic, assign)BOOL isSearch;

@end

@implementation HomeFoodLifePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
 
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.dataArr = [[NSMutableArray alloc ] init];
    self.searchArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isSearch = NO;
    [self setTableView];
    [self getMassage];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    //    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:YES];
}

- (void)setTableView{
    [self setSearchBar];
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    table.dataSource = self;
    table.delegate =self;
    self.tableView = table;
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeHotCommodityTableViewCell" bundle:nil] forCellReuseIdentifier:@"like"];
    [self.view addSubview: table];
    // Do any additional setup after loading the view.
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view.
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
}

- (void)setSearchBar{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    backView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:backView];
    
    //地图
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = CGRectMake(SCREEN_WIDTH - 50, 24, 40, 40);
    [mapBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(OnMapBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:mapBtn];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(60, 30, SCREEN_WIDTH - 120, 28)];
    //    searchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_home_searchBar"]];
    searchView.backgroundColor = COLOUR(255 , 255  , 255);
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 14;
    [backView addSubview:searchView];
    
    UITextField *placeHolderLabel = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 150, 28)];
    placeHolderLabel.placeholder = @"🔍请输入你想要的结果";
    [placeHolderLabel addTarget:self action:@selector(textFileChange:) forControlEvents:UIControlEventEditingChanged];
    self.textField = placeHolderLabel;
    placeHolderLabel.font = FONT(15);
    self.textField.delegate =self;
    self.textField.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:placeHolderLabel];
    UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    UIImageView *backs = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back.png"]];
    backs.frame = CGRectMake(12, 29, 30, 30);
    backs.userInteractionEnabled = YES;
    [backs addGestureRecognizer: tapBack];
    [backView addSubview: backs];
    UIView *backSearch = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 64)];
    [backView addSubview: backSearch];
    [backSearch addGestureRecognizer: tapBack];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeHotCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"like"];
    TicketModel *model;
    if (self.isSearch) {
        model = self.searchArr[indexPath.row];
    }else{
        model = self.dataArr[indexPath.row];
    }
    cell.headImage.layer.masksToBounds = YES;
    cell.headImage.layer.cornerRadius = 5;
    
        
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE,[MyBase64 stringConpanSteing:model.photo]]] placeholderImage:[UIImage imageNamed:@"loadingimg.png"] options:SDWebImageAllowInvalidSSLCertificates];
    cell.name.text = model.name;
    cell.num.text = [NSString stringWithFormat:@"剩余%d份",model.surplusCount];
    [self changeStringColor:cell.num.text lable:cell.num changeString:[NSString stringWithFormat:@"%d",model.surplusCount] forColor:[UIColor redColor] andFont:16];
    cell.address.text = model.addressShop;
    cell.price.text = [NSString stringWithFormat:@"%0.2f元",model.salePrice];
    cell.shopprice.text = [NSString stringWithFormat:@"门市价%0.2f",model.originalPrice];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)textFileChange:(UITextField *)textfile{
    if (textfile.text.length == 0) {
        self.isSearch = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return   130 * SCREEN_WIDTH/414;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearch) {
        return self.searchArr.count;
    }
    return  self.dataArr.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TicketModel *model;
    if (self.isSearch) {
        model = self.searchArr[indexPath.row];
    }else{
        model = self.dataArr[indexPath.row];
    }
    
    HomeTiceketDetialViewController *detial = [[HomeTiceketDetialViewController alloc] init];
    detial.rollId = [NSString stringWithFormat:@"%@",model.rollId];
    detial.type = self.type;
    [detial.navigationController.navigationBar setBarTintColor: BACKGROUNDCOLOR];
    [self.navigationController pushViewController:detial animated:YES];
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    self.isSearch = YES;
    [self searchKey:self.textField.text];
    [textField resignFirstResponder];
    return YES;
}

// 搜索
- (void)OnMapBtnTap{
    
    if (self.textField.text.length > 0) {
        [self.searchArr removeAllObjects];
        self.isSearch = YES;
        [self searchKey:self.textField.text];
        
    }else{
        self.isSearch = NO;
    }
    
}


- (void)refresh{
    _page = 1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataArr removeAllObjects];
            [self.searchArr removeAllObjects];
            if (self.isSearch) {
                [self searchKey:self.textField.text];
            }else{
                [self getMassage];
            }
        
            
        });
    });
}


- (void)loadMore{
    _page++;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isSearch) {
                [self searchKey:self.textField.text];
            }else{
                [self getMassage];
            }
            
        });
    });
}

- (void)searchKey:(NSString *)str{
    NSString *page = [NSString stringWithFormat:@"%d",_page];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_type,@"type",page,@"page",[NSString stringWithFormat:@"%f",APPDELEGATE.latitude],@"latitudeX",[NSString stringWithFormat:@"%f",APPDELEGATE.longitude],@"latitudeY",str,@"name", nil];
    [MJPush postWithURLString:LIST parameters:dic success:^(id sucess) {
        
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
            for (NSDictionary *dic in [sucess objectForKey:@"data"]) {
                TicketModel *model = [TicketModel setModelWithDictionary:dic];
                [self.searchArr addObject:model];
            }
            [self.tableView reloadData];
        }else  if ([[sucess objectForKey:@"code"] isEqualToString:@"001"]) {
            ALERT([sucess objectForKey:@"message"]);
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)changeStringColor:(NSString *)allString lable:(UILabel *)hintLabel changeString:(NSString *)str forColor:(UIColor *)color andFont:(float)font{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:allString];
    NSRange range1=[[hintString string]rangeOfString:str];
    [hintString addAttribute:NSForegroundColorAttributeName value:color range:range1];
    UIFont *f = FONT(font);
    [hintString addAttribute:NSFontAttributeName value:f range:range1];
    hintLabel.attributedText=hintString;
}

- (void)getMassage{
    NSString *page = [NSString stringWithFormat:@"%d",_page];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_type,@"type",page,@"page",[NSString stringWithFormat:@"%f",APPDELEGATE.latitude],@"latitudeX",[NSString stringWithFormat:@"%f",APPDELEGATE.longitude],@"latitudeY", nil];
    [MJPush postWithURLString:LIST parameters:dic success:^(id sucess) {
        
        if ([[sucess objectForKey:@"code"] isEqualToString:@"000"]) {
            NSArray *arr = [NSArray arrayWithArray:[sucess objectForKey:@"data"]];
            if (arr.count > 0) {
                for (NSDictionary *dic in arr) {
                    TicketModel *model = [TicketModel setModelWithDictionary:dic];
                    [self.dataArr addObject:model];
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
