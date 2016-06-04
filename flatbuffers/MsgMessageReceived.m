// automatically generated, do not modify !!!

#import "MsgMessageReceived.h"

@implementation MsgMessageReceived 

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

- (NSString *) device {

    _device = [self fb_getString:8 origin:_device];

    return _device;

}

- (void) add_device {

    [self fb_addString:_device voffset:8 offset:13];

    return ;

}

- (instancetype)init{

    if (self = [super init]) {

        bb_pos = 16;

        origin_size = 17+bb_pos;

        bb = [[FBMutableData alloc]initWithLength:origin_size];

        [bb setInt32:bb_pos offset:0];

        [bb setInt32:10 offset:bb_pos];

        [bb setInt16:10 offset:bb_pos-[bb getInt32:bb_pos]];

        [bb setInt16:17 offset:bb_pos-[bb getInt32:bb_pos]+2];

    }

    return self;

}

@end
