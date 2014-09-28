//
//  DRKHttpRequestStore.h
//  dPasswords
//
//  Created by zhou dengfeng derek on 25/9/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRKUser.h"

@interface DRKHttpRequestStore : NSObject

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(NSError *error, DRKUser *obj))handler;
+ (void)registerWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(NSError *error))handler;
+ (void)addAccountWithAccountId:(NSString *)accountId accountName:(NSString *)accountName userName:(NSString *)userName password:(NSString *)password forUserId:(int)userId completion:(void(^)(NSError *error, NSDate *obj))handler;
+ (void)loadAccountsForUserId:(int)userId completion:(void(^)(NSError *error))handler;
+ (void)deleteAccountWithAccountId:(NSString *)accountId forUserId:(int)userId completion:(void(^)(NSError *error))handler;
+ (void)changeAccountWithAccountId:(NSString *)accountId accountName:(NSString *)accountName userName:(NSString *)userName password:(NSString *)password forUserId:(int)userId completion:(void(^)(NSError *error))handler;

@end
