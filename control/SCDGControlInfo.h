//
//  SCDGControlInfo.h
//  deigo
//
//  Created by SC on 16/6/16.
//  Copyright © 2016年 SC. All rights reserved.
//

typedef NS_ENUM(uint8_t, SCDGControlType) {
    SCDGControlTypeEnable = 1,
    SCDGControlTypeCleanCache,
    SCDGControlTypeChangeUI,
    SCDGControlTypeChangeAPI,
};

typedef NS_ENUM(uint8_t, SCDGActionType) {
    SCDGActionTypeDefault = 0,
    SCDGActionType1,
    SCDGActionType2,
    SCDGActionType3,
    SCDGActionType4,
    
    SCDGActionTypeDisable = SCDGActionTypeDefault,
    SCDGActionTypeEnable  = SCDGActionType1,
    
    SCDGActionTypeLayout  = SCDGActionType1,
    SCDGActionTypeContent = SCDGActionType2,
    SCDGActionTypeTextColor        = SCDGActionType3,
    SCDGActionTypeBackgroundColor  = SCDGActionType4,
    
};


@interface SCDGControlInfo : RLMObject

@property (nonatomic, assign)uint64_t messageId;

@property (nonatomic, assign)uint8_t platform;

@property (nonatomic, strong)NSString *version;

@property (nonatomic, assign)uint8_t type;

@property (nonatomic, assign)uint8_t action;

@property (nonatomic, assign)uint32_t acceptorId;

@property (nonatomic, assign)uint64_t start;

@property (nonatomic, assign)uint64_t end;

@property (nonatomic, strong)NSString *payload;

@end
