//
//  SCDGEncryption.m
//  deigo
//
//  Created by SC on 16/5/25.
//  Copyright © 2016年 SC. All rights reserved.
//

#import "SCDGEncryption.h"

@interface SCDGEncryption ()

@property (nonatomic, strong)XRSA     *rsaEncryption;

@end

@implementation SCDGEncryption

SCDG_IMPLEMENT_SINGLETON()

- (instancetype)init{
    
    if (self = [super init]) {
        
        
        self.publicKey = [[NSString alloc]initWithData:[NSData dataWithContentsOfFile:[SCDGUtils resourcePathInBundle:@"rsa_public_key.pem"]] encoding:NSUTF8StringEncoding];
//        self.rsaEncryption = [[XRSA alloc]initWithPublicKey:[SCDGUtils resourcePathInBundle:@"rsa_public_key.pubkey"]];
        
    }
    
    return self;
}

#pragma mark - getters and setters

-(void)setPublicKeyFileName:(NSString *)publicKeyFileName{
    
    _publicKeyFileName = publicKeyFileName;
    
    _publicKey = [[NSString alloc]initWithData:[NSData dataWithContentsOfFile:[SCDGUtils resourcePathInBundle:publicKeyFileName]] encoding:NSUTF8StringEncoding];
    
}


- (NSData *) encryptWithData:(NSData *)content{
    
//    return [self.rsaEncryption encryptWithData:content];
    return [SCDGRSA encryptData:content publicKey:self.publicKey];
    
}

- (NSData *) encryptWithToData:(NSString *)content{
    
//    return [self.rsaEncryption encryptWithString:content];
    return [SCDGRSA encryptToData:content publicKey:self.publicKey];
    
}

- (NSString *) encryptWithString:(NSString *)content{
    
    //    return [self.rsaEncryption encryptWithString:content];
    return [SCDGRSA encryptString:content publicKey:self.publicKey];
    
}

- (NSString *) encryptToString:(NSData *)content{
    
//    return [self.rsaEncryption encryptToString:content];
    return [SCDGRSA encryptToString:content publicKey:self.publicKey];
    
}

@end
