//
//  AlbumViewController.h
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-17.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumToolBar.h"
#import "XLCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
@interface AlbumViewController : UIViewController<XLCycleScrollViewDatasource,XLCycleScrollViewDelegate,UIScrollViewDelegate,AlbumToolBarDelegate>
{
    NSString* albumID;
    BOOL isLike;
}
@property(nonatomic,assign) BOOL isLike;
@property(nonatomic,retain) NSString* albumID;
@end
