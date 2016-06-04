// automatically generated, do not modify !!!

#import "FBTable.h"
#import "MsgMqttAuth.h"


@interface MsgMqttServer : FBTable 

@property (nonatomic, assign)uint64_t host;

@property (nonatomic, assign)uint32_t port;

@property (nonatomic, strong)NSString *topic;

@property (nonatomic, assign)uint32_t time;

@property (nonatomic, strong)MsgMqttAuth *auth;

@property (nonatomic, strong)NSString *privateTopic;

@property (nonatomic, strong)NSString *upTopic;

@end
