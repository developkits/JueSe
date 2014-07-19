//
//  WaterFallBaseVC.m
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-19.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "WaterFallBaseVC.h"

#import "ViewController.h"

@interface WaterFallBaseVC()
{
    //UIActivityIndicatorView* indicator;
}
@end

@implementation WaterFallBaseVC
@synthesize dataCachePath;
@synthesize albumSubURLCachePath;
@synthesize albumImgDataCachePath;
@synthesize needDetectSelect;
/*
-(void)showIndicator
{
    if(!indicator)
    {
        indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center=CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        indicator.hidesWhenStopped=YES;
        [self.view addSubview:indicator];
    }
    [indicator startAnimating];
}
-(void)hideIndicator
{
    if(indicator)
        [indicator stopAnimating];
}
 */
-(id)initWithNeedItem:(BOOL)aNeedItem
{
    self=[super init];
    if(self)
    {
        needItem=aNeedItem;
        [self dataInit];
        [self viewInit];
    }
    return self;
}
-(void)dataInit
{
    manager=[GlobalManager sharedManager];
    albumArray=[[NSMutableArray alloc] initWithCapacity:0];
    //[self loadData];//加载数据源
     memCacher=[GlobalDataCacher sharedCacher];
}
-(void)loadData
{
    
}
-(void)viewInit
{
    
  
    //瀑布流视图
    waterFallView=[[TMQuiltView alloc] initWithFrame:self.view.bounds];
    waterFallView.delegate=self;
    waterFallView.dataSource=self;
    waterFallView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //waterFallView.backgroundColor=[UIColor lightGrayColor];
    waterFallView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"]];
    [self.view addSubview:waterFallView];
    
    if(needItem)
    {
        UIBarButtonItem* leftItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logo_bar.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClicked)];
        
        self.navigationItem.leftBarButtonItem=leftItem;
        
        if([manager mode]==kAppModeOnline)
        {
         UIBarButtonItem* rightItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"itemButton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked)];
             //[rightItem setFinishedSelectedImage:[UIImage imageNamed:@"itemButton.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"itemSelectButton.png"]];
        
         self.navigationItem.rightBarButtonItem=rightItem;
        }
    }
    [self loadData];//加载数据源

}
-(void)leftItemClicked
{
    if([[GlobalManager sharedManager]  mode] ==kAppModeOnline)
    [APP  tabBarSwitchToItem:0];
}
-(void)rightItemClicked
{
    NSLog(@"item");
    [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"dkitem.png"]];

    NSArray* stringArray=[NSArray arrayWithObjects:@"全部图片",@"推荐图片",@"我喜欢的",@"推荐软件", nil];
    [PopoverView showPopoverAtPoint:CGPointMake(290, 64) inView:self.view withTitle:@"选项" withStringArray:stringArray delegate:self];
    
    
}
-(void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"index:%d",index);
    [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"itemButton.png"]];

    if(index==0)
    {
        [APP   tabBarSwitchToItem:0];
    }
    else if(index==1)
    {
#if 1
        NSString* reccommendURL=[NSURL URLWithString:RECOMMEND_URL];
        ViewController* recVC=[[ViewController alloc] initWithNeedItem:NO];
        recVC.title=@"推荐";
        recVC.webDataURLString=reccommendURL;
        recVC.dataCachePath=[manager lastPath];
        recVC.needDetectSelect=YES;
        recVC.albumSubURLCachePath=[manager hotPath];
        recVC.albumImgDataCachePath=[manager recommendPath];
        [self.navigationController pushViewController:recVC animated:YES];
       // [APP  deselectTabBar];
        [recVC release];
#else
        [APP   tabBarSwitchToItem:2];
#endif
        
    }
    else if(index==2)
    {
         [APP   tabBarSwitchToItem:2];
    }
    else if(index==3)
    {
        RecSoftwareVC* vc=[[[RecSoftwareVC alloc] init]autorelease];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    [popoverView dismiss];
}
-(void)viewWillAppear:(BOOL)animated
{
     NSDictionary* attriDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:26],UITextAttributeFont, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attriDict];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    NSLog(@"dismiss");
    [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"itemButton.png"]];
}
-(void)dealloc
{
    //[APP selectTabBar];
    [waterFallView release];
    [albumArray release];
    [super dealloc];
}
- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView
{
    
    return albumArray.count;
}
- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath*)indexPath
{
    WaterFallViewCell* cell=(WaterFallViewCell*)[quiltView dequeueReusableCellWithReuseIdentifier:@"id"];
    if(!cell)
    {
        cell=[[[WaterFallViewCell alloc] initWithReuseIdentifier:@"id"]autorelease];
    }
    AlbumObject* album=[albumArray objectAtIndex:indexPath.row];
    
    NSString* albumID=[[NSString alloc] initWithFormat:@"%d",[album.idTag integerValue]];
    NSString* path=[[NSString alloc] initWithFormat:@"%@/%@",albumImgDataCachePath,albumID];
    UIImage * image=nil;
    NSData* imgData=[memCacher objectForKey:albumID];
    if(imgData)
    {
        NSLog(@"1");
        image=[[UIImage alloc] initWithData:imgData];
    }
    else
    {
        NSLog(@"2");
        image=[[UIImage alloc] initWithContentsOfFile:path];
    }
    
    [cell.imageView setImage:image];
    cell.label.text=album.title;
    cell.albumID=album.idTag;
    
    //喜欢，不需要检测
    if(self.needDetectSelect==NO)
        cell.isSelected=YES;
    //根据数据检测是否需要选中
    else
    {
        if([[manager favorArray] containsObject:album.idTag])
            cell.isSelected=YES;
        else
            cell.isSelected=NO;
    }
    [albumID release];
    [path release];
    [image release];
    
    //cell.label.text=[NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}
- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    WaterFallViewCell* cell=(WaterFallViewCell*)[quiltView cellAtIndexPath:indexPath];
    
    AlbumObject* album=[albumArray objectAtIndex:indexPath.row];
    
    AlbumViewController* albumVC=[[[AlbumViewController alloc] init] autorelease];
    albumVC.title=[(AlbumObject*)[albumArray objectAtIndex:indexPath.row] title];
    albumVC.albumID=album.idTag;
    if(cell.isSelected==YES)
    {
        albumVC.isLike=YES;
    }
        
    [APP hideTabBar];
    
    [self.navigationController pushViewController: albumVC animated:YES];
    NSLog(@"did select:%d",indexPath.row);
}
- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView
{
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
    {
        return 5;
    }
    else
    {
        return 3;
    }
}
- (CGFloat)quiltViewMargin:(TMQuiltView *)quilView marginType:(TMQuiltViewMarginType)marginType
{
    return 6;
}
- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width
{
    AlbumObject* album=[albumArray objectAtIndex:indexPath.row];
    NSString* albumID=[[NSString alloc] initWithFormat:@"%d",[album.idTag integerValue]];
    NSString* path=[[NSString alloc] initWithFormat:@"%@/%@",albumImgDataCachePath,albumID];
    UIImage * image=nil;
    NSData* imgData=[memCacher objectForKey:albumID];
    if(imgData)
    {
        //NSLog(@"q 1:%d",[imgData length]);
        image=[[UIImage alloc] initWithData:imgData];
    }
    else
    {
        //NSLog(@"q 2");
        image=[[UIImage alloc] initWithContentsOfFile:path];
    }
    CGSize size=image.size;
    if(size.width*size.height<=0)
    {
        NSLog(@"image error");
    }
    
    //NSLog(@"size:%@",NSStringFromCGSize(size));
    [albumID release];
    [path release];
    [image release];
    return width*(size.height/size.width)+WaterFallViewCellLabelHeight;
}
-(void)cacheLocalDataIntoMemoryWithAlbumID:(NSString*)albumID
{
    NSString* albumImgDataSavePath=[[NSString alloc] initWithFormat:@"%@/%@",albumImgDataCachePath,albumID];
    NSData* imgData=[[NSData alloc]initWithContentsOfFile:albumImgDataSavePath];
    if(imgData&&![memCacher existsObjectForKey:albumID])
    {
        //NSLog(@"cache %d data from disk of %@",[imgData length],albumID);
        [memCacher setObject:imgData forKey:albumID cost:[imgData length]];
    }
    else
    {
        NSLog(@"exist");
    }
    [imgData release];
    [albumImgDataSavePath release];
}
-(void)reloadDataEnd
{
    
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [waterFallView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
