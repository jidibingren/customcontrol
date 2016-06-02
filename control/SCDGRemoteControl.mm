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
#import "ViewController.h"

#import "flatbuffers.h"
#import "flatbuffers_util.h"
#import "serverlogin_generated.h"
#import "server_msg_response_generated.h"
#import "server_message_generated.h"

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
                                    tls:NO
                              keepalive:60
                                  clean:NO
                                   auth:YES
                                   user:user
                                   pass:pass
                              willTopic:kTopic
                                   will:[@"offline" dataUsingEncoding:NSUTF8StringEncoding]
                                willQos:MQTTQosLevelExactlyOnce
                         willRetainFlag:FALSE
                           withClientId:[SCDGUtils isValidStr:clientId] ? clientId : kClientID];
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

    [self.manager disconnect];

}

#pragma mark - m
- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained{
    
    
    if (_handleMessage){
        
        _handleMessage(data, topic, retained);
        
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

- (void)loginWithParams:(NSDictionary *)params callback:(void(^)(BOOL isSuccessed, NSData *data))callback{
    
    [SCDGHttpTool postWithURL:[NSString stringWithFormat:@"%@%@", _httpUrlPrefix ? _httpUrlPrefix : SCDG_BASEURL, SCDG_LOGIN_URL] params:params success:^(NSDictionary *data) {
        
        flatbuffers::Verifier *verifier = new flatbuffers::Verifier((uint8_t *)[(NSData*)data bytes], [(NSData*)data length]);
        
        if (!VerifyServerBuffer(*verifier)) {
            
            if (callback) {
                
                callback(NO, nil);
                
            }
            
            return ;
        }
        
//        MsgMqttServer *info = [MsgMqttServer getRootAs:[[FBMutableData alloc]initWithData:(NSData*)data]];
//        
//        
//        uint64_t  host = info.host;
//        unsigned long int ip = ntohl(host);
//        in_addr subnetIp;
//        subnetIp.s_addr = ip & 0xffffffff;
//        
//        NSString *ipAddr = [NSString stringWithUTF8String:inet_ntoa(subnetIp)];
//        uint32_t  port = info.port;
//        NSString *topic = info.topic;
//        NSString *user = info.auth.user;
//        NSString *pass = info.auth.pass;
        
        
        auto obj2 = GetServer((uint8_t*)[(NSData*)data bytes]);
        
        cout << obj2->host() << endl;
        cout << obj2->port() << endl;
        cout << obj2->topic()->c_str() << endl;
        cout << obj2->auth()->user()->c_str() << endl;
        cout << obj2->auth()->pass()->c_str() << endl;
        
        unsigned long int ip = ntohl(obj2->host());
        in_addr subnetIp;
        subnetIp.s_addr = ip & 0xffffffff;
        
        NSString *ipAddr = [NSString stringWithUTF8String:inet_ntoa(subnetIp)];
        NSInteger port = obj2->port();
        NSString *user  = [NSString stringWithUTF8String:obj2->auth()->user()->c_str()];
        NSString *pass  = [NSString stringWithUTF8String:obj2->auth()->pass()->c_str()];
        self.topic = [NSString stringWithUTF8String:obj2->topic()->c_str()];
        
        if (obj2->auth()->device() != 0) {
            
            self.clientId = [NSString stringWithFormat:@"%lld", obj2->auth()->device()];
            
        }
        
        if (obj2->topic() && obj2->topic()->Length() > 0) {
            self.topic = [NSString stringWithUTF8String:obj2->topic()->c_str()];
        }
        
        if (obj2->privateTopic() && obj2->privateTopic()->Length() > 0) {
            self.privateTopic = [NSString stringWithUTF8String:obj2->privateTopic()->c_str()];
        }
        
        if (obj2->upTopic() && obj2->upTopic()->Length() > 0) {
            self.upTopic = [NSString stringWithUTF8String:obj2->upTopic()->c_str()];
        }

        
        
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:ipAddr forKey:@"ipAddr"];
//        [userDefaults setInteger:port forKey:@"port"];
//        [userDefaults setObject:topic forKey:@"topic"];
//        [userDefaults setObject:user forKey:@"user"];
//        [userDefaults setObject:pass forKey:@"pass"];
        
//        [userDefaults synchronize];
        
        [[SCDGRemoteControl sharedInstance] startupWithHost:ipAddr port:port clientId:nil user:user pass:pass];
        [[SCDGRemoteControl sharedInstance] subscribeTopic:self.topic];
        
        if (callback){
            
            callback(YES, (NSData*)data);
            
        }
        
    } failure:^(NSError *error) {
        
        if (callback){
            
            callback(NO, nil);
            
        }
        
    }];
}

- (void)sendMessageReceivedToUpTopic:(NSString *)mid callback:(void(^)(BOOL isSuccessed, NSString *mid))callback{
    
    if (self.upTopic) {
        
        flatbuffers::FlatBufferBuilder builder;
        auto message = builder.CreateString([mid UTF8String]);
        uint8_t status = 1;
        
        // table
        auto mloc = Msg::Response::CreateBody(builder, status, message);
        builder.Finish(mloc);
        
        char* ptr = (char*)builder.GetBufferPointer();
        uint64_t size = builder.GetSize();
        
        if ([self publish:self.upTopic data:[NSData dataWithBytes:ptr length:(NSInteger)size]]) {
            
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
        
        flatbuffers::Verifier *verifier = new flatbuffers::Verifier((uint8_t *)[(NSData*)data bytes], [(NSData*)data length]);
        
        if (callback) {
            
            if (Msg::Response::VerifyBodyBuffer(*verifier)){
                
                auto response = Msg::Response::GetBody((uint8_t*)[(NSData*)data bytes]);
                
                callback(response->status() == 1 ? YES : NO, params[@"mid"]);
                
            }else{
                
                callback(NO, params[@"mid"]);
                
            }

        }
    } failure:^(NSError *error) {
        
        if (callback){
            
            callback(NO, nil);
            
        }
        
    }];
}

- (void)requestOfflineMessageWithParams:(NSDictionary *)params callback:(void(^)(BOOL isSuccessed, NSData *data))callback{
    
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
