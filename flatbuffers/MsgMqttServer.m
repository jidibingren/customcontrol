// automatically generated, do not modify !!!

#import "MsgMqttServer.h"

@implementation MsgMqttServer 

- (NSString *) host {

    _host = [self fb_getString:4 origin:_host];

    return _host;

}

- (void) add_host {

    [self fb_addString:_host voffset:4 offset:4];

    return ;

}

- (uint32_t) port {

    _port = [self fb_getUint32:6 origin:_port];

    return _port;

}

- (void) add_port {

    [self fb_addUint32:_port voffset:6 offset:8];

    return ;

}

- (NSString *) topic {

    _topic = [self fb_getString:8 origin:_topic];

    return _topic;

}

- (void) add_topic {

    [self fb_addString:_topic voffset:8 offset:12];

    return ;

}

- (NSString *) privateTopic {

    _privateTopic = [self fb_getString:10 origin:_privateTopic];

    return _privateTopic;

}

- (void) add_privateTopic {

    [self fb_addString:_privateTopic voffset:10 offset:16];

    return ;

}

- (uint32_t) time {

    _time = [self fb_getUint32:12 origin:_time];

    return _time;

}

- (void) add_time {

    [self fb_addUint32:_time voffset:12 offset:20];

    return ;

}

- (MsgMqttAuth *) auth {

    _auth = [self fb_getTable:14 origin:_auth className:[MsgMqttAuth class]];

    return _auth;

}

- (void) add_auth {

    [self fb_addTable:_auth voffset:14 offset:24];

    return ;

}

- (uint8_t) enable_mqtt {

    _enable_mqtt = [self fb_getUint8:16 origin:_enable_mqtt];

    return _enable_mqtt;

}

- (void) add_enable_mqtt {

    [self fb_addUint8:_enable_mqtt voffset:16 offset:28];

    return ;

}

- (uint8_t) enable_tls {

    _enable_tls = [self fb_getUint8:18 origin:_enable_tls];

    return _enable_tls;

}

- (void) add_enable_tls {

    [self fb_addUint8:_enable_tls voffset:18 offset:29];

    return ;

}

- (instancetype)init{

    if (self = [super init]) {

        bb_pos = 26;

        origin_size = 30+bb_pos;

        bb = [[FBMutableData alloc]initWithLength:origin_size];

        [bb setInt32:bb_pos offset:0];

        [bb setInt32:20 offset:bb_pos];

        [bb setInt16:20 offset:bb_pos-[bb getInt32:bb_pos]];

        [bb setInt16:30 offset:bb_pos-[bb getInt32:bb_pos]+2];

    }

    return self;

}

@end
