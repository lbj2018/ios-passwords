//
//  DRKResetPasswordViewController.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 9/9/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKResetPasswordViewController.h"
#import "DRKAlertViewController.h"
#import "DRKAccountStore.h"
#import "NSString+MD5.h"

@interface DRKResetPasswordViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *oldPasswordTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *confirmPasswordTextField;
@end

@implementation DRKResetPasswordViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.oldPasswordTextField becomeFirstResponder];
}

- (BOOL)checkForOldPassword:(NSString *)oldPassword password:(NSString *)password confirmPassword:(NSString  *)confirmPassword
{
    NSString *correctPassword = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY];
    
    if (![[oldPassword md5] isEqualToString:correctPassword]) {
        [DRKAlertViewController showSimpleAlertWithTitle:@""
                                                 message:NSLocalizedString(@"Old password is not correct", @"")];
        return NO;
    }
    
    if ([password length] == 0) {
        [DRKAlertViewController showSimpleAlertWithTitle:@""
                                                 message:NSLocalizedString(@"Password cannot be empty", @"")];
        return NO;
    }
    if (![password isEqualToString:confirmPassword]) {
        [DRKAlertViewController showSimpleAlertWithTitle:@""
                                                 message:NSLocalizedString(@"Passwords don't match", @"")];
        return NO;
    }
    
    return YES;
}

#pragma mark - Action

- (IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)done:(id)sender
{
    NSString *oldPassword = self.oldPasswordTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *confirmPassword = self.confirmPasswordTextField.text;
    
    if ([self checkForOldPassword:oldPassword password:password  confirmPassword:confirmPassword]) {
        [[DRKAccountStore sharedStore] changePassword:oldPassword toNewPassword:password];
        NSString *md5Password = [password md5];
        
        [[NSUserDefaults standardUserDefaults] setObject:md5Password forKey:PASSWORD_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.oldPasswordTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.confirmPasswordTextField becomeFirstResponder];
    } else {
        [self done:nil];
    }
    return YES;
}

@end
