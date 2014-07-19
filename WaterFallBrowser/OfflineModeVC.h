//
//  OfflineModeVC.h
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-22.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "WaterFallBaseVC.h"

@interface OfflineModeVC : WaterFallBaseVC<UIScrollViewDelegate>
{
    NSArray* allAlbumArray;
    NSInteger currentPage;
    BOOL isUpdating;
    NSInteger maxPage;
}
@end
