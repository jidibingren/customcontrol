//
//  SCDGRemoteControl.h
//  deigo
//
//  Created by SC on 16/5/11.
//  Copyright © 2016年 SC. All rights reserved.
//


@interface SCDGRemoteControl : NSObject

@property (nonatomic, strong) NSString *httpUrlPrefix;
@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *topic;
@property (nonatomic, strong) NSString *privateTopic;
@property (nonatomic, strong) NSString *upTopic;

@property (nonatomic, strong) void(^handleMessage)(NSData *data, NSString *topic, BOOL retained);

SCDG_DECLARE_SINGLETON()

- (void)loginWithParams:(NSDictionary *)params callback:(void(^)(BOOL isSuccessed, NSData *data))callback;

- (void)sendMessageReceivedWithParams:(NSDictionary *)params callback:(void(^)(BOOL isSuccessed, NSString *mid))callback;

- (void)sendMessageReceivedToUpTopic:(NSString *)mid callback:(void(^)(BOOL isSuccessed, NSString *mid))callback;

- (void)requestOfflineMessageWithParams:(NSDictionary *)params callback:(void(^)(BOOL isSuccessed, NSData *data))callback;

- (void)startupWithHost:(NSString *)host port:(NSInteger)port clientId:(NSString *)clientId user:(NSString *)user pass:(NSString*)pass;

- (void)subscribeTopic:(NSString *)topic;

- (void)unsubscribeTopic:(NSString *)topic;

- (void)subscribeTopics:(NSArray< NSString*> *)topics;

- (UInt16)publish:(NSString *)topic data:(NSData *)data;

- (void)stop;

@end
