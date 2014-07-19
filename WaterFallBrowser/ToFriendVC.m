//
//  ToFriendVC.m
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-21.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "ToFriendVC.h"

@interface ToFriendVC ()

@end

@implementation ToFriendVC

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
    self.view.backgroundColor=[UIColor yellowColor];
    
    
    
}

-(void)dealloc
{
    NSLog(@"ToFriendVC dealloc");
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
