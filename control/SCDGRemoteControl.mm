//
//  SCDGRemoteControl.m
//  deigo
//
//  Created by SC on 16/5/11.
//  Copyright © 2016年 SC. All rights reserved.
//

#include <vector>
#include <iostream>
#include <arpa/inet.h>

#import "flatbuffers.h"
#import "flatbuffers_util.h"
#import "serverlogin_generated.h"
#import "server_msg_response_generated.h"
#import "server_message_generated.h"
#import "server_message_received_generated.h"

using namespace std;
using namespace Msg::Mqtt;
//using namespace Msg::Response;

#import "SCDGRemoteControl.h"
#import "MQTTClient.h"
#import "MQTTSessionManager.h"

#define kHost   @"192.168.1.65"
//#define kHost   @"192.168.1.106"
#define kPort   1883
#define kPortTLS   8883
#define kTopic  @"/MQTTKit/example"
#define kTopic2 @"/MQTTKit/test"
#define kClientID @"3190C243-F0DB-4264-80C1-4997102D7AD9"

#ifdef MQTTKIT
@interface SCDGRemoteControl()
@property (nonatomic, strong) MQTTClient *client;
#else
@interface SCDGRemoteControl()<MQTTSessionManagerDelegate>
@property (nonatomic, strong) MQTTSessionManager *manager;
#endif

@end

@implementation SCDGRemoteControl

SCDG_IMPLEMENT_SINGLETON()

- (instancetype)init{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)startupWithHost:(NSString *)host port:(NSInteger)port clientId:(NSString *)clientId user:(NSString *)user pass:(NSString*)pass {

    if (!self.manager) {
        self.manager = [[MQTTSessionManager alloc] init];
        self.manager.delegate = self;
        self.manager.subscriptions = @{
                                       kTopic : [NSNumber numberWithInt:MQTTQosLevelExactlyOnce],
                                       kTopic2 : [NSNumber numberWithInt:MQTTQosLevelExactlyOnce],
                                       };
        [self.manager connectTo:[SCDGUtils isValidStr:host] ? host : kHost
                           port: port >= 0 ? port : kPort
                                    tls:_enableTLS
                              keepalive:60
                                  clean:NO
                                   auth:YES
                                   user:user
                                   pass:pass
                              willTopic:kTopic
                                   will:[@"offline" dataUsingEncoding:NSUTF8StringEncoding]
                                willQos:MQTTQosLevelExactlyOnce
                         willRetainFlag:FALSE
                           withClientId:[SCDGUtils isValidStr:clientId] ? clientId : [SCDGUtils getUUID]];
//        MQTTSSLSecurityPolicy *securityPolicy = [MQTTSSLSecurityPolicy policyWithPinningMode:MQTTSSLPinningModeCertificate];
//        securityPolicy.allowInvalidCertificates = YES;
//        securityPolicy.validatesCertificateChain = NO;
//        securityPolicy.pinnedCertificates = [self defaultPinnedCertificates];
//        [self.manager connectTo:[SCDGUtils isValidStr:host] ? host : kHost
//                           port:kPortTLS
//                            tls:YES
//                      keepalive:60 clean:NO auth:NO user:nil pass:nil will:NO willTopic:nil willMsg:nil willQos:MQTTQosLevelExactlyOnce willRetainFlag:NO withClientId:[SCDGUtils isValidStr:clientId] ? clientId : kClientID securityPolicy:securityPolicy certificates:[self defaultPinnedCertificates]];
    } else {
        [self.manager connectToLast];
    }
    /*
     * MQTTCLient: observe the MQTTSessionManager's state to display the connection status
     */
    
    [self.manager addObserver:self
                   forKeyPath:@"state"
                      options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                      context:nil];
    
}

- (void)subscribeTopics:(NSArray< NSString*> *)topics{
    
    NSMutableDictionary *subscriptions = [NSMutableDictionary dictionaryWithDictionary:self.manager.subscriptions];
    
    for (NSString *topic in topics) {
        
        [subscriptions setObject:[NSNumber numberWithInt:MQTTQosLevelExactlyOnce] forKey:topic];
        
    }
    
    self.manager.subscriptions = subscriptions;
    
}

- (void)subscribeTopic:(NSString *)topic{
    
    if (![SCDGUtils isValidStr:topic]) {
        return;
    }
    
    NSMutableDictionary *subscriptions = [NSMutableDictionary dictionaryWithDictionary:self.manager.subscriptions];
        
    [subscriptions setObject:[NSNumber numberWithInt:MQTTQosLevelExactlyOnce] forKey:topic];
    
    self.manager.subscriptions = subscriptions;
}

- (void)unsubscribeTopic:(NSString *)topic{
    
    if (![SCDGUtils isValidStr:topic]) {
        return;
    }
    
    NSMutableDictionary *subscriptions = [NSMutableDictionary dictionaryWithDictionary:self.manager.subscriptions];
    
    [subscriptions removeObjectForKey:topic];
    
    self.manager.subscriptions = subscriptions;
}

- (UInt16)publish:(NSString *)topic data:(NSData *)data{
    
    return [self.manager sendData:[SCDGUtils isValidData:data] ? data : [@"join to chat" dataUsingEncoding:NSUTF8StringEncoding]
                            topic:[SCDGUtils isValidStr:topic] ? topic : kTopic
                              qos:MQTTQosLevelExactlyOnce
                           retain:FALSE];
}

- (void)stop{
    
    [self unsubscribeTopic:self.topic];
    [self unsubscribeTopic:self.privateTopic];
    [self unsubscribeTopic:self.upTopic];
    [self.manager disconnect];

}

#pragma mark - m

- (SCDGControlInfo *)controlInfoFrom:(MsgMessageContent*)message{
    
    SCDGControlInfo *temp = [[SCDGControlInfo alloc] init];
    temp.messageId = message.messageId;
    temp.platform = message.platform;
    temp.version = message.version;
    temp.type = message.type;
    temp.action = message.action;
    temp.acceptorId = message.acceptorId;
    temp.start = message.start;
    temp.end = message.end;
    temp.payload = message.payload;
    
    return temp;
}
- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained{
    
    if (self.type == SCDGRemoteControlCustom) {
        
        if (_handleMessage){
            
            _handleMessage(data, topic, retained);
            
        }
        
    }else{
        
        if ([FBTable verifier:data]) {
            
            MsgMessageContent *message = [MsgMessageContent getRootAs:data];
            
            SCDGCache *cache = [SCDGCache sharedInstance];
            if (message.messageId && [[SCDGUtils getCurrentVersionShort] compare:message.version options:NSNumericSearch] == 0) {
                
                if (![cache isCachedExecCommand:message.messageId]) {
                    
                    [cache cacheExecCommand:data commandId:message.messageId];
                    
                    SCDGControlInfo *controlInfo = [self controlInfoFrom:message];
                    [[SCDGConfigs sharedInstance] addOrUpdateControlInfo:controlInfo callback:^{
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:[SCDGUtils remoteControlNotifactionNameWith:message.acceptorId] object:controlInfo];
                        
                        if (_handleMessage){
                            
                            _handleMessage(controlInfo, topic, retained);
                            
                        }
                    }];
                    
                }else if ([cache isCachedUncompletedCommand:message.messageId]){
                    
//                    [self sendMessageReceivedToUpTopic:[NSString stringWithFormat:@"%llu", message.messageId] callback:nil];
                    [self sendMessageReceivedWithParams:@{@"mid":[NSString stringWithFormat:@"%llu", message.messageId]} callback:nil];
                    
                }
            }
        }
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    switch (self.manager.state) {
        case MQTTSessionManagerStateClosed:
            break;
        case MQTTSessionManagerStateClosing:
            break;
        case MQTTSessionManagerStateConnected:
            
            break;
        case MQTTSessionManagerStateConnecting:
            break;
        case MQTTSessionManagerStateError:
            break;
        case MQTTSessionManagerStateStarting:
        default:
            break;
    }
}

- (NSArray *)defaultPinnedCertificates {
    static NSArray *_defaultPinnedCertificates = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundle = [NSBundle mainBundle];
        NSArray *paths = [bundle pathsForResourcesOfType:@"crt" inDirectory:@"."];
        
        NSMutableArray *certificates = [NSMutableArray arrayWithCapacity:[paths count]];
        for (NSString *path in paths) {
            NSData *certificateData = [NSData dataWithContentsOfFile:path];
            [certificates addObject:certificateData];
        }
        
        _defaultPinnedCertificates = [[NSArray alloc] initWithArray:certificates];
    });
    
    return _defaultPinnedCertificates;
}

-(void)setDeviceToken:(NSString *)deviceToken{
    
    [SCDGUtils setUUID:deviceToken];
    
}

-(void)setPublicKey:(NSString *)publicKey{
    
    [[SCDGEncryption sharedInstance] setPublicKey:publicKey];
    
}

- (void)setPublicKeyFileName:(NSString *)publicKeyFileName{
    
    [[SCDGEncryption sharedInstance] setPublicKeyFileName:publicKeyFileName];
    
}

- (void)loginWithParams:(NSDictionary *)params callback:(void(^)(BOOL isSuccessed, id data))callback{
    
    __weak SCDGRemoteControl *wself = self;
    [SCDGHttpTool getWithURL:[NSString stringWithFormat:@"%@%@", _httpUrlPrefix ? _httpUrlPrefix : SCDG_BASEURL, SCDG_LOGIN_URL] params:params success:^(NSDictionary *data) {
        
        
        if (self.type == SCDGRemoteControlCustom) {
            
            
            if (callback) {
                
                callback(YES, data);
                
            }
            
            return ;
            
        }else{
            
            if (![FBTable verifier:(NSData*)data]) {
                
                if (callback) {
                    
                    callback(NO, nil);
                    
                }
                
                return ;
            }
            
            MsgMqttServer *info = [MsgMqttServer getRootAs:(NSData*)data];
            
            
//            uint64_t  host = info.host;
//            unsigned long int ip = ntohl(host);
//            in_addr subnetIp;
//            subnetIp.s_addr = ip & 0xffffffff;
            
//            NSString *ipAddr = [NSString stringWithUTF8String:inet_ntoa(subnetIp)];
            NSString *ipAddr = info.host;
            uint32_t  port = info.port;
            NSString *user = info.auth.user;
            NSString *pass = info.auth.pass;
            
            if ([SCDGUtils isValidStr:info.auth.device]) {
                
                self.clientId = info.auth.device;
                
            }
            
            if ([SCDGUtils isValidStr:info.topic]) {
                self.topic = info.topic;
            }
            
            if ([SCDGUtils isValidStr:info.privateTopic]) {
                self.privateTopic = info.privateTopic;
            }
            
            if (info.enable_mqtt == 1) {
                
                wself.enableTLS = info.enable_tls;
                [wself startupWithHost:ipAddr port:port clientId:self.clientId user:user pass:pass];
                [wself subscribeTopic:self.topic];
                [wself subscribeTopic:self.privateTopic];
                [wself subscribeTopic:self.upTopic];
                
                if (callback){
                    
                    callback(YES, data);
                    
                }
            }
        }

        
    } failure:^(NSError *error) {
        
        if (callback){
            
            callback(NO, nil);
            
        }
        
    }];
}

- (void)logout{
    
    [self stop];
    
    [SCDGHttpTool getWithURL:[NSString stringWithFormat:@"%@%@", _httpUrlPrefix ? _httpUrlPrefix : SCDG_BASEURL, SCDG_LOGOUT_URL] params:nil success:^(NSDictionary *data) {
        
        
        if ([FBTable verifier:(NSData*)data]) {
            
//            MsgResponseBody *response = [MsgResponseBody getRootAs:(NSData*)data];
            
        }
        
    } failure:nil];
}

- (void)sendMessageReceivedToUpTopic:(NSString *)mid callback:(void(^)(BOOL isSuccessed, NSString *mid))callback{
    
    if (self.upTopic) {
        
        MsgMessageReceived *received = [[MsgMessageReceived alloc]init];
        received.platform = 1;
        received.device = [SCDGUtils isValidStr:self.clientId] ? self.clientId : [SCDGUtils getUUID];
        received.messageId = (uint64_t)mid.longLongValue;
        
        if ([self publish:self.upTopic data:[received getData]]) {
            
            [[SCDGCache sharedInstance] removeFromUncompletedCacheBy:mid.longLongValue];
            
            if (callback) {
                callback(YES, mid);
            }
            
        }else{
            
            if (callback) {
                callback(NO, mid);
            }
            
        }
        
        return;
        
    }
}

- (void)sendMessageReceivedWithParams:(NSDictionary *)params callback:(void(^)(BOOL isSuccessed, NSString *mid))callback{
    
    [SCDGHttpTool getWithURL:[NSString stringWithFormat:@"%@%@", _httpUrlPrefix ? _httpUrlPrefix : SCDG_BASEURL, SCDG_RECEIVED_MSG_URL] params:params success:^(NSDictionary *data) {
        
        if ([FBTable verifier:(NSData*)data]) {
            
            MsgResponseBody *response = [MsgResponseBody getRootAs:(NSData*)data];
            
            
            [[SCDGCache sharedInstance] removeFromUncompletedCacheBy:[params[@"mid"] longLongValue]];
            
            if (callback) {
                
                callback((BOOL)response.status, params[@"mid"]);
                
            }
            
        }else{
            
            if (callback) {
                
                callback(NO, params[@"mid"]);
                
            }
            
        }
        
    } failure:^(NSError *error) {
        
        if (callback){
            
            callback(NO, nil);
            
        }
        
    }];
}

- (void)requestOfflineMessageWithParams:(NSDictionary *)params callback:(void(^)(BOOL isSuccessed, id data))callback{
    
    [SCDGHttpTool getWithURL:[NSString stringWithFormat:@"%@%@", _httpUrlPrefix ? _httpUrlPrefix : SCDG_BASEURL, SCDG_OFFLINE_MSG_URL] params:params success:^(NSDictionary *data) {
        
        if (callback){
            
            callback(YES, (NSData*)data);
            
        }
        
    } failure:^(NSError *error) {
        
        if (callback){
            
            callback(NO, nil);
            
        }
        
    }];
}

@end
