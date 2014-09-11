//
//  DRKAccountListViewController.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 25/7/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKAccountListViewController.h"
#import "DRKAddAccountViewController.h"
#import "DRKSetPasswordViewController.h"
#import "DRKAccountViewController.h"
#import "DRKAccountCell.h"
#import "DRKAccountStore.h"
#import "NSString+MD5.h"

@interface DRKAccountListViewController () <UIAlertViewDelegate>
@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) DRKAccount *accountWillShow;
@property (nonatomic, strong) NSString *password;
@end

@implementation DRKAccountListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.accounts = [[DRKAccountStore sharedStore] getAllAccounts];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *correctPassword = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY];
    if (!correctPassword) {
        [self performSegueWithIdentifier:@"Set Password" sender:self];
    }
}

- (NSString *)randomSecureString
{
    int random = arc4random() % 5;
    
    NSMutableString *secureString = [[NSMutableString alloc] init];
    for (int i = 0; i < 10 + random; i++) {
        [secureString appendString:@"*"];
    }
    return secureString;
}

#pragma mark - Action

- (IBAction)add:(id)sender
{
    self.accountWillShow = nil;
    [self showInputAlertWithCancelAndOKButtonWithTitle:NSLocalizedString(@"Check Password", @"")
                                               message:NSLocalizedString(@"Please enter your password", @"")];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.accounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DRKAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DRKAccountCell" forIndexPath:indexPath];
    
    DRKAccount *account = self.accounts[indexPath.row];
    
    cell.acccountNameLabel.text = account.accountName;
    cell.usernameLabel.text = account.username;
    cell.passwordLabel.text = [self randomSecureString];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.accountWillShow = self.accounts[indexPath.row];

    NSString *correctPassword = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY];

    if (correctPassword) {
        [self showInputAlertWithCancelAndOKButtonWithTitle:NSLocalizedString(@"Check Password", @"")
                                                   message:NSLocalizedString(@"Please enter your password", @"")];
    }
}

#pragma mark - Alert View and UIAlertViewDelegate

- (void)showInputAlertWithCancelAndOKButtonWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
                                                 message:message
                                                delegate:self
                                       cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                       otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    av.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [av show];
}

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                 message:message
                                                delegate:nil
                                       cancelButtonTitle:nil
                                       otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString(@"OK", @"")]) {
        UITextField *passwordField = [alertView textFieldAtIndex:0];
        NSString *password = passwordField.text;
        NSString *md5 = [password md5];
        NSString *correctPassword = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY];
        
        if ([md5 isEqualToString:correctPassword]) {
            self.password = password;
            if (self.accountWillShow) {
                [self performSegueWithIdentifier:@"Show Account" sender:self];
            } else {
                [self performSegueWithIdentifier:@"Add Account" sender:self];
            }
        } else {
            [self showAlertWithMessage:NSLocalizedString(@"Password is not correct", @"")];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Account"]) {
        id controller = segue.destinationViewController;
        if ([controller isKindOfClass:[DRKAccountViewController class]]) {
            DRKAccountViewController *accountViewController = controller;
            accountViewController.account = self.accountWillShow;
            accountViewController.password = self.password;
        }
    } else if ([segue.identifier isEqualToString:@"Add Account"]) {
        id controller = segue.destinationViewController;
        if ([controller isKindOfClass:[UINavigationController class]]) {
            controller = [[controller viewControllers] firstObject];
        }
        if ([controller isKindOfClass:[DRKAddAccountViewController class]]) {
            DRKAddAccountViewController *aavc = (DRKAddAccountViewController *)controller;
            aavc.password = self.password;
        }
    }
}

@end
