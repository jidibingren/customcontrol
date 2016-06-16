//
//  ViewController.m
//  deigo
//
//  Created by SC on 16/5/11.
//  Copyright © 2016年 SC. All rights reserved.
//

#include <vector>
#include <iostream>
#include <arpa/inet.h>
#import "ViewController.h"
//#include "flatbuffers/util.h"
//#include "serverlogin_generated.h"
//
//#include "monster_generated.h"
//
//
//using namespace std;
//using namespace Mqtt;
//using namespace MyGame::Sample;
////using namespace ;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [SCDGHttpTool postWithURL:SCDG_LOGIN_URL params:nil success:^(NSDictionary *json) {
//        
////        auto obj2 = GetMonster((uint8_t*)[(NSData*)json bytes]);
////        
////        cout << obj2->pos()->x() << endl;
////        cout << obj2->pos()->y() << endl;
////        cout << obj2->pos()->z() << endl;
////        cout << obj2->mana() << endl;
////        cout << obj2->hp() << endl;
////        cout << obj2->name()->c_str() << endl;
////        cout << obj2->inventory()->Data() << endl;
////        //    for (int i = 0; i < 12; i++){
////        ////        cout << obj2->inventory()->data()[i] << endl;
////        //        printf("%d",obj2->inventory()->Data()[i]);
////        //    }
////        cout << obj2->weapons()->Get(0)->name()->c_str() << endl;
////        cout << obj2->weapons()->Get(0)->damage() << endl;
////        cout << obj2->weapons()->Get(1)->name()->c_str() << endl;
////        cout << obj2->weapons()->Get(1)->damage() << endl;
////        cout << ((Weapon *)obj2->equipped())->name()->c_str() << endl;
////        cout << ((Weapon *)obj2->equipped())->damage() << endl;
////        cout << obj2->color() << endl;
//        
//        auto obj2 = GetServer((uint8_t*)[(NSData*)json bytes]);
//        
//        cout << obj2->host() << endl;
//        cout << obj2->port() << endl;
//        cout << obj2->topic()->c_str() << endl;
//        cout << obj2->auth()->user()->c_str() << endl;
//        cout << obj2->auth()->pass()->c_str() << endl;
//        
//        unsigned long int ip = ntohl(obj2->host());
//        in_addr subnetIp;
//        subnetIp.s_addr = ip & 0xffffffff;
//        
//        NSString *ipAddr = [NSString stringWithUTF8String:inet_ntoa(subnetIp)];
//        NSInteger port = obj2->port();
//        NSString *topic = [NSString stringWithUTF8String:obj2->topic()->c_str()];
//        NSString *user  = [NSString stringWithUTF8String:obj2->auth()->user()->c_str()];
//        NSString *pass  = [NSString stringWithUTF8String:obj2->auth()->pass()->c_str()];
//        
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:ipAddr forKey:@"ipAddr"];
//        [userDefaults setInteger:port forKey:@"port"];
//        [userDefaults setObject:topic forKey:@"topic"];
//        [userDefaults setObject:user forKey:@"user"];
//        [userDefaults setObject:pass forKey:@"pass"];
//        
//        [userDefaults synchronize];
//        
//        [[SCDGRemoteControl sharedInstance] startupWithHost:ipAddr port:port clientId:nil user:user pass:pass];
//        [[SCDGRemoteControl sharedInstance] subscribeTopic:topic];
//        
//    } failure:^(NSError *error) {
//        ;
//    }];
    
    [SCDGRemoteControl sharedInstance].httpUrlPrefix = @"http://api.msg.yiliangche.cn";
//    [SCDGRemoteControl sharedInstance].httpUrlPrefix = @"http://192.168.1.230";
//    [SCDGRemoteControl sharedInstance].httpUrlPrefix = @"http://192.168.1.102";
    
    [[SCDGRemoteControl sharedInstance] loginWithParams:nil callback:^(BOOL isSuccessed, NSData *data) {
        ;
    }];
    
    [SCDGRemoteControl sharedInstance].handleMessage = ^(MsgMessageContent *data, NSString *topic, BOOL retained){
        
        NSString *dataString = [[NSString alloc] initWithData:[[data getByteBuffer] data] encoding:NSUTF8StringEncoding];
        NSLog(@"received data %@", dataString);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SCDGUtils alert:dataString];
        });
        
    };
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 200, 100, 100)];
    
    [btn addTarget:self action:@selector(publishMsg) forControlEvents:UIControlEventTouchUpInside];
    
    btn.backgroundColor = [UIColor purpleColor];
    
    [self.view addSubview:btn];
    
    SCDGLabel *label = [[SCDGLabel alloc]initWithFrame:CGRectMake(100, 400, 200, 40)];
    label.textColor = [UIColor blackColor];
    label.acceptorId = 0x10001;
    [self.view addSubview:label];
    
    MsgMessageContent *message = [MsgMessageContent new];
    message.messageId = 11111111;
    message.type = 3;
    message.action = 2;
    message.acceptorId = 0x10001;
    message.payload = @"hello";
    [[SCDGConfigs sharedInstance] addOrUpdateControlInfo:message callback:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[SCDGUtils remoteControlNotifactionNameWith:message.acceptorId] object:message];
    }];
    message = [MsgMessageContent new];
    message.messageId = 11111111;
    message.type = 3;
    message.action = 3;
    message.acceptorId = 0x10001;
    message.payload = @"1bca7f";
    [[SCDGConfigs sharedInstance] addOrUpdateControlInfo:message callback:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[SCDGUtils remoteControlNotifactionNameWith:message.acceptorId] object:message];
    }];
    message = [MsgMessageContent new];
    message.messageId = 11111111;
    message.type = 3;
    message.action = 4;
    message.acceptorId = 0x10001;
    message.payload = @"7fa6ff";
    [[SCDGConfigs sharedInstance] addOrUpdateControlInfo:message callback:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[SCDGUtils remoteControlNotifactionNameWith:message.acceptorId] object:message];
    }];
}

- (void)publishMsg{
    
    [[SCDGRemoteControl sharedInstance] sendMessageReceivedWithParams:@{@"mid" : @"111"} callback:^(BOOL isSuccessed, NSString *mid) {
        
        if  (isSuccessed == YES){
         
            [[SCDGCache sharedInstance] removeFromUncompletedCacheBy:[@"111" longLongValue]];
            
        }
    }];
    
    return;
    
    [[SCDGRemoteControl sharedInstance] publish:[SCDGRemoteControl sharedInstance].topic data:[@"hello deigo" dataUsingEncoding:NSUTF8StringEncoding]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
