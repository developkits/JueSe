//
//  FavoriteVC.m
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-19.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "FavoriteVC.h"

@interface FavoriteVC ()

@end

@implementation FavoriteVC
@synthesize imgV;
-(void)dataInit
{
    [super dataInit];
    self.dataCachePath=[manager lastPath];
    self.albumImgDataCachePath=[manager recommendPath];
    self.albumSubURLCachePath=[manager hotPath];

    
}
-(void)loadData
{
    [super loadData];
    NSLog(@"loadData");
    
    
    
    for(NSString* eachAblum in [manager favorArray])
    {
        [self addAlbumWithID:eachAblum];
    }
   
    NSLog(@"favorArray:%@",albumArray);
}
-(void)addAlbumWithID:(NSString*)ID
{
    
    NSString* albumPath=[[NSString alloc] initWithFormat:@"%@/%@",[manager lastPath],ID];
    
    AlbumObject* album=[NSKeyedUnarchiver unarchiveObjectWithFile:albumPath];
    if(album&&![albumArray containsObject:album])
    {
        [albumArray addObject:album];
        //NSLog(@"add:%@",ID);
    }
    [albumPath release];
}
-(void)removeAlbumWithID:(NSString*)ID
{
    for(AlbumObject * album in albumArray)
    {
        NSLog(@"ID:%@",ID);
        NSLog(@"album.id:%@",album.idTag);
        if([album.idTag integerValue] ==[ID integerValue])
        {
            [albumArray removeObject:album];
            NSLog(@"remove:%@",ID);
            break;
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    if(waterFallView)
        [waterFallView reloadData];
    
    if(!imgV)
    {
        imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        imgV.center = self.view.center;
        imgV.image =[UIImage imageNamed:@"icon_no_collect.png"];
        [self.view addSubview:imgV];
        [imgV release];
    }
    if (albumArray.count==0)
    {
        imgV.hidden=NO;
       
    }
    else
    {
        imgV.hidden=YES;
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(addAlbum:) name:@"addAlbum" object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(removeAlbum:) name:@"removeAlbum" object:nil];
    
    
     [self.view bringSubviewToFront:imgV];
    
}
-(void)addAlbum:(NSNotification*)notifi
{
    NSString* albumID=[[notifi userInfo] objectForKey:@"albumID"];
    [self addAlbumWithID:albumID];
    
    NSLog(@"favorArray:%@",albumArray);
    
}
-(void)removeAlbum:(NSNotification*)notifi
{
    NSString* albumID=[[notifi userInfo] objectForKey:@"albumID"];
    [self removeAlbumWithID:albumID];
    NSLog(@"favorArray:%@",albumArray);
}
/*
- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath*)indexPath
{
    WaterFallViewCell* cell=(WaterFallViewCell*)[quiltView dequeueReusableCellWithReuseIdentifier:@"id"];
    if(!cell)
    {
        cell=[[[WaterFallViewCell alloc] initWithReuseIdentifier:@"id"]autorelease];
    }
    AlbumObject* album=[albumArray objectAtIndex:indexPath.row];
    
    NSString* path=[[NSString alloc] initWithFormat:@"%@/%@.d",dataCachePath,album.idTag];
    
    UIImage * image=nil;
    NSData* imgData=[memCacher objectForKey:album.idTag];
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
    cell.isSelected=YES;
    
    [path release];
    [image release];
    
    //cell.label.text=[NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}
*/
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
