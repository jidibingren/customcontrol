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

@property (nonatomic, strong)NSURL *realmFilePath;

@end

@implementation SCDGConfigs

SCDG_IMPLEMENT_SINGLETON()

- (instancetype)init{
    
    if (self = [super init]) {
        NSString *realmFile = [SCDGUtils pathInDocuments:@"SCDGConfigs.realm"];
        self.realmFilePath = [NSURL fileURLWithPath:realmFile];
        self.realm = [RLMRealm realmWithURL:self.realmFilePath];
    }
    
    return self;
}

- (SCDGControlInfo *)controlInfoFrom:(MsgMessageContent*)message{
    
    SCDGControlInfo *temp = [[SCDGControlInfo alloc] init];
    temp.messageId  = (long long)message.messageId;
    temp.platform   = (int)message.platform;
    temp.version    = message.version;
    temp.type       = (int)message.type;
    temp.action     = (int)message.action;
    temp.acceptorId = (int)message.acceptorId;
    temp.start      = (long long)message.start;
    temp.end        = (long long)message.end;
    temp.payload    = message.payload;
    
    return temp;
}

- (uint64_t)stringToUint64:(NSString*)str{
    
    uint64_t temp = 0;
    for (NSUInteger i = str.length-1; i > 0; i--) {
        NSString *subStr = [str substringWithRange:NSMakeRange(i, 1)];
        if (i == str.length-1) {
            
            temp += subStr.intValue;
            
        }else{
            
            temp += subStr.intValue*10*(str.length-1-i);
            
        }
    }
    
    return temp;
}

- (MsgMessageContent *)messageFrom:(SCDGControlInfo*)info{
    
    MsgMessageContent *temp = [[MsgMessageContent alloc] init];
    
    temp.messageId  = (uint64_t)info.messageId;
    temp.platform   = (uint8_t)info.platform;
    temp.version    = info.version;
    temp.type       = (uint8_t)info.type;
    temp.action     = (uint8_t)info.action;
    temp.acceptorId = (uint32_t)info.acceptorId;
    temp.start      = (uint64_t)info.start;
    temp.end        = (uint64_t)info.end;
    temp.payload    = info.payload;
    
    return temp;
}

- (void)addOrUpdateControlInfo:(MsgMessageContent*)message callback:(void(^)())callback{
    
    SCDGControlInfo *info = [self controlInfoFrom:message];
    __weak SCDGConfigs *wself = self;
    dispatch_async(dispatch_queue_create("background", 0), ^{
        
        RLMRealm *wrealm = [RLMRealm realmWithURL:wself.realmFilePath];
        
        [wrealm beginWriteTransaction];
        [wrealm addOrUpdateObject:info];
        [wrealm commitWriteTransaction];
        
        if (callback) {
            callback();
        }
    });
    
}

- (NSArray<MsgMessageContent *> *)getControlInfos:(uint32_t)acceptorId type:(uint8_t)type{
    RLMRealm *wrealm = [RLMRealm realmWithURL:self.realmFilePath];
    RLMResults<SCDGControlInfo *> *puppies = [SCDGControlInfo objectsInRealm:wrealm where:[NSString stringWithFormat:@"type = %d AND acceptorId = %d", (int)type, (int)acceptorId]];
    NSMutableArray <MsgMessageContent *> *infoArray = [NSMutableArray new];
    for (NSUInteger i = 0; i < puppies.count; i++) {
        [infoArray addObject:[self messageFrom:[puppies objectAtIndex:i]]];
    }
    
    return (NSArray<MsgMessageContent*>*)infoArray;
}

- (NSArray<MsgMessageContent *> *)getControlInfos:(uint32_t)acceptorId{
    
    RLMRealm *wrealm = [RLMRealm realmWithURL:self.realmFilePath];
    
    RLMResults<SCDGControlInfo *> *puppies = [SCDGControlInfo objectsInRealm:wrealm where:[NSString stringWithFormat:@"acceptorId = %d", (int)acceptorId]];
    
    NSMutableArray <MsgMessageContent *> *infoArray = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < puppies.count; i++) {
        [infoArray addObject:[self messageFrom:[puppies objectAtIndex:i]]];
    }
    
    return (NSArray<MsgMessageContent*>*)infoArray;
}

- (NSArray<MsgMessageContent *> *)getAllSubControlInfos:(uint32_t)acceptorId{
    
    uint32_t maskMIN = acceptorId & 0xffff0000;
    
    uint32_t maskMAX = acceptorId | 0x0000ffff;
    
    RLMRealm *wrealm = [RLMRealm realmWithURL:self.realmFilePath];
    
    RLMResults<SCDGControlInfo *> *puppies = [SCDGControlInfo objectsInRealm:wrealm where:[NSString stringWithFormat:@"acceptorId >= %d AND acceptorId <= %d", (int)maskMIN, (int)maskMAX]];
    
    NSMutableArray <MsgMessageContent *> *infoArray = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < puppies.count; i++) {
        [infoArray addObject:[self messageFrom:[puppies objectAtIndex:i]]];
    }
    
    return (NSArray<MsgMessageContent*>*)infoArray;
}

@end
