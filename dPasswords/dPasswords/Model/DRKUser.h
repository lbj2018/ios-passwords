//
//  DRKUser.h
//  dPasswords
//
//  Created by zhou dengfeng derek on 27/9/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRKUser : NSObject

@property (nonatomic) int userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;

- (instancetype)initWithUserId:(int)userId userName:(NSString *)userName password:(NSString *)password;

@end
