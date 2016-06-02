//
//  SCDGSign.m
//  deigo
//
//  Created by SC on 16/5/25.
//  Copyright © 2016年 SC. All rights reserved.
//

#import "SCDGSign.h"

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation SCDGSign

SCDG_IMPLEMENT_SINGLETON()

- (instancetype)init{
    
    if (self = [super init]) {
        
        
    }
    
    return self;
}


- (NSString *) md5String:(NSString *)str {
    const char* strUTF8 = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(strUTF8, (CC_LONG)strlen(strUTF8), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    return ret;
}

- (NSString *) md5LowercaseStr:(NSString*)str
{
    return [[self md5String:str] lowercaseString];
}

- (NSString *) md5Data:(NSData *)data
{
    unsigned char result[16];
    CC_MD5(data.bytes, (CC_LONG)data.length, result ); // This is the md5 call
    return [[NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
//sha
-(NSString *) getShaString:(NSString *)source{
    assert(source != nil);
    const char * cstr = [source cStringUsingEncoding:NSUTF8StringEncoding];
    NSData * data = [NSData dataWithBytes:cstr length:[source length]];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH]={0};
    CC_SHA1([data bytes], (CC_LONG)[data length], digest);
    NSMutableString * output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH*2];
    for (int i=0; i<CC_SHA1_DIGEST_LENGTH; ++i) {
        [output appendFormat:@"%02X",digest[i]];
    }
    return output;
}

@end
