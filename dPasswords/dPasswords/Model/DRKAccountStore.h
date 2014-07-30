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

@property (nonatomic, strong, readonly) NSArray *accounts;

- (NSArray *)addAccount:(DRKAccount *)account;
- (NSArray *)deleteAccount:(DRKAccount *)account;

- (BOOL)saveAccounts;

@end
