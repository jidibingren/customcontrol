// automatically generated, do not modify !!!

#import "MsgMqttAuth.h"

@implementation MsgMqttAuth 

- (NSString *) user {

    _user = [self fb_getString:4 origin:_user];

    return _user;

}

- (void) add_user {

    [self fb_addString:_user voffset:4 offset:4];

    return ;

}

- (NSString *) pass {

    _pass = [self fb_getString:6 origin:_pass];

    return _pass;

}

- (void) add_pass {

    [self fb_addString:_pass voffset:6 offset:8];

    return ;

}

- (NSString *) device {

    _device = [self fb_getString:8 origin:_device];

    return _device;

}

- (void) add_device {

    [self fb_addString:_device voffset:8 offset:12];

    return ;

}

- (instancetype)init{

    if (self = [super init]) {

        bb_pos = 16;

        origin_size = 16+bb_pos;

        bb = [[FBMutableData alloc]initWithLength:origin_size];

        [bb setInt32:bb_pos offset:0];

        [bb setInt32:10 offset:bb_pos];

        [bb setInt16:10 offset:bb_pos-[bb getInt32:bb_pos]];

        [bb setInt16:16 offset:bb_pos-[bb getInt32:bb_pos]+2];

    }

    return self;

}

@end
