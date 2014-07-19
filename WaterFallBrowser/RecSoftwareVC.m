//
//  RecSoftwareVC.m
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-21.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "RecSoftwareVC.h"

@interface RecSoftwareVC ()

@end

@implementation RecSoftwareVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=@"推荐软件";
    
    UIWebView *wVC = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
     [wVC loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString :@"http://www.t-tmie.com"]]];
    [self.view addSubview:wVC];
    self.view.backgroundColor=[UIColor blueColor];

}
-(void)dealloc
{
    NSLog(@"RecSoftWare dealloc");
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
