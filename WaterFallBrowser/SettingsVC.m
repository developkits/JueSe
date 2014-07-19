//
//  SettingsVC.m
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-21.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "SettingsVC.h"
#import "UIColor+RGB.h"
@interface SettingsVC ()
{
    NSDictionary* itemDict;
    UITableView* tableView;
    GlobalManager* manager;
}
@end

@implementation SettingsVC
@synthesize bytes;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)init
{
    self=[super init];
    if(self)
    {
     
        NSArray* array0=[NSArray arrayWithObjects:@"清除缓存", nil];
        NSArray* array1=[NSArray arrayWithObjects:@"推荐给朋友",@"推荐应用", nil];
        NSArray* array2=[NSArray arrayWithObjects:@"检查更新", nil];
        
        itemDict=[[NSDictionary alloc] initWithObjectsAndKeys:array0,@"0",array1,@"1",array2,@"2", nil];
        manager=[GlobalManager sharedManager];
        
        
    }
    return self;
}
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
-(void)dealloc
{
    [tableView release];
    [itemDict release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor yellowColor];
    
    
    tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    tableView.scrollEnabled=NO;
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    
    
    
    UIBarButtonItem* leftItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logo_bar.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClicked)];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    
        UIBarButtonItem* rightItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"itemButton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked)];
        //[rightItem setFinishedSelectedImage:[UIImage imageNamed:@"itemButton.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"itemSelectButton.png"]];
        self.navigationItem.rightBarButtonItem=rightItem;
    
    NSInteger width=self.view.frame.size.width;
    NSInteger height=self.view.frame.size.height;
    UILabel* label1=[[UILabel alloc] initWithFrame:CGRectMake(0, height-200, width, 80)];
    label1.backgroundColor=[UIColor clearColor];
    label1.font=[UIFont systemFontOfSize:13];
    label1.textColor=[UIColor grayColor];
    label1.text=@"软件版权归JUEMEI.CC所有\nCopyright @ juemei.cc\n除标明本站原创外所有照片版权归创作人所有,如有冒犯,请直接与我们联系,感谢您的支持和厚爱。";
    label1.textAlignment=NSTextAlignmentCenter;
    label1.numberOfLines=0;
    [self.view addSubview:label1];
    [label1 release];
    
}
-(void)leftItemClicked
{
    [APP  tabBarSwitchToItem:0];
}
-(void)rightItemClicked
{
    NSLog(@"item");
    [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"dkitem.png"]];
    
    NSArray* stringArray=[NSArray arrayWithObjects:@"全部图片",@"推荐图片",@"我喜欢的",@"推荐软件", nil];
    [PopoverView showPopoverAtPoint:CGPointMake(290, 60) inView:self.view withTitle:@"选项" withStringArray:stringArray delegate:self];
    
    
}
-(void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    NSLog(@"dismiss");
    [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"itemButton.png"]];
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
    CGFloat byte1,byte2,byte3,byte4;
    byte1=0;
    byte2=0;
    byte3=0;
    byte4=0;
    NSFileManager* manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:[[GlobalManager sharedManager] lastPath]]){
        byte1= [self folderSizeAtPath:[[GlobalManager sharedManager] lastPath]];
        NSLog(@"byte1:%f",byte1);
    }
    if ([manager fileExistsAtPath:[[GlobalManager sharedManager] hotPath]]){
        byte2= [self folderSizeAtPath:[[GlobalManager sharedManager] hotPath]];
        NSLog(@"byte2:%f",byte2);
    }
    if ([manager fileExistsAtPath:[[GlobalManager sharedManager] recommendPath]]){
        bytes= [self folderSizeAtPath:[[GlobalManager sharedManager] recommendPath]];
        NSLog(@"byte3:%f",byte3);
    }
    if ([manager fileExistsAtPath:[[GlobalManager sharedManager] favorPath]]){
        bytes= [self folderSizeAtPath:[[GlobalManager sharedManager] favorPath]];
        NSLog(@"byte4:%f",byte4);
    }
    bytes = byte1+byte2+byte3+byte4;
    NSLog(@"bytes:%f",bytes);
    [tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return itemDict.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* array=[itemDict objectForKey:[NSString stringWithFormat:@"%d",section]];
    return array.count;
}
-(UITableViewCell*)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[aTableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"id"]autorelease];
    }
    if (indexPath.section==0) {
        cell.detailTextLabel.text =[NSString stringWithFormat:@"%@M",[[NSString stringWithFormat:@"%f",bytes]  substringToIndex:[[NSString stringWithFormat:@"%f",bytes]rangeOfString:@"."].location+3]];
    }
    if(indexPath.section==1&&indexPath.row==1)
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//箭头
    NSArray* array=[itemDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
    if (indexPath.section==2) {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#d65763"];
    }
    cell.textLabel.text=[array objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0)
    {
        
        [[NSFileManager defaultManager] removeItemAtPath:[[GlobalManager sharedManager] lastPath] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[[GlobalManager sharedManager] recommendPath] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[[GlobalManager sharedManager] hotPath] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[[GlobalManager sharedManager] favorPath] error:nil];
        bytes=0;
        NSFileManager * filemanager=[NSFileManager defaultManager];
        if(![filemanager fileExistsAtPath:[[GlobalManager sharedManager] lastPath]])
        {
            [filemanager createDirectoryAtPath:[[GlobalManager sharedManager] lastPath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if(![filemanager fileExistsAtPath:[[GlobalManager sharedManager] hotPath]])
        {
            [filemanager createDirectoryAtPath:[[GlobalManager sharedManager] hotPath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if(![filemanager fileExistsAtPath:[[GlobalManager sharedManager] recommendPath]])
        {
            [filemanager createDirectoryAtPath:[[GlobalManager sharedManager] recommendPath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [aTableView reloadData];
    }
    else if(indexPath.section==1)
    {
        UIViewController* vc=nil;
        if(indexPath.row==0)
        {
            vc=[[[ToFriendVC alloc] init]autorelease];
            [APP shareInfoString:@"http://www.juemei.cc/app_down/" description:@"绝色美女最有视觉效果的美女图库手机应用点击下载www.juemei.cc/app_down/"];
        }
        else
        {
            vc=[[[RecSoftwareVC alloc] init]autorelease];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    else if (indexPath.section ==2)
    {
        NSURL *urlS = [[NSURL alloc]initWithString:@"http://www.juemei.cc/api/update.js"];
        //NSError *error = nil;
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData *ds = [NSData dataWithContentsOfURL:urlS];
        
        NSString *versionStr = [[NSString alloc]initWithData:ds encoding:enc];
        NSLog(@"stringVersion:%@",versionStr);
 
        
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
