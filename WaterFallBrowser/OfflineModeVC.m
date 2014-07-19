//
//  OfflineModeVC.m
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-22.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "OfflineModeVC.h"

@interface OfflineModeVC ()

@end

@implementation OfflineModeVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dataInit
{
    [super dataInit];
    self.title=@"离线模式";
    currentPage=1;
    self.dataCachePath=[manager lastPath];
    self.albumImgDataCachePath=[manager recommendPath];
    self.albumSubURLCachePath=[manager hotPath];
}
-(void)loadData
{
    [super loadData];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSPredicate * filtPredicate=[NSPredicate predicateWithFormat:@"not SELF LIKE '*.*'"];
    NSArray* infoArray=[[fileManager contentsOfDirectoryAtPath:dataCachePath error:nil] filteredArrayUsingPredicate:filtPredicate];
    NSArray* imgArray=[[fileManager contentsOfDirectoryAtPath:albumImgDataCachePath error:nil] filteredArrayUsingPredicate:filtPredicate];
    
    NSPredicate * predicate=[NSPredicate predicateWithFormat:@"SELF in %@",imgArray];
    
    NSMutableArray* needArray=[[NSMutableArray alloc] initWithArray:[infoArray filteredArrayUsingPredicate:predicate]];
    [needArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] >[obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
        
    }];
    
    NSLog(@"info.cout:%d",infoArray.count);
    NSLog(@"img.count:%d",imgArray.count);
    NSLog(@"need.count:%d",needArray.count);
    //NSLog(@"info:%@",infoArray);
    //NSLog(@"img:%@",imgArray);
    
    allAlbumArray=[[NSArray alloc] initWithArray:needArray];
    maxPage= (allAlbumArray.count/20)+(allAlbumArray.count%20?1:0);
    NSLog(@"maxPage:%d",maxPage);
    [self updateWithPage:currentPage];//第一页
    
    [needArray release];
    
}
-(void)updateWithPage:(NSInteger)page
{
    if(currentPage>maxPage)
        return;
    [APP showIndicatorAtMiddle:NO];
    isUpdating=YES;
    NSInteger location=20*(currentPage-1);
    NSInteger x=allAlbumArray.count%20;
    NSInteger count= currentPage<maxPage?20:(x?x:20);
    
    NSLog(@"location:%d,count:%d",location,count);
    for(int i=location;i<location+count;i++)
    {
        NSString* albumID=[allAlbumArray objectAtIndex:i];
        NSString* albumSavePath=[[NSString alloc] initWithFormat:@"%@/%@",dataCachePath,albumID];
        
        //NSLog(@"path:%@",albumSavePath);
        [super cacheLocalDataIntoMemoryWithAlbumID:albumID];
        [albumArray addObject:[NSKeyedUnarchiver unarchiveObjectWithFile:albumSavePath]];
        [albumSavePath release];
        
      
    }
    
    NSLog(@"albumArray.count:%d",albumArray.count);
    NSLog(@"cacheDict:%d",[memCacher cachedCount]);
    [waterFallView reloadData];//
}
-(void)dealloc
{
    [allAlbumArray release];
    [albumArray release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)reloadDataEnd
{
    //[APP hideIndicator];
    isUpdating=NO;
    currentPage++;
    NSLog(@"reload end");
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y>=(scrollView.contentSize.height-scrollView.frame.size.height-50)&&!isUpdating)
    {
       
       // isUpdating=YES;
        [self updateWithPage:currentPage];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
