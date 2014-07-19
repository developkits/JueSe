//
//  AlbumToolBar.h
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-17.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LEFT_MARGIN 20

#define ITEM_COUNT 4
#define ITEM_WIDTH 40
#define ITEM_HEIGHT 40


@protocol AlbumToolBarDelegate <NSObject>
-(void)toolBarDidClickedItem:(NSInteger)tag;

@end



@interface AlbumToolBar : UIImageView
{
    id<AlbumToolBarDelegate>delagete;
    BOOL isLike;
}
@property(nonatomic,assign) id<AlbumToolBarDelegate>delegate;
- (id)initWithFrame:(CGRect)frame isLike:(BOOL)isLike;
@end
