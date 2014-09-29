//
//  DRKAccountStore.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 25/7/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKAccountStore.h"
#import "DRKCoreData.h"
#import "NSData+AES256.h"

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

- (void)addAccountWithAccountId:(NSString *)accountId accountName:(NSString *)accountName username:(NSString *)username encryptedPassword:(NSString *)encryptedPassword dateCreated:(NSDate *)dateCreated {
    DRKAccount *account = [NSEntityDescription insertNewObjectForEntityForName:@"DRKAccount"
                                                        inManagedObjectContext:self.managedObjectContext];
    account.accountId = accountId;
    account.accountName = accountName;
    account.username = username;
    account.encryptedPassword = encryptedPassword;
    account.dateCreated = dateCreated;
    
    [self.managedObjectContext insertObject:account];
    
    [self.accounts insertObject:account atIndex:0];
    [self sortAccounts];
    
    [self save];
}

- (void)sortAccounts {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO];
    [self.accounts sortUsingDescriptors:@[sortDescriptor]];
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

- (BOOL)isExistForAccountId:(NSString *)accountId {
    BOOL result = false;
    for (DRKAccount *account in self.accounts) {
        if ([accountId isEqualToString:account.accountId]) {
            result = true;
            break;
        }
    }
    return result;
}

- (void)save
{
    [[DRKCoreData sharedCoreData] saveContext];
}

- (NSArray *)fetchAllAccounts
{
    NSArray *accounts = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DRKAccount"];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO];
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

- (NSString *)decryptPassword:(NSString *)encryptedPassword withKey:(NSString *)key
{
    NSString *password = [NSData AES256DecryptWithKey:key ciphertext:encryptedPassword];

    return password;
    
//    NSData *data = [[NSData alloc] initWithBase64EncodedString:encryptedPassword options:NSDataBase64DecodingIgnoreUnknownCharacters];
////    NSData *data = [encryptedPassword dataUsingEncoding:NSUTF16StringEncoding];
//    data = [data AES256DecryptWithKey:key];
//    NSString *password = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return password;
}

- (NSString *)encryptPassword:(NSString *)password withKey:(NSString *)key
{
    NSString *encrypedPassword = [NSData AES256EncryptWithKey:key plainText:password];
    return encrypedPassword;
    
//    NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
//    data = [data AES256EncryptWithKey:key];
////    NSString *encrypedPassword = [data newStringInBase64FromData];
//    
//    NSString *encrypedPassword = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    
//    
//    return encrypedPassword;
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
