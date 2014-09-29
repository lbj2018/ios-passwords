//
//  DRKAddAccountViewController.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 9/9/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKAddAccountViewController.h"
#import "DRKAlertViewController.h"
#import "DRKAccountStore.h"
#import "DRKWebServices.h"
#import "MBProgressHUD.h"

@interface DRKAddAccountViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *accountNameField;
@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@end

@implementation DRKAddAccountViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.accountNameField becomeFirstResponder];
}

- (BOOL)checkForAccountName:(NSString *)accountName username:(NSString *)username password:(NSString *)password
{
    if ([accountName length] == 0) {
        [DRKAlertViewController showSimpleAlertWithTitle:@""
                                                 message:NSLocalizedString(@"Account name cannot be empty", @"")];
        return NO;
    }
    
    if ([username length] == 0) {
        [DRKAlertViewController showSimpleAlertWithTitle:@""
                                                 message:NSLocalizedString(@"Username cannot be empty", @"")];
        return NO;
    }
    
    if ([password length] == 0) {
        [DRKAlertViewController showSimpleAlertWithTitle:@""
                                                 message:NSLocalizedString(@"Password cannot be empty", @"")];
        return NO;
    }
    return YES;
}

#pragma mark - Action

- (IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)save:(id)sender
{
    NSString *accountName = self.accountNameField.text;
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if ([self checkForAccountName:accountName username:username password:password]) {
        [self.view endEditing:YES];
        NSString *encryptedPassword = [[DRKAccountStore sharedStore] encryptPassword:password withKey:self.user.password];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *accountId = [[NSUUID UUID] UUIDString];
        [DRKWebServices addAccountWithAccountId:accountId
                                         accountName:accountName
                                            userName:username
                                            password:encryptedPassword
                                           forUserId:self.user.userId
                                          completion:^(NSError *error, NSDate *obj)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!error) {
                [[DRKAccountStore sharedStore] addAccountWithAccountId:accountId
                                                           accountName:accountName
                                                              username:username
                                                     encryptedPassword:encryptedPassword
                                                           dateCreated:obj];

                [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
            } else {
                [DRKAlertViewController showSimpleAlertWithTitle:@""
                                                         message:NSLocalizedString(@"Fai to add account", @"")];
            }
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.accountNameField) {
        [self.usernameField becomeFirstResponder];
    } else if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    } else {
        [self.accountNameField becomeFirstResponder];
    }
    return YES;
}

@end
