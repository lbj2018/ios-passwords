//
//  DRKLoginViewController.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 25/9/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKLoginViewController.h"
#import "DRKRegisterViewController.h"
#import "DRKAccountListViewController.h"
#import "DRKAlertViewController.h"
#import "DRKWebServices.h"
#import "MBProgressHUD.h"
#import "NSString+MD5.h"
#import "DRKAccountStore.h"

@interface DRKLoginViewController () <UITextFieldDelegate, DRKRegisterViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) DRKUser *user;
@end

@implementation DRKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:[UIApplication sharedApplication]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.usernameTextField becomeFirstResponder];
}

- (BOOL)checkForUsername:(NSString *)username password:(NSString *)password {
    
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

- (void)doLoginAction {
    [self.view endEditing:YES];

    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if ([self checkForUsername:username password:password]) {        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [DRKWebServices loginWithUsername:username
                                      password:password
                                    completion:
         ^(NSError *error, DRKUser *obj) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (!error) {
                 self.user = obj;
                 [self performSegueWithIdentifier:@"Login" sender:self];
                 self.passwordTextField.text = @"";
             } else {
                 [DRKAlertViewController showSimpleAlertWithTitle:@""
                                                          message:NSLocalizedString(@"Fail to login", @"")];
             }
         }];
    }
}

#pragma mark - Notification

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self doLoginAction];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self doLoginAction];
    }
    
    return YES;
}

#pragma mark - DRKRegisterViewControllerDelegate

- (void)registerViewController:(DRKRegisterViewController *)controller
       didRegisterWithUsername:(NSString *)username
                      password:(NSString *)password
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    self.usernameTextField.text = username;
    self.passwordTextField.text = @"";
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Login"]) {
        id controller = segue.destinationViewController;
        if ([controller isKindOfClass:[UINavigationController class]]) {
            controller = [[controller viewControllers] firstObject];
        }
        if ([controller isKindOfClass:[DRKAccountListViewController class]]) {
            DRKAccountListViewController *accountListViewController = (DRKAccountListViewController *)controller;
            accountListViewController.user = self.user;
        }
    } else if ([segue.identifier isEqualToString:@"Register"]) {
        id controller = segue.destinationViewController;
        if ([controller isKindOfClass:[UINavigationController class]]) {
            controller = [[controller viewControllers] firstObject];
        }
        if ([controller isKindOfClass:[DRKRegisterViewController class]]) {
            DRKRegisterViewController *registerViewController = (DRKRegisterViewController *)controller;
            registerViewController.delegate = self;
        }
    }
}

@end
