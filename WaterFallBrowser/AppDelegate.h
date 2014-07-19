//
//  AppDelegate.h
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-14.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "WXApi.h"
#import "WeiboApi.h"
#import "WXApi.h"
#import "WeiboApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "IIViewDeckController.h"
#import "AGViewDelegate.h"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController* offNav;
    UITabBarController* tabBarVC;
    UINavigationController* rootNav;
    Reachability* hostReach;
    AGViewDelegate *_viewDelegate;
     UIActivityIndicatorView* indicator;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,readonly) AGViewDelegate *viewDelegate;

@property (strong, nonatomic) ViewController *viewController;
-(void)hideTabBar;
-(void)showTabBar;
-(void)tabBarSwitchToItem:(NSInteger)item;
-(void)selectTabBar;
-(void)deselectTabBar;

-(void)shareInfoString:(NSString *)url  description:(NSString *)str;

-(void)showIndicatorAtMiddle:(BOOL)isMid;
-(void)hideIndicator;
@end
