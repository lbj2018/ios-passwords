//
//  DRKAccount.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 25/7/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKAccount.h"

@implementation DRKAccount

- (NSString *)description
{
    return [NSString stringWithFormat:@"(%@, %@, %@)", self.companyName, self.username, self.password];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.companyName = [aDecoder decodeObjectForKey:@"companyName"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.companyName forKey:@"companyName"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.password forKey:@"password"];
}

#pragma mark - Initialization

- (instancetype)initWithCompanyName:(NSString *)companyName username:(NSString *)username password:(NSString *)password
{
    self = [super init];
    if (self) {
        _companyName = companyName;
        _username = username;
        _password = password;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithCompanyName:nil username:nil password:nil];
}

@end
