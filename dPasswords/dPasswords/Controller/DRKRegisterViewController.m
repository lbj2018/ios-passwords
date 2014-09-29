//
//  DRKRegisterViewController.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 26/9/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKRegisterViewController.h"
#import "DRKAlertViewController.h"
#import "DRKWebServices.h"
#import "MBProgressHUD.h"
#import "NSString+MD5.h"

@interface DRKRegisterViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *confirmPasswordTextField;
@end

@implementation DRKRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.usernameTextField becomeFirstResponder];
}

- (BOOL)checkForUsername:(NSString *)username password:(NSString *)password confirmPassword:(NSString *)confirmPassword {
    
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
    
    if (![confirmPassword isEqualToString:password]) {
        [DRKAlertViewController showSimpleAlertWithTitle:@""
                                                 message:NSLocalizedString(@"Passwords don't match", @"")];
        return NO;
    }
    
    return YES;
}

- (void)doRegisterAction {
    [self.view endEditing:YES];
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *confirmPassword = self.confirmPasswordTextField.text;
    
    if ([self checkForUsername:username password:password confirmPassword:confirmPassword]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [DRKWebServices registerWithUsername:username
                                      password:[password md5]
                                    completion:
         ^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (!error) {
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 hud.mode = MBProgressHUDModeText;
                 hud.labelText = NSLocalizedString(@"Success to sign up", @"");
                 [hud hide:YES afterDelay:2.0];
                 
                 [self performSelector:@selector(back) withObject:nil afterDelay:2.0];
             } else {
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 hud.mode = MBProgressHUDModeText;
                 hud.labelText = NSLocalizedString(@"Fail to sign up", @"");
                 [hud hide:YES afterDelay:2.0];
             }
         }];
    }
}

- (void)back {
    [self.delegate registerViewController:self
                  didRegisterWithUsername:self.usernameTextField.text
                                 password:self.passwordTextField.text];
}

#pragma mark - Action

- (IBAction)cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self doRegisterAction];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.confirmPasswordTextField becomeFirstResponder];
    } else if (textField == self.confirmPasswordTextField) {
        [self doRegisterAction];
    }
    
    return YES;
}

@end
