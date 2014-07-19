//
//  WaterFallBaseVC.h
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-19.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaterFallViewCell.h"
#import "TMQuiltView.h"
#import "UIImageView+WebCache.h"
#import "AlbumViewController.h"
#import "AlbumObject.h"
#import "PopoverView.h"
#import "RecSoftwareVC.h"

@interface WaterFallBaseVC : UIViewController<TMQuiltViewDataSource,TMQuiltViewDelegate,PopoverViewDelegate>
{
     NSString* dataCachePath;
    NSString* albumSubURLCachePath;
    NSString* albumImgDataCachePath;
    
@public
    TMQuiltView* waterFallView;
    NSMutableArray* albumArray;
    GlobalDataCacher * memCacher;
    GlobalManager * manager;
    BOOL needDetectSelect;
    BOOL needItem;
}
-(id)initWithNeedItem:(BOOL)aNeedItem;
-(void)loadData;
-(void)dataInit;
-(void)viewInit;
//-(void)showIndicator;
//-(void)hideIndicator;
-(void)cacheLocalDataIntoMemoryWithAlbumID:(NSString*)albumID;
@property(nonatomic,assign) BOOL needDetectSelect;
@property(nonatomic,retain) NSString* dataCachePath;
@property(nonatomic,retain) NSString* albumSubURLCachePath;
@property(nonatomic,retain) NSString* albumImgDataCachePath;
@end
