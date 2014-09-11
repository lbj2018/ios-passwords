//
//  DRKAccountStore.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 25/7/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKAccountStore.h"
#import "DRKCoreData.h"
#import "NSData+AES.h"

@interface DRKAccountStore ()
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *accounts;
@end

@implementation DRKAccountStore

- (void)changePassword:(NSString *)oldPassword toNewPassword:(NSString *)password
{
    for (DRKAccount *account in self.accounts) {
        NSString *accountPassword = [self decryptPassword:account.encryptedPassword withKey:oldPassword];
        NSData *newEncryptedPassword = [self encryptPassword:accountPassword withKey:password];
        account.encryptedPassword = newEncryptedPassword;
    }
    
    [self save];
}

- (void)updateAccount:(DRKAccount *)account
{
    [self save];
}

- (void)addAccountWithAccountName:(NSString *)accountName username:(NSString *)username encryptedPassword:(NSData *)encryptedPassword
{
    DRKAccount *account = [NSEntityDescription insertNewObjectForEntityForName:@"DRKAccount"
                                                        inManagedObjectContext:self.managedObjectContext];
    account.accountId = [[NSUUID UUID] UUIDString];
    account.accountName = accountName;
    account.username = username;
    account.encryptedPassword = encryptedPassword;
    account.dateCreated = [NSDate date];
    
    [self.managedObjectContext insertObject:account];
    
    [self.accounts insertObject:account atIndex:0];
    
    [self save];
}

- (void)deleteAccount:(DRKAccount *)account
{
    [self.managedObjectContext deleteObject:account];
    
    [self.accounts removeObject:account];
    
    [self save];
}

- (NSArray *)getAllAccounts
{
    return self.accounts;
}

- (void)save
{
    [[DRKCoreData sharedCoreData] saveContext];
}

- (NSArray *)fetchAllAccounts
{
    NSArray *accounts = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DRKAccount"];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (results) {
        accounts = results;
    } else {
        // handle for error
    }
    
    return accounts;
}

#pragma mark - Decrypt Password

- (NSString *)decryptPassword:(NSData *)encryptedPassword withKey:(NSString *)key
{
    NSData *data = [encryptedPassword AES128DecryptWithKey:key iv:@"_23dAOq9"];
    NSString *password = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return password;
}

- (NSData *)encryptPassword:(NSString *)password withKey:(NSString *)key
{
    NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
    data = [data AES128EncryptWithKey:key iv:@"_23dAOq9"];
    
    return data;
}

#pragma mark - Properties

- (NSMutableArray *)accounts
{
    if (!_accounts) {
        _accounts = [[self fetchAllAccounts] mutableCopy];
    }
    return _accounts;
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
        _managedObjectContext = [[DRKCoreData sharedCoreData] managedObjectContext];
    }
    return self;
}

@end
