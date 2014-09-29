//
//  NSData+AES256.h
//  dPasswords
//
//  Created by zhou dengfeng derek on 29/9/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

@interface NSData (AES256)
+ (NSString *)AES256EncryptWithKey:(NSString *)key plainText:(NSString *)plain;        /*加密方法,参数需要加密的内容*/
+ (NSString *)AES256DecryptWithKey:(NSString *)key ciphertext:(NSString *)ciphertexts; /*解密方法，参数数密文*/
@end
