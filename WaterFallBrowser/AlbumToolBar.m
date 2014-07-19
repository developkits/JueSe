//
//  AlbumToolBar.m
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-17.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "AlbumToolBar.h"

@implementation AlbumToolBar
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame isLike:(BOOL)aIsLike
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.image=[UIImage imageNamed:@"tabBack.png"];
        // Initialization code
        self.userInteractionEnabled=YES;
        NSInteger width=frame.size.width;
        NSInteger height=frame.size.height;
        CGFloat gap=(width-ITEM_COUNT*ITEM_WIDTH-2*LEFT_MARGIN)/(ITEM_COUNT-1);
        
        isLike=aIsLike;
        
        NSArray* imageArray=[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"tool_back2.png"],[UIImage imageNamed:@"tool_share2.png"],[UIImage imageNamed:@"tool_like.png"],[UIImage imageNamed:@"tool_download2.png"],[UIImage imageNamed:@"tool_dislike.png"], nil];
       
        
        for(int i=0;i<4;i++)
        {
            UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
            if (i==0) {
                [button setImage:[UIImage imageNamed:@"tool_back.png"] forState:UIControlStateHighlighted];
            }
            else if (i==1)
            {
                [button setImage:[UIImage imageNamed:@"tool_share.png"] forState:UIControlStateHighlighted];
            }
            else if(i==3)
            {
                [button setImage:[UIImage imageNamed:@"tool_download.png"] forState:UIControlStateHighlighted];
            }
            [button addTarget:self action:@selector(toolButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=i+1;
            
            button.frame=CGRectMake(LEFT_MARGIN+(gap+ITEM_WIDTH)*i,(height-ITEM_HEIGHT)/2,ITEM_WIDTH, ITEM_HEIGHT);
            [self addSubview:button];
        }
        if(isLike)
        {
            UIButton* button=(UIButton*)[self viewWithTag:3];
            [button setImage:[imageArray objectAtIndex:4] forState:UIControlStateNormal];
            button.tag=5;
        }
        
    }
    return self;
}
-(void)toolButtonClicked:(UIButton*)button
{
    if(button.tag==3||button.tag==5)
    {
        if(isLike)
        {
            isLike=NO;
            UIButton* button=(UIButton*)[self viewWithTag:5];
            [button setImage:[UIImage imageNamed:@"tool_like.png"] forState:UIControlStateNormal];
            button.tag=3;
        }
        else
        {
            isLike=YES;
            UIButton* button=(UIButton*)[self viewWithTag:3];
            [button setImage:[UIImage imageNamed:@"tool_dislike.png"] forState:UIControlStateNormal];
            button.tag=5;
        }
    }
    
    if([delegate respondsToSelector:@selector(toolBarDidClickedItem:)])
        [delegate toolBarDidClickedItem:button.tag];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
