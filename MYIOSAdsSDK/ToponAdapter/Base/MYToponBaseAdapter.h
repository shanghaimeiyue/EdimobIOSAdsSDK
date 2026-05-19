//
//  MyBaseAdapter.h
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYToponAdapterCommonHeader.h"

@interface MYToponBaseAdapter : ATBaseMediationAdapter

//C2S flow needed
+ (NSMutableDictionary *)getLossInfoResult:(ATBidWinLossResult *)winLossResult;

//C2S flow needed
+ (NSMutableDictionary *)getWinInfoResult:(ATBidWinLossResult *)winLossResult;

//C2S flow needed
+ (NSMutableDictionary *)getC2SInfo:(NSInteger)ecpm networkAdObj:(id)networkAdObj;

@end


