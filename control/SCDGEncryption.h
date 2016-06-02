//
//  SCDGEncryption.h
//  deigo
//
//  Created by SC on 16/5/25.
//  Copyright © 2016年 SC. All rights reserved.
//


@interface SCDGEncryption : NSObject

SCDG_DECLARE_SINGLETON()

/* you need one of the three settings
 * 1.the publickey file content to publicKey
 * 2.the publicKeyFileName
 * 3.rename your publicKeyFileName as rsa_public_key.pem
 */
@property (nonatomic, strong)NSString *publicKey;
@property (nonatomic, strong)NSString *publicKeyFileName;

- (NSData *) encryptWithData:(NSData *)content;
- (NSData *) encryptWithToData:(NSString *)content;
- (NSString *) encryptWithString:(NSString *)content;
- (NSString *) encryptToString:(NSData *)content;

@end
