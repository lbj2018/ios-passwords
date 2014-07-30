//
//  DRKAccountListViewController.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 25/7/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKAccountListViewController.h"
#import "DRKAccountViewController.h"
#import "DRKAccountCell.h"
#import "DRKAccountStore.h"

@interface DRKAccountListViewController () 
@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) DRKAccount *accountWillShow;
@end

@implementation DRKAccountListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.accounts = [[DRKAccountStore sharedStore] accounts];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (NSString *)secureStringForPassword:(NSString *)password
{
    NSMutableString *secureString = [[NSMutableString alloc] init];
    for (int i = 0; i < [password length]; i++) {
        [secureString appendString:@"*"];
    }
    return secureString;
}

#pragma mark - Action

- (IBAction)addAccount:(id)sender
{
    NSString *correctPassword = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY];

    if (correctPassword) {
        DRKAccount *account = [[DRKAccount alloc] init];
        self.accounts = [[DRKAccountStore sharedStore] addAccount:account];
        
        self.accountWillShow = account;
        [self performSegueWithIdentifier:@"Show Account View" sender:self];
    } else {
        [self showInputAlertWithCancelAndOKButtonWithTitle:@"Set Password" message:@"You need to set a password firstly."];
    }
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
    
    cell.companyNameLabel.text = account.companyName;
    cell.usernameLabel.text = account.username;
    cell.passwordLabel.text = [self secureStringForPassword:account.password];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DRKAccount *account = self.accounts[indexPath.row];
        self.accounts = [[DRKAccountStore sharedStore] deleteAccount:account];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.accountWillShow = self.accounts[indexPath.row];

    NSString *correctPassword = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY];

    if (!correctPassword) {
        [self showInputAlertWithCancelAndOKButtonWithTitle:@"Set Password"
                                                   message:@"You need to set a password firstly"];
    } else {
        [self showInputAlertWithCancelAndOKButtonWithTitle:@"Check Password"
                                                                     message:@"Please enter your password"];
    }
}

#pragma mark - Alert View and UIAlertViewDelegate

- (void)showInputAlertWithCancelAndOKButtonWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
                                                 message:message
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"OK", nil];
    av.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [av show];
}

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Tips"
                                                 message:message
                                                delegate:nil
                                       cancelButtonTitle:nil
                                       otherButtonTitles:@"OK", nil];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([alertView.title isEqualToString:@"Set Password"]) {
        if ([buttonTitle isEqualToString:@"OK"]) {
            UITextField *passwordField = [alertView textFieldAtIndex:0];
            NSString *password = passwordField.text;
            
            if (password.length) {
                [[NSUserDefaults standardUserDefaults] setObject:password forKey:PASSWORD_KEY];
                if (self.accountWillShow) {
                    [self performSegueWithIdentifier:@"Show Account View" sender:self];
                } else {
                    [self addAccount:nil];
                }
            } else {
                NSLog(@"Password can not be empty.");
            }
        } else {
            self.accountWillShow = nil;
        }
    } else if ([alertView.title isEqualToString:@"Check Password"]) {
        if ([buttonTitle isEqualToString:@"OK"]) {
            UITextField *passwordField = [alertView textFieldAtIndex:0];
            NSString *password = passwordField.text;
            NSString *correctPassword = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY];
            
            if ([password isEqualToString:correctPassword]) {
                if (self.accountWillShow) [self performSegueWithIdentifier:@"Show Account View" sender:self];
            } else {
                [self showAlertWithMessage:@"Password is wrong."];
            }
        } else {
            self.accountWillShow = nil;
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Account View"]) {
        id controller = segue.destinationViewController;
        if ([controller isKindOfClass:[DRKAccountViewController class]]) {
            DRKAccountViewController *accountViewController = controller;
            accountViewController.account = self.accountWillShow;
        }
    }
}

@end
