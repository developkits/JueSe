//
//  GlobalDataCacher.h
//  WaterFallBrowser
//
//  Created by 伍 兵 on 14-2-18.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <Foundation/Foundation.h>


#define TOTAL_COST_LIMIT 20 //M
#define USE_NSCACHE 0
@interface GlobalDataCacher : NSObject<NSCacheDelegate>
{
   id cacher;
}
+(id)sharedCacher;
#if !USE_NSCACHE
-(NSUInteger)cachedCount;
#endif
-(void)setObject:(id)obj forKey:(NSString*)key cost:(NSUInteger)cost;
-(id)objectForKey:(NSString*)key;
-(BOOL)existsObjectForKey:(NSString*)key;
-(void)clearCacher;
-(void)printCachedData;
@end
