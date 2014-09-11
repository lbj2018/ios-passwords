//
//  DRKAccountStore.h
//  dPasswords
//
//  Created by zhou dengfeng derek on 25/7/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRKAccount.h"

#define PASSWORD_KEY @"PASSWORD_KEY"

@interface DRKAccountStore : NSObject

+ (instancetype)sharedStore;

- (NSArray *)getAllAccounts;
- (void)addAccountWithAccountName:(NSString *)accountName username:(NSString *)username encryptedPassword:(NSData *)encryptedPassword;
- (void)updateAccount:(DRKAccount *)account;
- (void)deleteAccount:(DRKAccount *)account;

- (void)changePassword:(NSString *)oldPassword toNewPassword:(NSString *)password;

- (NSData *)encryptPassword:(NSString *)password withKey:(NSString *)key;
- (NSString *)decryptPassword:(NSData *)encryptedPassword withKey:(NSString *)key;

@end
