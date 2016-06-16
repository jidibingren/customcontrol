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

@property (nonatomic, strong)NSString *primaryId;

@property (nonatomic, assign)long long messageId;

@property (nonatomic, assign)int platform;

@property (nonatomic, strong)NSString *version;

@property (nonatomic, assign)int type;

@property (nonatomic, assign)int action;

@property (nonatomic, assign)int acceptorId;

@property (nonatomic, assign)long long start;

@property (nonatomic, assign)long long end;

@property (nonatomic, strong)NSString *payload;

@end
