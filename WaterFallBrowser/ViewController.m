//
//  ViewController.m
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-14.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    //NSOperationQueue* taskQueue;
    dispatch_group_t albumUpdateQueue;
    BOOL isUpdating;
    
    GlobalDataCacher * memCacher;
    NSUInteger currentPage;
}
@end

@implementation ViewController
@synthesize webDataURLString;
//@synthesize dataCachePath;
-(void)setDataCachePath:(NSString *)aDataCachePath
{
    if(dataCachePath!=aDataCachePath)
    {
        [dataCachePath release];
        dataCachePath=[aDataCachePath retain];
        NSFileManager * filemanager=[NSFileManager defaultManager];
        if(![filemanager fileExistsAtPath:self.dataCachePath])
        {
            [filemanager createDirectoryAtPath:self.dataCachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
}
-(void)setAlbumSubURLCachePath:(NSString *)aAlbumSubURLCachePath
{
    if(albumSubURLCachePath!=aAlbumSubURLCachePath)
    {
        [albumSubURLCachePath release];
        albumSubURLCachePath=[aAlbumSubURLCachePath retain];
        NSFileManager * filemanager=[NSFileManager defaultManager];
        if(![filemanager fileExistsAtPath:albumSubURLCachePath])
        {
            [filemanager createDirectoryAtPath:aAlbumSubURLCachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
}
-(void)setAlbumImgDataCachePath:(NSString *)aAlbumImgDataCachePath
{
    if(albumImgDataCachePath!=aAlbumImgDataCachePath)
    {
        [albumImgDataCachePath release];
        albumImgDataCachePath=[aAlbumImgDataCachePath retain];
        NSFileManager * filemanager=[NSFileManager defaultManager];
        if(![filemanager fileExistsAtPath:albumImgDataCachePath])
        {
            [filemanager createDirectoryAtPath:albumImgDataCachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
}
-(void)dataInit
{
    [super dataInit];
    //数据初始化
    memCacher=[GlobalDataCacher sharedCacher];
    currentPage=1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //加载首页
    //[self updateWithPage:currentPage];

    //[APP showIndicator];
    
    
}
-(void)dealloc
{
    NSLog(@"dealloced");
    [super dealloc];
    
}
-(void)updateWithPage:(NSInteger)page
{
    [APP  showIndicatorAtMiddle:NO];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d",self.webDataURLString,page]];
    NSLog(@"url:%@",url);
    
    
    NSLog(@"operationCount:%d",[[[GlobalManager sharedManager] downloadTaskQueue] operationCount]);
    
    
#if 0
    NSURLRequest* request= [NSURLRequest requestWithURL:url];
#else
    NSURLRequest* request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];//配置缓存和超时时间
#endif
    [NSURLConnection sendAsynchronousRequest:request queue:[[GlobalManager sharedManager] downloadTaskQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSLog(@"isMain:%d",[NSThread isMainThread]);
         if(connectionError)
         {
             NSLog(@"connectionError:%@",connectionError);
             
             isUpdating=NO;
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [APP hideIndicator];
                 UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [alert show];
                 [alert release];
             });
             
             return ;
         }
         
         NSError* error=nil;
         NSDictionary* dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
         if(error)
             NSLog(@"error:%@",error);
         else
         {
             //NSLog(@"dict:%@",dict);
             NSArray* array=[dict objectForKey:@"list"];
             //NSLog(@"array:%@",array);
             
             dispatch_group_t group=dispatch_group_create();
             for(NSDictionary* each in array)
             {
                 dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
                     
                     @autoreleasepool {
                         NSString* idTag=[[NSString alloc] initWithFormat:@"%@",[each objectForKey:@"id"]];
                         NSString* albumSavePath=[[NSString alloc] initWithFormat:@"%@/%@",dataCachePath,idTag];
                         
                         
                         //NSLog(@"savePath:%@",savePath);
                         
                         AlbumObject* album;
                         //如果缓存有,从本地读取
                         if([[NSFileManager defaultManager] fileExistsAtPath:albumSavePath])
                         {
                             album=[[AlbumObject alloc] initWithAlbum:[NSKeyedUnarchiver unarchiveObjectWithFile:albumSavePath]];
                             //缓存到内存
                             [self cacheLocalDataIntoMemoryWithAlbumID:idTag];
                         }
                         //如果没有,下载,然后保存
                         else
                         {
                             NSLog(@"net");
                             album=[[AlbumObject alloc] init];
                             album.clickCount=[each objectForKey:@"click"];
                             album.idTag=idTag;
                             album.imageURL=[NSURL URLWithString:[each objectForKey:@"img"]];
                             album.title=[each objectForKey:@"title"];
                             //album.imageData=[NSData dataWithContentsOfURL:album.imageURL];
                             NSString* albumImgDataSavePath=[[NSString alloc] initWithFormat:@"%@/%@",albumImgDataCachePath,idTag];
                             NSData* imgData=[[NSData alloc] initWithContentsOfURL:album.imageURL];
                             [imgData writeToFile:albumImgDataSavePath atomically:YES];
                             
                             //缓存到内存
                             if(imgData&&![memCacher existsObjectForKey:album.idTag])
                             {
                                 
                                 [memCacher setObject:imgData forKey:idTag cost:[imgData length]];
                             }
                             else
                             {
                                 NSLog(@"exist:%@",idTag);
                             }
                             
                             //保存
                             [NSKeyedArchiver  archiveRootObject:album toFile:albumSavePath];
                             
                             [albumImgDataSavePath release];
                             [imgData release];
                         }
                         
                         [albumArray addObject:album];//添加进数组
                         [idTag release];
                         [album release];
                         [albumSavePath release];
                         
                         
                     }
                 });
             }
             dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                 
                 [waterFallView reloadData];
                 dispatch_release(group);
                 
//                 if(page%30==0)
//                     [memCacher clearCacher];
             });
         }
     }];
}
-(void)reloadDataEnd
{
    [APP hideIndicator];
    isUpdating=NO;
    currentPage++;
    NSLog(@"end update");
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y>=(scrollView.contentSize.height-scrollView.frame.size.height-50)&&!isUpdating)
    {
       
        isUpdating=YES;
        [self updateWithPage:currentPage];
    }
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
    if([[manager favorArray] containsObject:album.idTag])
        cell.isSelected=YES;
    else
        cell.isSelected=NO;
    [path release];
    [image release];
    
    //cell.label.text=[NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}
*/
@end
