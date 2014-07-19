//
//  WaterFallViewCell.m
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-14.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "WaterFallViewCell.h"

@implementation WaterFallViewCell
@synthesize imageView,label,button;
@synthesize albumID;
-(BOOL)isSelected
{
    return isSelected;
}
-(void)setIsSelected:(BOOL)aIsSelected
{
    isSelected=aIsSelected;
    if(isSelected==YES)
    {
        if(self.button)
        [button setImage:[UIImage imageNamed:@"like_sure.png"] forState:UIControlStateNormal];
    }
    else
    {
        if(self.button)
        [button setImage:[UIImage imageNamed:@"xh_2.png"] forState:UIControlStateNormal];
    }
}
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor=[UIColor whiteColor];
        
        
    }
    return self;
}
- (UIImageView *)imageView {
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor=[UIColor grayColor];
        imageView.userInteractionEnabled=YES;
        [self addSubview:imageView];
        
        
    }
    return imageView;
}
-(UIButton*)button
{
    if(!button)
    {
        button=[[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"like_cancel.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:button];
    }
    return button;
}
- (UILabel *)label {
    if (!label) {
        label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor blackColor];
        label.font=[UIFont systemFontOfSize:10];
        label.numberOfLines=0;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return label;
}
-(void)layoutSubviews
{
    //NSLog(@"layout subViews");
    CGFloat width=self.bounds.size.width;
    CGFloat height=self.bounds.size.height;
    self.imageView.frame=CGRectMake(WaterFallViewCellMargin, WaterFallViewCellMargin, width-2*WaterFallViewCellMargin,height-2*WaterFallViewCellMargin-WaterFallViewCellLabelHeight);
    self.label.frame=CGRectMake(WaterFallViewCellMargin, self.bounds.size.height-WaterFallViewCellLabelHeight-WaterFallViewCellMargin, self.bounds.size.width-2*WaterFallViewCellMargin, WaterFallViewCellLabelHeight);
    self.button.frame=CGRectMake(5,self.imageView.bounds.size.height-24, 20, 20);
    
}
-(void)buttonClicked:(UIButton*)aButton
{
    
   // NSLog(@"id:%@",self.albumID);
    if([aButton.imageView.image isEqual:[UIImage imageNamed:@"xh_2.png"]])
    {
        self.isSelected=YES;
        [button setImage:[UIImage imageNamed:@"like_sure.png"] forState:UIControlStateNormal];
        if(self.albumID)
        {
            [[GlobalManager sharedManager] addAlbumToFavorite:self.albumID];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addAlbum" object:nil userInfo:[NSDictionary dictionaryWithObject:self.albumID forKey:@"albumID"]];
        }
    }
    else
    {
        self.isSelected=NO;
        [button setImage:[UIImage imageNamed:@"xh_2.png"] forState:UIControlStateNormal];
        if(self.albumID)
        {
            [[GlobalManager sharedManager] removeAlbumFromFavorite:self.albumID];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeAlbum" object:nil userInfo:[NSDictionary dictionaryWithObject:self.albumID forKey:@"albumID"]];
        }
    }
}
-(void)dealloc
{
    [button release];
    [imageView release];
    [label release];
    [super dealloc];
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
