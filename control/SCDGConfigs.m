//
//  SCDGConfigs.m
//  deigo
//
//  Created by SC on 16/6/16.
//  Copyright © 2016年 SC. All rights reserved.
//

#import "SCDGConfigs.h"

@interface SCDGConfigs ()

@property (nonatomic, strong)RLMRealm *realm;

@end

@implementation SCDGConfigs

SCDG_IMPLEMENT_SINGLETON()

- (instancetype)init{
    
    if (self = [super init]) {
        self.realm = [RLMRealm realmWithURL:[NSURL fileURLWithPath:[SCDGUtils pathInDocuments:@"SCDGConfigs.realm"]]];
    }
    
    return self;
}

- (void)addOrUpdateControlInfo:(SCDGControlInfo*)info callback:(void(^)())callback{
    
    __weak RLMRealm *wrealm = self.realm;
    dispatch_async(dispatch_queue_create("background", 0), ^{
        
        RLMResults<SCDGControlInfo *> *puppies = [SCDGControlInfo objectsWhere:[NSString stringWithFormat:@"type = %u AND action = %u AND acceptorId = %u",info.type, info.action, info.acceptorId]];
        
        if (puppies.count > 0) {
            SCDGControlInfo *temp = [puppies firstObject];
            
            [wrealm beginWriteTransaction];
            temp.messageId = info.messageId;
            temp.platform = info.platform;
            temp.version = info.version;
            temp.type = info.type;
            temp.action = info.action;
            temp.acceptorId = info.acceptorId;
            temp.start = info.start;
            temp.end = info.end;
            temp.payload = info.payload;
            [wrealm commitWriteTransaction];
            
        }else{
            
            [wrealm beginWriteTransaction];
            [wrealm addObject:info];
            [wrealm commitWriteTransaction];
        }
        
        if (callback) {
            callback();
        }
    });
    
}

- (RLMResults<SCDGControlInfo *> *)getControlInfos:(uint32_t)acceptorId type:(uint8_t)type{
    
    RLMResults<SCDGControlInfo *> *puppies = [SCDGControlInfo objectsWhere:[NSString stringWithFormat:@"type = %u AND acceptorId = %u", type, acceptorId]];
    
    return puppies;
}

@end
