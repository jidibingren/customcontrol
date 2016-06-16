// automatically generated, do not modify !!!

#import "FBTable.h"
#import "MsgMqttAuth.h"


@interface MsgMqttServer : FBTable 

@property (nonatomic, strong)NSString *host;

@property (nonatomic, assign)uint32_t port;

@property (nonatomic, strong)NSString *topic;

@property (nonatomic, strong)NSString *privateTopic;

@property (nonatomic, assign)uint32_t time;

@property (nonatomic, strong)MsgMqttAuth *auth;

@property (nonatomic, assign)uint8_t enable_mqtt;

@property (nonatomic, assign)uint8_t enable_tls;

@end
