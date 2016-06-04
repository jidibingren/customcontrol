// automatically generated, do not modify !!!

#import "MsgResponseBody.h"

@implementation MsgResponseBody 

- (uint8_t) status {

    _status = [self fb_getUint8:4 origin:_status];

    return _status;

}

- (void) add_status {

    [self fb_addUint8:_status voffset:4 offset:4];

    return ;

}

- (NSString *) message {

    _message = [self fb_getString:6 origin:_message];

    return _message;

}

- (void) add_message {

    [self fb_addString:_message voffset:6 offset:5];

    return ;

}

- (instancetype)init{

    if (self = [super init]) {

        bb_pos = 14;

        origin_size = 9+bb_pos;

        bb = [[FBMutableData alloc]initWithLength:origin_size];

        [bb setInt32:bb_pos offset:0];

        [bb setInt32:8 offset:bb_pos];

        [bb setInt16:8 offset:bb_pos-[bb getInt32:bb_pos]];

        [bb setInt16:9 offset:bb_pos-[bb getInt32:bb_pos]+2];

    }

    return self;

}

@end
