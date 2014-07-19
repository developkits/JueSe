//
//  GlobalManager.m
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-15.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "GlobalManager.h"
static GlobalManager* m;
@implementation GlobalManager
@synthesize downloadTaskQueue;
@synthesize lastPath,hotPath,recommendPath;
@synthesize favorArray,favorPath;
@synthesize mode;
+(id)sharedManager
{
    if(!m)
    {
        m=[[GlobalManager alloc] init];
        
    }
    return m;
}
-(id)init
{
    self=[super init];
    if(self)
    {
        downloadTaskQueue=[[NSOperationQueue alloc] init];
        downloadTaskQueue.maxConcurrentOperationCount=1;
        
        self.lastPath=[NSHomeDirectory() stringByAppendingString:LAST_PATH];
        self.hotPath=[NSHomeDirectory() stringByAppendingString:HOT_PATH];
        self.recommendPath=[NSHomeDirectory() stringByAppendingString:RECOMMEND_PATH];
        self.favorPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/favor"];
        NSLog(@"lastPath:%@",lastPath);
        
        if([[NSFileManager defaultManager] fileExistsAtPath:self.favorPath])
            favorArray=[[NSMutableArray alloc] initWithArray:[self unarchiveFavoriteArray]];
        else
            favorArray=[[NSMutableArray alloc] initWithCapacity:0];
        
        NSLog(@"favorArray:%@",favorArray);
        
        //添加通知
        //[[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(addAlbum:) name:@"addAlbum" object:nil];
        //[[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(removeAlbum:) name:@"removeAlbum" object:nil];
        
    }
    return self;
}
-(void)addAlbumToFavorite:(NSString*)albumID
{
    [favorArray addObject:albumID];
}
-(void)removeAlbumFromFavorite:(NSString*)albumID
{
    [favorArray removeObject:albumID];
}
-(void)archiveFavoriteArray
{
    [NSKeyedArchiver archiveRootObject:favorArray toFile:self.favorPath];
}
-(NSArray*)unarchiveFavoriteArray
{
   NSArray* array= [NSKeyedUnarchiver unarchiveObjectWithFile:self.favorPath];
    return array;
}
@end
