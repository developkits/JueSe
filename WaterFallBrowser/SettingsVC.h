//
//  SettingsVC.h
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-21.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToFriendVC.h"
#import "RecSoftwareVC.h"
#import "PopoverView.h"
#import "ViewController.h"
@interface SettingsVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat bytes;
}
@property (nonatomic,assign)CGFloat bytes;
@end
