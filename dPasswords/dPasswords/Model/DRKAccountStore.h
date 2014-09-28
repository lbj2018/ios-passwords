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

- (BOOL)isExistForAccountId:(NSString *)accountId;
- (NSArray *)getAllAccounts;
- (void)addAccountWithAccountId:(NSString *)accountId accountName:(NSString *)accountName username:(NSString *)username encryptedPassword:(NSString *)encryptedPassword dateCreated:(NSDate *)dateCreated;
- (void)updateAccount:(DRKAccount *)account;
- (void)deleteAccount:(DRKAccount *)account;

- (void)changePassword:(NSString *)oldPassword toNewPassword:(NSString *)password;

- (NSString *)encryptPassword:(NSString *)password withKey:(NSString *)key;
- (NSString *)decryptPassword:(NSString *)encryptedPassword withKey:(NSString *)key;

@end
