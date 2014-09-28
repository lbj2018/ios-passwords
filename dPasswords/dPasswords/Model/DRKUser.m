//
//  DRKUser.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 27/9/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKUser.h"

@implementation DRKUser

- (instancetype)initWithUserId:(int)userId userName:(NSString *)userName password:(NSString *)password {
    self = [super init];
    if (self) {
        self.userId = userId;
        self.userName = userName;
        self.password = password;
    }
    return self;
}

@end
