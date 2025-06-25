//
//  MYNativeTableViewCell.m
//  MYMobsAd_Demo
//
//  Created by Eric on 2018/7/27.
//  Copyright © 2018年 Eric. All rights reserved.
//

#import "MYNativeTableViewCell.h"

@interface MYNativeTableViewCell()

@property (nonatomic, strong) UIView *imgImage;

@end

@implementation MYNativeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       // [self.contentView addSubview:self.imgImage];
    }
    return  self;
}

- (void)setExpressAdView:(MYNativeExpressAdView *)expressAdView{
    _expressAdView = expressAdView;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:expressAdView];
}

- (UIView *)imgImage{
    if (!_imgImage) {
        _imgImage = [[UIView alloc]init];
    }
    return _imgImage;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
