//
//  SCDGCache.m
//  deigo
//
//  Created by SC on 16/5/19.
//  Copyright © 2016年 SC. All rights reserved.
//

#import "SCDGCache.h"

@interface SCDGCache ()

@property (nonatomic, strong)YYCache *uncompletedCache;
@property (nonatomic, strong)YYCache *execCommandCache;
@property (nonatomic, strong)YYCache *configCache;

@end

@implementation SCDGCache

SCDG_IMPLEMENT_SINGLETON()
//+(instancetype)sharedInstance {
//    static id instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[self alloc] init];
//    });
//    return instance;
//}

- (instancetype)init{
    
    if (self = [super init]){
        
        self.uncompletedCache = [YYCache cacheWithName:@"SCDGUncompletedCache"];
        
        self.execCommandCache = [YYCache cacheWithName:@"SCDGExecCommandCache"];
        
        self.configCache = [YYCache cacheWithName:@"SCDGConfigCache"];
        
    }
    
    return self;
}

- (void)cacheExecCommand:(id)object commandId:(uint64_t)commandId{
    
    [self.execCommandCache setObject:object forKey:[NSString stringWithFormat:@"%llu", commandId]];
    
}

- (BOOL)isCachedExecCommand:(uint64_t)commandId{
    
    return [self.execCommandCache containsObjectForKey:[NSString stringWithFormat:@"%llu", commandId]];
    
}

- (id)cachedExecCommand:(uint64_t)commandId{
    
    return [self.execCommandCache objectForKey:[NSString stringWithFormat:@"%llu", commandId]];
    
}

- (void)removeFromExecCommandCacheBy:(uint64_t)commandId{
    
    [self.execCommandCache removeObjectForKey:[NSString stringWithFormat:@"%llu", commandId]];
    
}

- (void)cacheUncompletedCommand:(id)object commandId:(uint64_t)commandId{
    
    [self.uncompletedCache setObject:object forKey:[NSString stringWithFormat:@"%llu", commandId]];
    
}

- (BOOL)isCachedUncompletedCommand:(uint64_t)commandId{
    
    return [self.uncompletedCache containsObjectForKey:[NSString stringWithFormat:@"%llu", commandId]];
    
}

- (id)cachedUncompletedCommand:(uint64_t)commandId{
    
    return [self.uncompletedCache objectForKey:[NSString stringWithFormat:@"%llu", commandId]];
    
}

- (void)removeFromUncompletedCacheBy:(uint64_t)commandId{
    
    [self.uncompletedCache removeObjectForKey:[NSString stringWithFormat:@"%llu", commandId]];
    
}

- (void)cacheConfig:(id)object moduleId:(uint64_t)moduleId{
    
    [self.configCache setObject:object forKey:[NSString stringWithFormat:@"%llu", moduleId]];
    
}

- (void)removeFromConfigCacheBy:(uint64_t)commandId{
    
    [self.configCache removeObjectForKey:[NSString stringWithFormat:@"%llu", commandId]];
    
}

- (void)cleanExecCommandCache{
    
    [self.execCommandCache removeAllObjects];
    
}

- (void)cleanUncompletedCache{
    
    [self.uncompletedCache removeAllObjects];
    
}

- (void)cleanConfigCache{
    
    [self.configCache removeAllObjects];
    
}

- (void)cleanAll{
    
    [self cleanExecCommandCache];
    
    [self cleanUncompletedCache];
    
    [self cleanConfigCache];
    
}

@end
