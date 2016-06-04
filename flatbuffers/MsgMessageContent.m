// automatically generated, do not modify !!!

#import "MsgMessageContent.h"

@implementation MsgMessageContent 

- (uint64_t) messageId {

    _messageId = [self fb_getUint64:4 origin:_messageId];

    return _messageId;

}

- (void) add_messageId {

    [self fb_addUint64:_messageId voffset:4 offset:4];

    return ;

}

- (uint8_t) platform {

    _platform = [self fb_getUint8:6 origin:_platform];

    return _platform;

}

- (void) add_platform {

    [self fb_addUint8:_platform voffset:6 offset:12];

    return ;

}

- (NSString *) version {

    _version = [self fb_getString:8 origin:_version];

    return _version;

}

- (void) add_version {

    [self fb_addString:_version voffset:8 offset:13];

    return ;

}

- (uint8_t) type {

    _type = [self fb_getUint8:10 origin:_type];

    return _type;

}

- (void) add_type {

    [self fb_addUint8:_type voffset:10 offset:17];

    return ;

}

- (uint8_t) action {

    _action = [self fb_getUint8:12 origin:_action];

    return _action;

}

- (void) add_action {

    [self fb_addUint8:_action voffset:12 offset:18];

    return ;

}

- (uint32_t) acceptor_id {

    _acceptor_id = [self fb_getUint32:14 origin:_acceptor_id];

    return _acceptor_id;

}

- (void) add_acceptor_id {

    [self fb_addUint32:_acceptor_id voffset:14 offset:19];

    return ;

}

- (uint64_t) start {

    _start = [self fb_getUint64:16 origin:_start];

    return _start;

}

- (void) add_start {

    [self fb_addUint64:_start voffset:16 offset:23];

    return ;

}

- (uint64_t) end {

    _end = [self fb_getUint64:18 origin:_end];

    return _end;

}

- (void) add_end {

    [self fb_addUint64:_end voffset:18 offset:31];

    return ;

}

- (NSString *) payload {

    _payload = [self fb_getString:20 origin:_payload];

    return _payload;

}

- (void) add_payload {

    [self fb_addString:_payload voffset:20 offset:39];

    return ;

}

- (instancetype)init{

    if (self = [super init]) {

        bb_pos = 28;

        origin_size = 43+bb_pos;

        bb = [[FBMutableData alloc]initWithLength:origin_size];

        [bb setInt32:bb_pos offset:0];

        [bb setInt32:22 offset:bb_pos];

        [bb setInt16:22 offset:bb_pos-[bb getInt32:bb_pos]];

        [bb setInt16:43 offset:bb_pos-[bb getInt32:bb_pos]+2];

    }

    return self;

}

@end
