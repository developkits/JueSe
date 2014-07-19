//
//  ViewController.h
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-14.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterFallBaseVC.h"

@interface ViewController : WaterFallBaseVC<UIScrollViewDelegate>
{
    NSString* webDataURLString;
}
@property(nonatomic,retain)NSString* webDataURLString;

@end
