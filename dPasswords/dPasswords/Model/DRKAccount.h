//
//  DRKAccount.h
//  dPasswords
//
//  Created by zhou dengfeng derek on 25/7/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRKAccount : NSObject

@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

- (instancetype)initWithCompanyName:(NSString *)companyName username:(NSString *)username password:(NSString *)password;

@end
