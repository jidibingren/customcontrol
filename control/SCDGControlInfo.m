//
//  SCDGControlInfo.m
//  deigo
//
//  Created by SC on 16/6/16.
//  Copyright © 2016年 SC. All rights reserved.
//

#import "SCDGControlInfo.h"

@implementation SCDGControlInfo

+ (NSString *)primaryKey {
    
    return @"primaryId";
    
}

- (NSString *)primaryId {
    
    return [NSString stringWithFormat:@"%03d%03d%010d", self.type, self.action, self.acceptorId];
    
}

@end
