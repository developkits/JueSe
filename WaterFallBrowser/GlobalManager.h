//
//  GlobalManager.h
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-15.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kAppModeOnline,
    kAppModeOffline
}AppMode;

@interface GlobalManager : NSObject
{
    NSMutableArray * favorArray;
    NSOperationQueue * downloadTaskQueue;
    AppMode  mode;
    
}
@property(nonatomic,retain) NSOperationQueue* downloadTaskQueue;
@property(nonatomic,retain) NSString* lastPath;
@property(nonatomic,retain) NSString* hotPath;
@property(nonatomic,retain) NSString* recommendPath;
@property(nonatomic,retain) NSMutableArray* favorArray;
@property(nonatomic,retain) NSString* favorPath;
@property(nonatomic,assign) AppMode mode;

+(id)sharedManager;
-(void)addAlbumToFavorite:(NSString*)albumID;
-(void)removeAlbumFromFavorite:(NSString*)albumID;
-(void)archiveFavoriteArray;
@end
