//
//  NSObject+SCDG.m
//  deigo
//
//  Created by SC on 16/6/15.
//  Copyright © 2016年 SC. All rights reserved.
//

#import "NSObject+SCDG.h"
#import <objc/runtime.h>

static void *NSObjectSCDGAcceptorIdKey = &NSObjectSCDGAcceptorIdKey;

@implementation NSObject (SCDG)

- (uint32_t)acceptorId
{
    NSNumber *temp = objc_getAssociatedObject(self, NSObjectSCDGAcceptorIdKey);
    
    if (temp) {
        return [temp unsignedIntValue];
    }
    
    return 0;
}

- (void)setAcceptorId:(uint32_t)acceptorId
{
    [self unsubscribeRemoteControl];
    
    objc_setAssociatedObject(self, NSObjectSCDGAcceptorIdKey, [NSNumber numberWithUnsignedInt:acceptorId], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self subscribeRemoteControlWithId:self.acceptorId];
}


- (NSArray<MsgMessageContent *> *)getControlInfos:(SCDGControlType)type{
    
    return [[SCDGConfigs sharedInstance] getControlInfos:self.acceptorId type:type];
    
}

- (NSArray<MsgMessageContent *> *)getControlInfos{
    
    return [[SCDGConfigs sharedInstance] getControlInfos:self.acceptorId];
    
}

- (NSArray<MsgMessageContent *> *)getAllSubControlInfos{
    
    return [[SCDGConfigs sharedInstance] getAllSubControlInfos:self.acceptorId];
    
}

- (NSString*) scdg_getNotifactionName:(uint32_t)acceptorId{
    return [NSString stringWithFormat:@"scdg_remote_control_%u", acceptorId];
}

- (void)subscribeRemoteControlWithId:(uint32_t)acceptorId{
    
    if (acceptorId > 0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotifications:) name:[self scdg_getNotifactionName:acceptorId] object:nil];
    }
    
}

- (void)unsubscribeRemoteControl{
    
    if (self.acceptorId > 0) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:[self scdg_getNotifactionName:self.acceptorId] object:nil];
    }
    
}

- (void)handleNotifications:(NSNotification*)noti{
    
    if (noti.object && [noti.object isKindOfClass:[MsgMessageContent class]]) {
        [self handleControlWith:noti.object];
    }
    
}

- (void)handleControlWith:(MsgMessageContent*)message{
    
}

@end
