//
//  MYAdInfoViewController.m
//  MYMobAdsDemo
//
//  Created by Mac on 2024/5/22.
//  Copyright © 2024 MYMobAds. All rights reserved.
//

#import "MYAdInfoViewController.h"
#import <MYAdsFramework/MYAdsFramework.h>
#import <AdSupport/ASIdentifierManager.h>

@interface MYAdInfoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *listArray;
    NSArray *valueArray;
}

@property (nonatomic, strong)UITableView *adList;

@end

@implementation MYAdInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"基础信息";
    self.view.backgroundColor = UIColor.whiteColor;
    
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] ?: @"";
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString] ?: @"";
    
    listArray = @[@"App名称",@"Sdk版本号",@"Sdk最低版本支持",@"AppID",@"系统版本",@"设备ID",@"IDFA",@"IDFV"];
    valueArray = @[@"MYMobAds_iOS",[MYAdsConfiguration shareInstance].sdkVersion,@"12.0",MYMobAdsAppID,[[UIDevice currentDevice] systemVersion],[NSString stringWithFormat:@"IDFA_%@",idfa],idfa,idfv];
    [self.view addSubview:self.adList];
}

- (void)copyValue:(NSString *)value
{
    if (value.length == 0) {
        return;
    }
    NSString *idfaCopyedMsg = [NSString stringWithFormat:@"%@\n 已经复制到你的粘贴板",value];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:idfaCopyedMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = value;
    [alert show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = listArray[indexPath.row];
    cell.detailTextLabel.text = valueArray[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 6 || indexPath.row == 7) {
        [self copyValue:valueArray[indexPath.row]];
    }
}

#pragma maek - lazy
- (UITableView *)adList{
    if (!_adList) {
        _adList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)-64) style:UITableViewStylePlain];
        _adList.delegate = self;
        _adList.dataSource = self;
        _adList.tableFooterView = [UIView new];
    }
    return _adList;
}


@end
