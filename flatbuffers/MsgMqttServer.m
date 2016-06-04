// automatically generated, do not modify !!!

#import "MsgMqttServer.h"

@implementation MsgMqttServer 

- (uint64_t) host {

    _host = [self fb_getUint64:4 origin:_host];

    return _host;

}

- (void) add_host {

    [self fb_addUint64:_host voffset:4 offset:4];

    return ;

}

- (uint32_t) port {

    _port = [self fb_getUint32:6 origin:_port];

    return _port;

}

- (void) add_port {

    [self fb_addUint32:_port voffset:6 offset:12];

    return ;

}

- (NSString *) topic {

    _topic = [self fb_getString:8 origin:_topic];

    return _topic;

}

- (void) add_topic {

    [self fb_addString:_topic voffset:8 offset:16];

    return ;

}

- (uint32_t) time {

    _time = [self fb_getUint32:10 origin:_time];

    return _time;

}

- (void) add_time {

    [self fb_addUint32:_time voffset:10 offset:20];

    return ;

}

- (MsgMqttAuth *) auth {

    _auth = [self fb_getTable:12 origin:_auth className:[MsgMqttAuth class]];

    return _auth;

}

- (void) add_auth {

    [self fb_addTable:_auth voffset:12 offset:24];

    return ;

}

- (NSString *) privateTopic {

    _privateTopic = [self fb_getString:14 origin:_privateTopic];

    return _privateTopic;

}

- (void) add_privateTopic {

    [self fb_addString:_privateTopic voffset:14 offset:28];

    return ;

}

- (NSString *) upTopic {

    _upTopic = [self fb_getString:16 origin:_upTopic];

    return _upTopic;

}

- (void) add_upTopic {

    [self fb_addString:_upTopic voffset:16 offset:32];

    return ;

}

- (instancetype)init{

    if (self = [super init]) {

        bb_pos = 24;

        origin_size = 36+bb_pos;

        bb = [[FBMutableData alloc]initWithLength:origin_size];

        [bb setInt32:bb_pos offset:0];

        [bb setInt32:18 offset:bb_pos];

        [bb setInt16:18 offset:bb_pos-[bb getInt32:bb_pos]];

        [bb setInt16:36 offset:bb_pos-[bb getInt32:bb_pos]+2];

    }

    return self;

}

@end
