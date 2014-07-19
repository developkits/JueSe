//
//  AppDelegate.m
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-14.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "AppDelegate.h"

#import <ShareSDK/ShareSDK.h>
#import "ShareSDKDemoMoreViewController.h"
#import <RennSDK/RennSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <Pinterest/Pinterest.h>
#import "YXApi.h"

#import "ViewController.h"
#import "FavoriteVC.h"
#import "AlbumViewController.h"
#import "SettingsVC.h"

#import "OfflineModeVC.h"
@implementation AppDelegate

-(void)changeIndicatorPosition:(NSNotification*)notify
{
    CGSize size=[[UIScreen mainScreen] bounds].size;
    NSInteger orientation=[[[notify userInfo] objectForKey:@"UIApplicationStatusBarOrientationUserInfoKey"] integerValue];

    if(indicator)
    {
        if(orientation==3)
        {
            indicator.center=CGPointMake(80, size.height/2);
        }
        else if(orientation==4)
        {
            indicator.center=CGPointMake(size.width-80, size.height/2);
        }
        else
        {
            indicator.center=CGPointMake(size.width/2, size.height-80);
        }
    }
}
-(void)showIndicatorAtMiddle:(BOOL)isMid;
{   CGSize size=[[UIScreen mainScreen] bounds].size;
    if(!indicator)
    {
        indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.color=MAIN_COLOR;
        indicator.hidesWhenStopped=YES;
        [self.window addSubview:indicator];
    }
     indicator.center=CGPointMake(size.width/2, isMid?size.height/2:(size.height-80));
    [indicator startAnimating];
}
-(void)hideIndicator
{
    if(indicator)
        [indicator stopAnimating];
}
-(void)selectTabBar
{
    tabBarVC.tabBar.tintColor=MAIN_COLOR;
}
-(void)deselectTabBar
{
    tabBarVC.tabBar.tintColor=[UIColor grayColor];
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}
-(void)hideTabBar
{
    tabBarVC.tabBar.hidden=YES;
}
-(void)showTabBar
{
    tabBarVC.tabBar.hidden=NO;
}
-(void)tabBarSwitchToItem:(NSInteger)item
{
    [tabBarVC  setSelectedIndex:item];
}

-(void)launchInit
{
    NSDictionary* attriDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:26],UITextAttributeFont, nil];
    
    NSDictionary* attriDict1=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],UITextAttributeFont,[UIColor whiteColor],UITextAttributeTextColor,nil];
    NSDictionary* attriDict2=[NSDictionary dictionaryWithObjectsAndKeys:MAIN_COLOR,UITextAttributeTextColor,nil];
    
    GlobalManager* m=[GlobalManager sharedManager];
   
    
    
    if([[GlobalManager sharedManager] mode] ==kAppModeOffline)
    {
        if(!offNav)
        {
            OfflineModeVC* offVC=[[[OfflineModeVC alloc] initWithNeedItem:YES]autorelease];
            //offVC.dataCachePath=[m lastPath];
            //offVC.albumImgDataCachePath=[m recommendPath];
            offVC.needDetectSelect=YES;
            offNav=[[UINavigationController alloc] initWithRootViewController:offVC];
        
            offNav.navigationBar.tintColor=MAIN_COLOR;
            UIImage* navBackImage=[UIImage imageNamed:@"headerBack.png"];
            [offNav.navigationBar setBackgroundImage:navBackImage forBarMetrics:UIBarMetricsDefault];
            
            
            [offNav.navigationBar setTitleTextAttributes:attriDict];
    //        UITabBarController* offTabBar=[[UITabBarController alloc] init];
    //        offTabBar.viewControllers=[NSArray arrayWithObject:nav];
    //        offTabBar.tabBar.hidden=YES;
        }
        
        self.window.rootViewController=offNav;
    }
    else
    {
        if(!tabBarVC)
        {
   
            NSString* lastURL=[NSURL URLWithString:LAST_URL];
            NSString* hotURL=[NSURL URLWithString:HOT_URL];
            NSString* reccommendURL=[NSURL URLWithString:RECOMMEND_URL];
        
        
        //视图
        ViewController* lastVC=[[ViewController alloc] initWithNeedItem:YES];
            lastVC.title=@"最新";
            
            lastVC.webDataURLString=lastURL;
            lastVC.dataCachePath=[m lastPath];
            lastVC.needDetectSelect=YES;
            lastVC.albumSubURLCachePath=[m hotPath];
            lastVC.albumImgDataCachePath=[m recommendPath];
        ViewController* hotVC=[[ViewController alloc] initWithNeedItem:YES];
            hotVC.title=@"热榜";
            hotVC.webDataURLString=hotURL;
            hotVC.dataCachePath=[m lastPath];
            hotVC.needDetectSelect=YES;
            hotVC.albumSubURLCachePath=[m hotPath];
            hotVC.albumImgDataCachePath=[m recommendPath];
       
        ViewController* recVC=[[ViewController alloc] initWithNeedItem:NO];
            recVC.title=@"推荐";
            recVC.webDataURLString=reccommendURL;
            recVC.dataCachePath=[m lastPath];
            recVC.needDetectSelect=YES;
            recVC.albumSubURLCachePath=[m hotPath];
            recVC.albumImgDataCachePath=[m recommendPath];
        FavoriteVC* likeVC=[[FavoriteVC alloc] initWithNeedItem:YES];
            likeVC.title=@"喜欢";
            likeVC.needDetectSelect=YES;
//            likeVC.dataCachePath=[m lastPath];
//            likeVC.albumImgDataCachePath=[m recommendPath];
//            likeVC.albumSubURLCachePath=[m hotPath];
        SettingsVC* moreVC=[[SettingsVC alloc] init];
            moreVC.title=@"更多";

        UINavigationController* nav1=[[[UINavigationController alloc] initWithRootViewController:lastVC] autorelease];
        nav1.navigationBar.tintColor=MAIN_COLOR;
        nav1.navigationController.navigationBar.frame=CGRectMake(0, 0, 320, 80);
        [nav1.navigationBar setTitleTextAttributes:attriDict];
        UINavigationController* nav2=[[[UINavigationController alloc] initWithRootViewController:hotVC] autorelease];
        nav2.navigationBar.tintColor=MAIN_COLOR;
        [nav2.navigationBar setTitleTextAttributes:attriDict];
        UINavigationController* nav3=[[[UINavigationController alloc] initWithRootViewController:recVC] autorelease];
        nav3.navigationBar.tintColor=MAIN_COLOR;
        [nav3.navigationBar setTitleTextAttributes:attriDict];
        UINavigationController* nav4=[[[UINavigationController alloc] initWithRootViewController:likeVC] autorelease];
        nav4.navigationBar.tintColor=MAIN_COLOR;
        [nav4.navigationBar setTitleTextAttributes:attriDict];
        UINavigationController* nav5=[[[UINavigationController alloc] initWithRootViewController:moreVC] autorelease];
        nav5.navigationBar.tintColor=MAIN_COLOR;
        [nav5.navigationBar setTitleTextAttributes:attriDict];
        
        //导航条背景
        UIImage* navBackImage=[UIImage imageNamed:@"headerBack.png"];
        [nav1.navigationBar setBackgroundImage:navBackImage forBarMetrics:UIBarMetricsDefault];
        [nav2.navigationBar setBackgroundImage:navBackImage forBarMetrics:UIBarMetricsDefault];
        [nav3.navigationBar setBackgroundImage:navBackImage forBarMetrics:UIBarMetricsDefault];
        [nav4.navigationBar setBackgroundImage:navBackImage forBarMetrics:UIBarMetricsDefault];
        [nav5.navigationBar setBackgroundImage:navBackImage forBarMetrics:UIBarMetricsDefault];
        
        //tabBar设置
        tabBarVC=[[UITabBarController alloc] init];
        tabBarVC.viewControllers=[NSArray arrayWithObjects:nav1,nav2,nav4,nav5, nil];
        tabBarVC.tabBar.backgroundImage=[UIImage imageNamed:@"tabBack.png"];
        tabBarVC.tabBar.tintColor=MAIN_COLOR;
        tabBarVC.tabBar.barTintColor=[UIColor whiteColor];
        
    
        
        //绑定按钮和视图
       // UITabBarItem* item1= [[UITabBarItem alloc] initWithTitle:@"最新" image:[UIImage imageNamed:@"zx.png"] tag:1];
        UITabBarItem* item1= [[UITabBarItem alloc] init];
        [item1 setTitle:@"最新"];
        item1.tag =1;
        [item1 setFinishedSelectedImage:[UIImage imageNamed:@"zx.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"zx_2.png"]];
        [item1 setTitleTextAttributes:attriDict1 forState:UIControlStateNormal];
        [item1 setTitleTextAttributes:attriDict2 forState:UIControlStateSelected];
            
        UITabBarItem* item2= [[UITabBarItem alloc] init];
        [item2 setTitle:@"热榜"];
        item2.tag =2;
        [item2 setFinishedSelectedImage:[UIImage imageNamed:@"rb.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"rb_2.png"]];
        [item2 setTitleTextAttributes:attriDict1 forState:UIControlStateNormal];
        [item2 setTitleTextAttributes:attriDict2 forState:UIControlStateSelected];
            
        UITabBarItem* item3= [[UITabBarItem alloc] init];
        [item3 setTitle:@"推荐"];
        item3.tag =3;
        [item3 setFinishedSelectedImage:[UIImage imageNamed:@"rb.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tj.png"]];
        [item3 setTitleTextAttributes:attriDict1 forState:UIControlStateNormal];
        [item3 setTitleTextAttributes:attriDict2 forState:UIControlStateSelected];
        
        UITabBarItem* item4= [[UITabBarItem alloc] init];
        [item4 setTitle:@"喜欢"];
        item2.tag =4;
        [item4 setFinishedSelectedImage:[UIImage imageNamed:@"xh.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"xh_2.png"]];
        [item4 setTitleTextAttributes:attriDict1 forState:UIControlStateNormal];
        [item4 setTitleTextAttributes:attriDict2 forState:UIControlStateSelected];
        
        UITabBarItem* item5= [[UITabBarItem alloc] init];
        [item5 setTitle:@"更多"];
        item5.tag =5;
        [item5 setFinishedSelectedImage:[UIImage imageNamed:@"gd.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"gd_2.png"]];
        [item5 setTitleTextAttributes:attriDict1 forState:UIControlStateNormal];
        [item5 setTitleTextAttributes:attriDict2 forState:UIControlStateSelected];
//        UITabBarItem* item3= [[UITabBarItem alloc] initWithTitle:@"推荐" image:[UIImage imageNamed:@"tj.png"] tag:3];
//        UITabBarItem* item4= [[UITabBarItem alloc] initWithTitle:@"喜欢" image:[UIImage imageNamed:@"xh.png"] tag:4];
//        UITabBarItem* item5= [[UITabBarItem alloc] initWithTitle:@"更多" image:[UIImage imageNamed:@"gd.png"] tag:5];
            
            
        
        lastVC.tabBarItem=item1;
        hotVC.tabBarItem=item2;
        recVC.tabBarItem=item3;
        likeVC.tabBarItem=item4;
        moreVC.tabBarItem=item5;
        
        [item1 release];
        [item2 release];
        [item3 release];
        [item4 release];
        [item5 release];
        
        [lastVC release];
        [hotVC release];
        [recVC release];
        [likeVC release];
        [moreVC release];
        
    }
    
    self.window.rootViewController =tabBarVC;
        
    }
    
        
    [self.window makeKeyAndVisible];
}
- (void)initializePlat
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WeiboApi class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接Facebook应用以使用相关功能，此应用需要引用FacebookConnection.framework
     https://developers.facebook.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectFacebookWithAppKey:@"107704292745179"
                              appSecret:@"38053202e1a5fe26c80c753071f0b573"];
    
    /**
     连接Twitter应用以使用相关功能，此应用需要引用TwitterConnection.framework
     https://dev.twitter.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectTwitterWithConsumerKey:@"mnTGqtXk0TYMXYTN7qUxg"
                             consumerSecret:@"ROkFqr8c3m1HXqS3rm3TJ0WkAJuwBOSaWhPbZ9Ojuc"
                                redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接Google+应用以使用相关功能，此应用需要引用GooglePlusConnection.framework、GooglePlus.framework和GoogleOpenSource.framework库
     https://code.google.com/apis/console上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectGooglePlusWithClientId:@"232554794995.apps.googleusercontent.com"
                               clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
                                redirectUri:@"http://localhost"
                                  signInCls:[GPPSignIn class]
                                   shareCls:[GPPShare class]];
    
    /**
     连接人人网应用以使用相关功能，此应用需要引用RenRenConnection.framework
     http://dev.renren.com上注册人人网开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectRenRenWithAppId:@"226427"
                              appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                           appSecret:@"f29df781abdd4f49beca5a2194676ca4"
                   renrenClientClass:[RennClient class]];
    
    /**
     连接开心网应用以使用相关功能，此应用需要引用KaiXinConnection.framework
     http://open.kaixin001.com上注册开心网开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectKaiXinWithAppKey:@"358443394194887cee81ff5890870c7c"
                            appSecret:@"da32179d859c016169f66d90b6db2a23"
                          redirectUri:@"http://www.sharesdk.cn/"];
    
    /**
     连接易信应用以使用相关功能，此应用需要引用YiXinConnection.framework
     http://open.yixin.im/上注册易信开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectYiXinWithAppId:@"yx0d9a9f9088ea44d78680f3274da1765f"
                           yixinCls:[YXApi class]];
    
    //连接邮件
    [ShareSDK connectMail];
    
    //连接打印
    [ShareSDK connectAirPrint];
    
    //连接拷贝
    [ShareSDK connectCopy];
    
    /**
     连接搜狐微博应用以使用相关功能，此应用需要引用SohuWeiboConnection.framework
     http://open.t.sohu.com上注册搜狐微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSohuWeiboWithConsumerKey:@"SAfmTG1blxZY3HztESWx"
                               consumerSecret:@"yfTZf)!rVwh*3dqQuVJVsUL37!F)!yS9S!Orcsij"
                                  redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接网易微博应用以使用相关功能，此应用需要引用T163WeiboConnection.framework
     http://open.t.163.com上注册网易微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connect163WeiboWithAppKey:@"T5EI7BXe13vfyDuy"
                              appSecret:@"gZxwyNOvjFYpxwwlnuizHRRtBRZ2lV1j"
                            redirectUri:@"http://www.shareSDK.cn"];
    
    
    /**
     连接豆瓣应用以使用相关功能，此应用需要引用DouBanConnection.framework
     http://developers.douban.com上注册豆瓣社区应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectDoubanWithAppKey:@"02e2cbe5ca06de5908a863b15e149b0b"
                            appSecret:@"9f1e7b4f71304f2f"
                          redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接印象笔记应用以使用相关功能，此应用需要引用EverNoteConnection.framework
     http://dev.yinxiang.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectEvernoteWithType:SSEverNoteTypeSandbox
                          consumerKey:@"sharesdk-7807"
                       consumerSecret:@"d05bf86993836004"];
    
    /**
     连接LinkedIn应用以使用相关功能，此应用需要引用LinkedInConnection.framework库
     https://www.linkedin.com/secure/developer上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectLinkedInWithApiKey:@"ejo5ibkye3vo"
                              secretKey:@"cC7B2jpxITqPLZ5M"
                            redirectUri:@"http://sharesdk.cn"];
    
    /**
     连接Pinterest应用以使用相关功能，此应用需要引用Pinterest.framework库
     http://developers.pinterest.com/上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectPinterestWithClientId:@"1432928"
                              pinterestCls:[Pinterest class]];
    
    /**
     连接Pocket应用以使用相关功能，此应用需要引用PocketConnection.framework
     http://getpocket.com/developer/上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectPocketWithConsumerKey:@"11496-de7c8c5eb25b2c9fcdc2b627"
                               redirectUri:@"pocketapp1234"];
    
    /**
     连接Instapaper应用以使用相关功能，此应用需要引用InstapaperConnection.framework
     http://www.instapaper.com/main/request_oauth_consumer_token上注册Instapaper应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectInstapaperWithAppKey:@"4rDJORmcOcSAZL1YpqGHRI605xUvrLbOhkJ07yO0wWrYrc61FA"
                                appSecret:@"GNr1GespOQbrm8nvd7rlUsyRQsIo3boIbMguAl9gfpdL0aKZWe"];
    /**
     连接有道云笔记应用以使用相关功能，此应用需要引用YouDaoNoteConnection.framework
     http://note.youdao.com/open/developguide.html#app上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectYouDaoNoteWithConsumerKey:@"dcde25dca105bcc36884ed4534dab940"
                                consumerSecret:@"d98217b4020e7f1874263795f44838fe"
                                   redirectUri:@"http://www.sharesdk.cn/"];
    
    /**
     连接搜狐随身看应用以使用相关功能，此应用需要引用SohuConnection.framework
     https://open.sohu.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSohuKanWithAppKey:@"e16680a815134504b746c86e08a19db0"
                             appSecret:@"b8eec53707c3976efc91614dd16ef81c"
                           redirectUri:@"http://sharesdk.cn"];
    
    
    /**
     链接Flickr,此平台需要引用FlickrConnection.framework框架。
     http://www.flickr.com/services/apps/create/上注册应用，并将相关信息填写以下字段。
     **/
    [ShareSDK connectFlickrWithApiKey:@"33d833ee6b6fca49943363282dd313dd"
                            apiSecret:@"3a2c5b42a8fbb8bb"];
    
    /**
     链接Tumblr,此平台需要引用TumblrConnection.framework框架
     http://www.tumblr.com/oauth/apps上注册应用，并将相关信息填写以下字段。
     **/
    [ShareSDK connectTumblrWithConsumerKey:@"2QUXqO9fcgGdtGG1FcvML6ZunIQzAEL8xY6hIaxdJnDti2DYwM"
                            consumerSecret:@"3Rt0sPFj7u2g39mEVB3IBpOzKnM3JnTtxX2bao2JKk4VV1gtNo"
                               callbackUrl:@"http://sharesdk.cn"];
    
    /**
     连接Dropbox应用以使用相关功能，此应用需要引用DropboxConnection.framework库
     https://www.dropbox.com/developers/apps上注册应用，并将相关信息填写以下字段。
     **/
    [ShareSDK connectDropboxWithAppKey:@"7janx53ilz11gbs"
                             appSecret:@"c1hpx5fz6tzkm32"];
    
    /**
     连接Instagram应用以使用相关功能，此应用需要引用InstagramConnection.framework库
     http://instagram.com/developer/clients/register/上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectInstagramWithClientId:@"ff68e3216b4f4f989121aa1c2962d058"
                              clientSecret:@"1b2e82f110264869b3505c3fe34e31a1"
                               redirectUri:@"http://sharesdk.cn"];
    
    /**
     连接VKontakte应用以使用相关功能，此应用需要引用VKontakteConnection.framework库
     http://vk.com/editapp?act=create上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectVKontakteWithAppKey:@"3921561"
                               secretKey:@"6Qf883ukLDyz4OBepYF1"];
}

/**
 *	@brief	托管模式下的初始化平台
 */
- (void)initializePlatForTrusteeship
{
    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
    [ShareSDK importQQClass:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    //导入人人网需要的外部库类型,如果不需要人人网SSO可以不调用此方法
    [ShareSDK importRenRenClass:[RennClient class]];
    
    //导入腾讯微博需要的外部库类型，如果不需要腾讯微博SSO可以不调用此方法
    [ShareSDK importTencentWeiboClass:[WeiboApi class]];
    
    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK importWeChatClass:[WXApi class]];
    
    //导入Google+需要的外部库类型，如果不需要Google＋分享可以不调用此方法
    [ShareSDK importGooglePlusClass:[GPPSignIn class]
                         shareClass:[GPPShare class]];
    
    //导入Pinterest需要的外部库类型，如果不需要Pinterest分享可以不调用此方法
    [ShareSDK importPinterestClass:[Pinterest class]];
    
    //导入易信需要的外部库类型，如果不需要易信分享可以不调用此方法
    [ShareSDK importYiXinClass:[YXApi class]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    _viewDelegate = [[AGViewDelegate alloc] init];
    
    [ShareSDK registerApp:@"iosv1101"];
    
    //如果使用服务中配置的app信息，请把初始化代码改为下面的初始化方法。
    //    [ShareSDK registerApp:@"iosv1101" useAppTrusteeship:YES];
    [self initializePlat];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeIndicatorPosition:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
   //侦听网络状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //hostReach = [[Reachability  reachabilityForLocalWiFi] retain];
    //hostReach=[[Reachability reachabilityForInternetConnection] retain];
    hostReach=[[Reachability reachabilityWithHostName:@"www.juemei.cc"] retain];
    [hostReach startNotifier];
    
    return YES;
}
-(void)reachabilityChanged:(NSNotification*)notify
{
    Reachability * reachability=[notify object];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    //BOOL connectionRequired = [reachability connectionRequired];
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"no reach!");
            [[GlobalManager sharedManager] setMode:kAppModeOffline];
            break;
        }
            
        case ReachableViaWWAN:
        {
             NSLog(@"3g!");
             [[GlobalManager sharedManager] setMode:kAppModeOnline];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"wifi!");
             [[GlobalManager sharedManager] setMode:kAppModeOnline];
            break;
        }
    }
    
    [self launchInit];//启动界面
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"will resign active");
    [[GlobalManager sharedManager]  archiveFavoriteArray];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"did enter back");
    //[[GlobalManager sharedManager]  archiveFavoriteArray];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"will enter fore");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"did become active");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    NSMutableArray *authList = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()]];
    if (authList == nil)
    {
        authList = [NSMutableArray array];
    }
    
    NSString *platName = nil;
    NSInteger plat = [[[notif userInfo] objectForKey:SSK_PLAT] integerValue];
    switch (plat)
    {
        case ShareTypeSinaWeibo:
            platName = @"新浪微博";
            break;
        case ShareType163Weibo:
            platName = @"网易微博";
            break;
        case ShareTypeDouBan:
            platName = @"豆瓣";
            break;
        case ShareTypeFacebook:
            platName = @"Facebook";
            break;
        case ShareTypeKaixin:
            platName = @"开心网";
            break;
        case ShareTypeQQSpace:
            platName = @"QQ空间";
            break;
        case ShareTypeRenren:
            platName = @"人人网";
            break;
        case ShareTypeSohuWeibo:
            platName = @"搜狐微博";
            break;
        case ShareTypeTencentWeibo:
            platName = @"腾讯微博";
            break;
        case ShareTypeTwitter:
            platName = @"Twitter";
            break;
        case ShareTypeInstapaper:
            platName = @"Instapaper";
            break;
        case ShareTypeYouDaoNote:
            platName = @"有道云笔记";
            break;
        case ShareTypeGooglePlus:
            platName = @"Google+";
            break;
        case ShareTypeLinkedIn:
            platName = @"LinkedIn";
            break;
        default:
            platName = @"未知";
    }
    
    id<ISSPlatformUser> userInfo = [[notif userInfo] objectForKey:SSK_USER_INFO];
    BOOL hasExists = NO;
    for (int i = 0; i < [authList count]; i++)
    {
        NSMutableDictionary *item = [authList objectAtIndex:i];
        ShareType type = [[item objectForKey:@"type"] integerValue];
        if (type == plat)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            hasExists = YES;
            break;
        }
    }
    
    if (!hasExists)
    {
        NSDictionary *newItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 platName,
                                 @"title",
                                 [NSNumber numberWithInteger:plat],
                                 @"type",
                                 [userInfo nickname],
                                 @"username",
                                 nil];
        [authList addObject:newItem];
    }
    
    [authList writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
}
-(void)shareInfoString:(NSString *)url  description:(NSString *)str
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:IMAGE_NAME ofType:IMAGE_EXT];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:str
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:url
                                          description:str
                                            mediaType:SSPublishContentMediaTypeNews];
    
    ///////////////////////
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
    {
        //定制人人网信息
        [publishContent addRenRenUnitWithName:@"Hello 人人网"
                                  description:INHERIT_VALUE
                                          url:INHERIT_VALUE
                                      message:INHERIT_VALUE
                                        image:INHERIT_VALUE
                                      caption:nil];
    }
    //定制QQ空间信息
    {
        [publishContent addQQSpaceUnitWithTitle:@"Hello QQ空间"
                                            url:INHERIT_VALUE
                                           site:nil
                                        fromUrl:nil
                                        comment:INHERIT_VALUE
                                        summary:INHERIT_VALUE
                                          image:INHERIT_VALUE
                                           type:INHERIT_VALUE
                                        playUrl:nil
                                           nswb:nil];
    }
    
    //定制微信好友信息
    {
        [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                             content:INHERIT_VALUE
                                               title:@"Hello 微信好友!"
                                                 url:INHERIT_VALUE
                                          thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
                                               image:INHERIT_VALUE
                                        musicFileUrl:nil
                                             extInfo:nil
                                            fileData:nil
                                        emoticonData:nil];
    }
    //定制微信朋友圈信息
    {
        [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeMusic]
                                              content:INHERIT_VALUE
                                                title:@"Hello 微信朋友圈!"
                                                  url:@"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4BDA0E4B88DE698AFE79C9FE6ADA3E79A84E5BFABE4B990222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696332342E74632E71712E636F6D2F586B303051563558484A645574315070536F4B7458796931667443755A68646C2F316F5A4465637734356375386355672B474B304964794E6A3770633447524A574C48795333383D2F3634363232332E6D34613F7569643D32333230303738313038266469723D423226663D312663743D3026636869643D222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31382E71716D757369632E71712E636F6D2F33303634363232332E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E5889BE980A0EFBC9AE5B08FE5B7A8E89B8B444E414C495645EFBC81E6BC94E594B1E4BC9AE5889BE7BAAAE5BD95E99FB3222C22736F6E675F4944223A3634363232332C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E4BA94E69C88E5A4A9222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D31354C5569396961495674593739786D436534456B5275696879366A702F674B65356E4D6E684178494C73484D6C6A307849634A454B394568572F4E3978464B316368316F37636848323568413D3D2F33303634363232332E6D70333F7569643D32333230303738313038266469723D423226663D302663743D3026636869643D2673747265616D5F706F733D38227D"
                                           thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
                                                image:INHERIT_VALUE
                                         musicFileUrl:@"http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3"
                                              extInfo:nil
                                             fileData:nil
                                         emoticonData:nil];
    }
    //定制微信收藏信息
    {
        [publishContent addWeixinFavUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:@"Hello 微信好友!"
                                             url:INHERIT_VALUE
                                      thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    }
    //定制QQ分享信息
    {
        [publishContent addQQUnitWithType:INHERIT_VALUE
                                  content:INHERIT_VALUE
                                    title:@"Hello QQ!"
                                      url:INHERIT_VALUE
                                    image:INHERIT_VALUE];
    }
    //定制邮件信息
    {
        [publishContent addMailUnitWithSubject:@"Hello Mail"
                                       content:INHERIT_VALUE
                                        isHTML:[NSNumber numberWithBool:YES]
                                   attachments:INHERIT_VALUE
                                            to:nil
                                            cc:nil
                                           bcc:nil];
    }
    //定制短信信息
    [publishContent addSMSUnitWithContent:str];
    
    //定制有道云笔记信息
    {
        [publishContent addYouDaoNoteUnitWithContent:INHERIT_VALUE
                                               title:@"Hello 有道云笔记"
                                              author:@"ShareSDK"
                                              source:nil
                                         attachments:INHERIT_VALUE];
    }
    //定制Instapaper信息
    {
        [publishContent addInstapaperContentWithUrl:INHERIT_VALUE
                                              title:@"Hello Instapaper"
                                        description:INHERIT_VALUE];
    }
    //定制搜狐随身看信息
    {
        [publishContent addSohuKanUnitWithUrl:INHERIT_VALUE];
    }
    //结束定制信息
    ////////////////////////
    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:self.viewDelegate];
    //在授权页面中添加关注官方微博
    /*
     [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
     [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
     SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
     [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
     SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
     nil]];
     */
    id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"内容分享" shareViewDelegate:self.viewDelegate];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

@end
