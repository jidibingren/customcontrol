//
//  SCDGCache.h
//  deigo
//
//  Created by SC on 16/5/19.
//  Copyright © 2016年 SC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDGCache : NSObject

SCDG_DECLARE_SINGLETON()
//+(instancetype)sharedInstance;

//-(instancetype) init __attribute__((unavailable("init not available")));

- (void)cacheExecCommand:(id)object commandId:(uint64_t)commandId;

- (void)removeFromExecCommandCacheBy:(uint64_t)commandId;

- (void)cacheUncompletedCommand:(id)object commandId:(uint64_t)commandId;

- (void)removeFromUncompletedCacheBy:(uint64_t)commandId;

- (void)cacheConfig:(id)object moduleId:(uint64_t)moduleId;

- (void)removeFromConfigCacheBy:(uint64_t)commandId;

- (void)cleanExecCommandCache;

- (void)cleanUncompletedCache;

- (void)cleanConfigCache;

- (void)cleanAll;

@end
