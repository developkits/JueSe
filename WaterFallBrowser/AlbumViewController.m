//
//  AlbumViewController.m
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-17.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "AlbumViewController.h"

@interface AlbumViewController ()
{
    AlbumToolBar* toolBar;
    XLCycleScrollView* imageBrowser;
    
    NSOperationQueue* taskQueue;
    
    NSArray* imageURLArray;
    
    UIView* bottomView;
}
@end

@implementation AlbumViewController
@synthesize isLike;
-(NSString*)albumID
{
    return albumID;
}
-(void)setAlbumID:(NSString *)aAlbumID
{
    if(albumID!=aAlbumID)
    {
        [albumID release];
        albumID=[aAlbumID retain];
        [self loadAlbumImagesURLWithID:albumID];
    }
}
-(id)init
{
    self=[super init];
    if(self)
    {
        taskQueue=[[NSOperationQueue alloc] init];
    }
    return self;
}
-(void)dealloc
{
    [imageBrowser release];
    [toolBar release];
    [APP hideIndicator];
    [APP showTabBar];
    NSLog(@"albumVC dealloc");
    [super dealloc];
}
-(void)loadAlbumImagesURLWithID:(NSString*)aAlbumID
{
    
    [APP showIndicatorAtMiddle:YES];
    
    if([[GlobalManager sharedManager] mode]==kAppModeOffline)
    {
        NSString* albumSubURLSavePath=[[[GlobalManager sharedManager] hotPath] stringByAppendingFormat:@"/%@",albumID];
        if([[NSFileManager defaultManager] fileExistsAtPath:albumSubURLSavePath])
        {
            imageURLArray=[[NSArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:albumSubURLSavePath]];
            if(imageURLArray.count==0)
            {
                NSLog(@"no image");
            }
            else
            {
                [self loadImage];
            }
        }
        [APP hideIndicator];
        return;
    }
    
    
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ALBUM_URL,aAlbumID]];
    NSLog(@"url:%@",url);
    
#if 0
    NSURLRequest* request= [NSURLRequest requestWithURL:url];
#else
    NSURLRequest* request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];//配置缓存和超时时间
#endif
    [NSURLConnection sendAsynchronousRequest:request queue:taskQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         
         if(connectionError)
         {
             NSLog(@"connectionError:%@",connectionError);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [APP hideIndicator];
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
             NSArray* array=[dict objectForKey:@"img"];
             NSLog(@"array:%@",array);
             imageURLArray=[[NSArray alloc] initWithArray:array];
             
             NSString* albumSubURLSavePath=[[[GlobalManager sharedManager] hotPath] stringByAppendingFormat:@"/%@",albumID];
             [NSKeyedArchiver archiveRootObject:array toFile:albumSubURLSavePath];
            
             
             
             [self performSelectorOnMainThread:@selector(loadImage) withObject:nil waitUntilDone:NO];
             
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             [APP hideIndicator];
         });
     }];

}
-(void)loadImage
{
    NSLog(@"bounds:%@",NSStringFromCGRect(self.view.bounds));
    CGRect frame=self.view.bounds;
    //图片查看器
    imageBrowser=[[XLCycleScrollView alloc] initWithFrame:frame];
    imageBrowser.delegate=self;
    imageBrowser.datasource=self;
    imageBrowser.autoresizesSubviews=NO;
//    imageBrowser.layer.borderColor=[UIColor whiteColor].CGColor;
//    imageBrowser.layer.borderWidth=10;
    
    [self.view addSubview:imageBrowser];
    //[self.view sendSubviewToBack:imageBrowser];
    //[self.view bringSubviewToFront:[self.view viewWithTag:11]];
    
    if([[GlobalManager sharedManager] mode]==kAppModeOnline)
    {
        //工具条
        toolBar=[[AlbumToolBar alloc] initWithFrame:CGRectMake(0,frame.size.height-44, frame.size.width, 44) isLike:self.isLike];
        toolBar.tag=11;
        toolBar.delegate=self;
        toolBar.hidden=YES;
        //toolBar.backgroundColor=[UIColor clearColor];
        [self.view addSubview:toolBar];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)leftItemClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
     NSDictionary* attriDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor clearColor],UITextAttributeTextColor,[UIFont systemFontOfSize:16],UITextAttributeFont, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attriDict];
    
    
    
    UIBarButtonItem* leftItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logo_bar.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClicked)];
    
    self.navigationItem.leftBarButtonItem=leftItem;
     self.navigationController.navigationBar.hidden=YES;
    
    UIBarButtonItem* rightItem=[[UIBarButtonItem alloc] initWithTitle:self.title style:UIBarButtonItemStylePlain target:nil action:nil];
    [rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=rightItem;
    [rightItem release];
   
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"]];
    
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [self.view addGestureRecognizer:tap];
    [tap release];
    
    //toolBar.hidden=YES;
   
    /*
    UIBarButtonItem* rightItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"itemButton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(itemClicked)];
    self.navigationItem.rightBarButtonItem=rightItem;
    */
}
/*
-(void)itemClicked
{
    
}
 */
-(void)toolBarDidClickedItem:(NSInteger)tag
{
    NSLog(@"tag:%d",tag);
    
    if(tag==1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if(tag==2)
    {
        [APP shareInfoString:[imageURLArray objectAtIndex:imageBrowser.currentPage] description:[NSString stringWithFormat:@"%@%@来自绝色美女",self.title,[imageURLArray objectAtIndex:imageBrowser.currentPage]]];
    }
    else if(tag==3)
    {
        
        [[GlobalManager sharedManager] removeAlbumFromFavorite:self.albumID];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeAlbum" object:nil userInfo:[NSDictionary dictionaryWithObject:self.albumID forKey:@"albumID"]];
        
        
    }
    //保存到相册
    else if (tag==4)
    {
        @try {
            UIImage * image=[[SDImageCache sharedImageCache] imageFromKey:[imageURLArray objectAtIndex:imageBrowser.currentPage]];
            if(image)
             UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            else
                NSLog(@"image is nil");
        }
        @catch (NSException *exception) {
            NSLog(@"exception:%@",exception);
        }
        @finally {
            NSLog(@"final");
        }
       
    }
    else
    {
        [[GlobalManager sharedManager] addAlbumToFavorite:self.albumID];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addAlbum" object:nil userInfo:[NSDictionary dictionaryWithObject:self.albumID forKey:@"albumID"]];
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"error:%@",error);
    NSString* status=@"保存成功";
    if(error)
        status=@"错误";
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:status delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
-(void)tapped
{
    if([[GlobalManager sharedManager] mode]==kAppModeOnline)
    {
        if(toolBar.hidden==YES)
        {
            self.navigationController.navigationBar.hidden=NO;
            toolBar.hidden=NO;
            
        }
        else
        {
            self.navigationController.navigationBar.hidden=YES;
            toolBar.hidden=YES;
        }
    }
    else
    {
        if(self.navigationController.navigationBar.hidden==YES)
            self.navigationController.navigationBar.hidden=NO;
        else
            self.navigationController.navigationBar.hidden=YES;
    }
    //NSLog(@"size:%@",NSStringFromCGSize(imageBrowser.));
}
- (NSInteger)numberOfPages
{
    return imageURLArray.count;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    UIScrollView * scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    //scrollView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"]];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.contentSize=CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height);
   
    scrollView.autoresizesSubviews=YES;
    scrollView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    scrollView.bounces=NO;
    scrollView.delegate=self;
    scrollView.bouncesZoom=NO;
    scrollView.minimumZoomScale=1;
    scrollView.maximumZoomScale=2;
    
    UIImageView * imageView=[[UIImageView alloc] initWithFrame:scrollView.bounds];
    imageView.tag=99;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView  setImageWithURL:[NSURL URLWithString:[imageURLArray objectAtIndex:index]] placeholderImage:[UIImage imageNamed:@"loading_bg.png"]];
    imageView.userInteractionEnabled=YES;
    
    
    [scrollView addSubview:imageView];
    [imageView release];
    return [scrollView autorelease];
}
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:99];
}
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index
{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
    //                                                    message:[NSString stringWithFormat:@"当前点击第%d个页面",index]
    //                                                   delegate:self
    //                                          cancelButtonTitle:@"确定"
    //                                          otherButtonTitles:nil];
    //    [alert show];
    //    [alert release];
}

-(BOOL)shouldAutorotate
{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    CGSize size=self.view.bounds.size;
//    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
//    {
//        imageBrowser.frame=CGRectMake(0, 0, size.height, size.width);
//    }
//    else
//    {
//        imageBrowser.frame=CGRectMake(0, 0, size.width, size.height);
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
