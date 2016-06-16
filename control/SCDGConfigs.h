//
//  SCDGConfigs.h
//  deigo
//
//  Created by SC on 16/6/16.
//  Copyright © 2016年 SC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDGConfigs : NSObject

SCDG_DECLARE_SINGLETON()

- (void)addOrUpdateControlInfo:(SCDGControlInfo*)info callback:(void(^)())callback;

- (RLMResults<SCDGControlInfo *> *)getControlInfos:(uint32_t)acceptorId type:(uint8_t)type;

@end
