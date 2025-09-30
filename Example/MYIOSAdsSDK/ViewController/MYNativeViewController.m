//
//  MYNativeViewController.m
//  MYMobAds_Demo
//  
//  Created by Eric on 2017/8/29.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import "MYNativeViewController.h"
#import <MYAdsFramework/MYAdsFramework.h>
#import "MYNativeTableViewCell.h"
#import "LogManager.h"

@interface MYNativeViewController ()<UITableViewDelegate,UITableViewDataSource,MYNativeExpressAdDelegate>{
    NSMutableArray *_data;             //原生广告数据数组
}
@property (nonatomic, strong) UITableView *listTable;

@property (nonatomic, strong) MYNativeExpressAd *expressAd;

@end

@implementation MYNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.listTable];
    _data = [[NSMutableArray alloc]init];
    if (@available(iOS 10.0, *)) {
        self.listTable.refreshControl = [[UIRefreshControl alloc]init];
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        self.listTable.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        [self.listTable.refreshControl addTarget:self action:@selector(laterLoad) forControlEvents:UIControlEventValueChanged];
    } else {
        // Fallback on earlier versions
    }
}
- (void)laterLoad{
    [self.expressAd MY_loadAd:3];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 2 == 0) {
        MYNativeExpressAdView *view = [_data objectAtIndex:indexPath.row / 2];
        return view.frame.size.height;
    }
    else {
        return 44;
    }
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _data.count*2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MYNativeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYNativeTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_data) {
        if (indexPath.row % 2 == 0) {
            MYNativeExpressAdView *view = [_data objectAtIndex:indexPath.row / 2];
            [view MY_render];
            view.tag = 1000;
            cell.expressAdView = view;
        }else{
            cell.expressAdView = nil;
        }
    }
    
    return cell;
}

#pragma mark - 原生模板代理方法
- (void)MY_nativeExpressAdSuccessToViews:(NSArray<__kindof MYNativeExpressAdView *> *)views{
    NSLog(@"原生模板广告加载成功");
    [_data removeAllObjects];
    [_data addObjectsFromArray:views];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listTable reloadData];
        //添加数据，刷新数据
        if (@available(iOS 10.0, *)) {
            [self.listTable.refreshControl endRefreshing];
        } else {
            // Fallback on earlier versions
        }
    });
}

- (void)MY_nativeExpressAdViewRenderSuccess{
    NSLog(@"原生模板广告渲染成功");
    [self.listTable reloadData];
}
- (void)MY_nativeExpressAdFailToLoad:(NSError *)error{
    NSLog(@"原生模板广告加载失败%@",error);
    NSString *err = error.description;
    [[LogManager shared] logToTextView:err];
    [_data removeAllObjects];
    if (@available(iOS 10.0, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listTable.refreshControl endRefreshing];
            [self.listTable reloadData];
        });
        
    } else {
        // Fallback on earlier versions
    }
    
}
- (void)MY_nativeExpressAdExposure{
    NSLog(@"原生模板广告曝光成功");
}

- (void)MY_nativeExpressAdClick{
    NSLog(@"原生模板广告被点击");
    MYAppDelegate *delegate = (MYAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.toastLab.text = @"原生模板广告被点击";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        delegate.toastLab.text = @"";
    });
}

- (void)MY_nativeExpressAdViewClosed:(MYNativeExpressAdView *)nativeExpressAdView {
    [_data removeObject:nativeExpressAdView];
    [self.listTable reloadData];
}

#pragma mark - lazy
- (MYNativeExpressAd *)expressAd{
    if (!_expressAd) {
        _expressAd = [[MYNativeExpressAd alloc]initWithExpressWithAppId:MYMobAdsAppID spaceId:NativeID adSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 108)];
        _expressAd.currentController = self;
        _expressAd.delegate = self;
    }
    return _expressAd;
}

- (UITableView *)listTable{
    if (!_listTable) {
        _listTable = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _listTable.delegate = self;
        _listTable.dataSource = self;
        [_listTable registerClass:[MYNativeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MYNativeTableViewCell class])];
    }
    return _listTable;
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
