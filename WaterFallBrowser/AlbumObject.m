//
//  AlbumObject.m
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-15.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "AlbumObject.h"

@implementation AlbumObject
@synthesize clickCount,idTag,title;
@synthesize imageData;
@synthesize  imageURL;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if(self)
    {
        self.clickCount=[aDecoder decodeObjectForKey:@"clickCount"];
        self.idTag=[aDecoder decodeObjectForKey:@"idTag"];
        self.imageURL=[aDecoder decodeObjectForKey:@"imageURL"];
        self.title=[aDecoder decodeObjectForKey:@"title"];
        self.imageData=[aDecoder decodeObjectForKey:@"imageData"];
    }
    return self;
}
-(id)initWithAlbum:(AlbumObject*)aAlbum
{
    self=[super init];
    if(self)
    {
        self.clickCount=aAlbum.clickCount;
        self.idTag=aAlbum.idTag;
        self.imageURL=aAlbum.imageURL;
        self.imageData=aAlbum.imageData;
        self.title=aAlbum.title;
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:clickCount forKey:@"clickCount"];
    [aCoder encodeObject:idTag forKey:@"idTag"];
    [aCoder encodeObject:imageURL forKey:@"imageURL"];
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:imageData forKey:@"imageData"];
}
@end
