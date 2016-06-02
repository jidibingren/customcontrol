//
//  SCDGSign.h
//  deigo
//
//  Created by SC on 16/5/25.
//  Copyright © 2016年 SC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDGSign : NSObject

SCDG_DECLARE_SINGLETON()


- (NSString *) md5String:(NSString *)str ;
- (NSString *) md5LowercaseStr:(NSString*)str;
- (NSString *) md5Data:(NSData *)data;

@end
