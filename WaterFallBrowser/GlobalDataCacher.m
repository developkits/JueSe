//
//  GlobalDataCacher.m
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-18.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "GlobalDataCacher.h"


static GlobalDataCacher * c;
static dispatch_once_t onceToken;
@implementation GlobalDataCacher
+(id)sharedCacher
{
    dispatch_once(&onceToken, ^{
        c=[[GlobalDataCacher alloc] init];
        NSLog(@"cacher alloc");
    });
    return c;
}
-(id)init
{
    self=[super init];
    if(self)
    {
#if USE_NSCACHE
        cacher=[[NSCache alloc] init];
        [cacher setTotalCostLimit:TOTAL_COST_LIMIT*1024*1024];
        [cacher setEvictsObjectsWithDiscardedContent:NO];
        cacher.delegate=self;
#else
        cacher=[[NSMutableDictionary alloc] initWithCapacity:0];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCacher) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
#endif
    }
    return self;
}
#if !USE_NSCACHE
-(NSUInteger)cachedCount
{
    return [cacher count];
}
#endif
#if USE_NSCACHE
-(void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    NSLog(@"clear:%d",[obj length]);
}
#endif
-(void)setObject:(id)obj forKey:(NSString*)key cost:(NSUInteger)cost
{
#if USE_NSCACHE
    [cacher setObject:obj forKey:key cost:cost];
#else
    [cacher setObject:obj forKey:key];
#endif
}
-(id)objectForKey:(NSString*)key
{
    return [cacher objectForKey:key];
}
-(BOOL)existsObjectForKey:(NSString*)key
{
    id obj=[cacher objectForKey:key];
    if(obj)
        return YES;
    return NO;
}
-(void)printCachedData
{
   // NSLog(@"cachedData:%@",[[cacher objectEnumerator] ]);
    //NSLog(@"keys:%@",[cacher allKeys]);
    for(NSString* each in [cacher allKeys])
    {
        NSLog(@"key:%@,obj:%d",each,[[cacher objectForKey:each] length]);
    }
}
-(void)clearCacher
{
    [cacher removeAllObjects];
}
@end
