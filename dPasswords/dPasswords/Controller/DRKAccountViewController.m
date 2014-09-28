//
//  DRKAccountViewController.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 30/7/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKAccountViewController.h"
#import "DRKAlertViewController.h"
#import "DRKAccountStore.h"
#import "DRKHttpRequestStore.h"
#import "MBProgressHUD.h"

@interface DRKAccountViewController () <UIAlertViewDelegate, UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *accountNameField;
@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UITableViewCell *deleteCell;
@property (nonatomic, strong) UIBarButtonItem *editBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *cancelBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *saveBarButtonItem;
@property (nonatomic, getter = isAccountEditing) BOOL accountEditing;
@end

@implementation DRKAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setAccountEditing:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:[UIApplication sharedApplication]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:[UIApplication sharedApplication]];
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

- (void)updateUI
{
    if (self.isAccountEditing) {
        self.accountNameField.enabled = YES;
        self.usernameField.enabled = YES;
        self.passwordField.enabled = YES;

        self.deleteCell.hidden = NO;
        self.deleteCell.userInteractionEnabled = YES;
        self.navigationItem.leftBarButtonItem = self.cancelBarButtonItem;
        self.navigationItem.rightBarButtonItem = self.saveBarButtonItem;
        [self.accountNameField becomeFirstResponder];
    } else {
        self.accountNameField.enabled = NO;
        self.usernameField.enabled = NO;
        self.passwordField.enabled = NO;

        self.deleteCell.hidden = YES;
        self.deleteCell.userInteractionEnabled = NO;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = self.editBarButtonItem;
    }
    self.accountNameField.text = self.account.accountName;
    self.usernameField.text = self.account.username;
    self.passwordField.text = [[DRKAccountStore sharedStore] decryptPassword:self.account.encryptedPassword withKey:self.user.password];
}

#pragma mark - Notification

- (void)applicationWillResignActive:(NSNotification *)notification
{
    
}

#pragma mark - Action

- (void)edit:(id)sender
{
    self.accountEditing = !self.isAccountEditing;
    [self updateUI];
}

- (void)cancel:(id)sender
{
    self.accountEditing = NO;
    [self updateUI];
}

- (void)save:(id)sender
{
    NSString *accountName = self.accountNameField.text;
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    
    if ([self checkForAccountName:accountName username:username password:password]) {

        NSString *encryptedPassword = [[DRKAccountStore sharedStore] encryptPassword:password withKey:self.user.password];
        [DRKHttpRequestStore changeAccountWithAccountId:self.account.accountId
                                            accountName:accountName
                                               userName:username
                                               password:encryptedPassword
                                              forUserId:self.user.userId
                                             completion:
         ^(NSError *error) {
             if (!error) {
                 self.account.accountName = accountName;
                 self.account.username = username;
                 self.account.encryptedPassword = encryptedPassword;
                 
                 [[DRKAccountStore sharedStore] updateAccount:self.account];
                 self.accountEditing = NO;
                 [self updateUI];
             } else {
                 [DRKAlertViewController showSimpleAlertWithTitle:@""
                                                          message:NSLocalizedString(@"Fai to change account", @"")];
             }
         }];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString(@"OK", @"")]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [DRKHttpRequestStore deleteAccountWithAccountId:self.account.accountId
                                              forUserId:self.user.userId
                                             completion:
         ^(NSError *error) {
             if (!error) {
                 [[DRKAccountStore sharedStore] deleteAccount:self.account];
                 [self.navigationController popViewControllerAnimated:YES];
             } else {
                 [DRKAlertViewController showSimpleAlertWithTitle:@""
                                                          message:NSLocalizedString(@"Fai to delete account", @"")];
             }
         }];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete", @"")
                                                     message:NSLocalizedString(@"Are you sure to delete this account?", @"")
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                           otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        [av show];
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

#pragma mark - Properties

- (UIBarButtonItem *)editBarButtonItem
{
    if (!_editBarButtonItem) {
        _editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                           target:self
                                                                           action:@selector(edit:)];
    }
    return _editBarButtonItem;
}

- (UIBarButtonItem *)cancelBarButtonItem
{
    if (!_cancelBarButtonItem) {
        _cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                             target:self
                                                                             action:@selector(cancel:)];
    }
    return _cancelBarButtonItem;
}

- (UIBarButtonItem *)saveBarButtonItem
{
    if (!_saveBarButtonItem) {
        _saveBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                           target:self
                                                                           action:@selector(save:)];
    }
    return _saveBarButtonItem;
}

@end
