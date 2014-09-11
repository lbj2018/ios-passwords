//
//  DRKSetPasswordViewController.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 9/9/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKSetPasswordViewController.h"
#import "DRKAlertViewController.h"
#import "DRKAccountStore.h"
#import "NSString+MD5.h"

@interface DRKSetPasswordViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *confirmPasswordTextField;
@end

@implementation DRKSetPasswordViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.passwordTextField becomeFirstResponder];
}

- (BOOL)checkForPassword:(NSString *)password confirmPassword:(NSString *)confirmPassword
{
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

- (IBAction)done:(id)sender
{
    NSString *password = self.passwordTextField.text;
    NSString *confirmPassword = self.confirmPasswordTextField.text;
    
    if ([self checkForPassword:password confirmPassword:confirmPassword]) {
        NSString *md5Password = [password md5];
        
        [[NSUserDefaults standardUserDefaults] setObject:md5Password forKey:PASSWORD_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.passwordTextField) {
        [self.confirmPasswordTextField becomeFirstResponder];
    } else {
        [self done:nil];
    }
    return YES;
}

@end
