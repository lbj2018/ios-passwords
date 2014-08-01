//
//  DRKAccountStore.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 25/7/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKAccountStore.h"

@interface DRKAccountStore ()
@property (nonatomic, strong) NSMutableArray *privateAccounts;
@end

@implementation DRKAccountStore

- (NSArray *)addAccount:(DRKAccount *)account
{
    [self.privateAccounts insertObject:account atIndex:0];
    
    [self saveAccounts];
    
    return [self accounts];
}

- (NSArray *)deleteAccount:(DRKAccount *)account
{
    [self.privateAccounts removeObject:account];
    
    [self saveAccounts];
    
    return [self accounts];
}

- (BOOL)saveAccounts
{
    return [NSKeyedArchiver archiveRootObject:self.privateAccounts toFile:[self archivePath]];
}

- (NSArray *)accounts
{
    return [self.privateAccounts copy];
}

- (NSString *)archivePath
{
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documents firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"passwords.archive"];
}

#pragma mark - Initialization

+ (instancetype)sharedStore
{
    static DRKAccountStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"You should use +[DRKAccountStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _privateAccounts = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]];
        if (!_privateAccounts) _privateAccounts = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
