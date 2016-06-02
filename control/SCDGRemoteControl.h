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
@property (nonatomic, strong) NSString *deviceToken;

/* you need to set one of the three settings
 * 1.the publickey file content to publicKey
 * 2.the publicKeyFileName
 * 3.rename your publicKeyFileName as rsa_public_key.pem
 */
@property (nonatomic, strong)NSString *publicKey;
@property (nonatomic, strong)NSString *publicKeyFileName;

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
