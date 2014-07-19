//
//  WaterFallViewCell.h
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-14.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "TMQuiltViewCell.h"



#define  WaterFallViewCellMargin 3
#define  WaterFallViewCellLabelHeight 30

@interface WaterFallViewCell : TMQuiltViewCell
{
    UIImageView* imageView;
    UILabel* label;
    UIButton* button;
    BOOL isSelected;
}
@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic,retain) NSString* albumID;
@property(nonatomic,retain) UIImageView* imageView;
@property(nonatomic,retain) UILabel * label;
@property(nonatomic,retain) UIButton* button;
@end
