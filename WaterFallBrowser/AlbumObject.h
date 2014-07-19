//
//  AlbumObject.h
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-15.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumObject : NSObject<NSCoding>
{
    NSString* clickCount;
    NSString* idTag;
    NSURL* imageURL;
    NSString* title;
    NSData* imageData;
}
@property(nonatomic,copy)NSString* clickCount;
@property(nonatomic,copy)NSString* idTag;
@property(nonatomic,copy)NSURL* imageURL;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSData* imageData;

-(id)initWithAlbum:(AlbumObject*)aAlbum;
@end
