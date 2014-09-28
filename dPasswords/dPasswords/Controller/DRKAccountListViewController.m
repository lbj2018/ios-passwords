//
//  DRKAccountListViewController.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 25/7/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKAccountListViewController.h"
#import "DRKAddAccountViewController.h"
#import "DRKAccountViewController.h"
#import "DRKAlertViewController.h"
#import "DRKAccountCell.h"
#import "DRKAccountStore.h"
#import "NSString+MD5.h"
#import "DRKHttpRequestStore.h"
#import "NSData+AES.h"

@interface DRKAccountListViewController () <UIAlertViewDelegate>
@property (nonatomic, strong) NSArray *accounts;
@end

@implementation DRKAccountListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.accounts = [[DRKAccountStore sharedStore] getAllAccounts];
    
    [DRKHttpRequestStore loadAccountsForUserId:self.user.userId
                                    completion:
     ^(NSError *error) {
         if (!error) {
             [self.tableView reloadData];
         }
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (NSString *)securePasswordStringForCount:(int)count
{
    NSMutableString *secureString = [[NSMutableString alloc] init];
    for (int i = 0; i < count; i++) {
        [secureString appendString:@"*"];
    }
    return secureString;
}

#pragma mark - Action

- (IBAction)add:(id)sender
{
    [self performSegueWithIdentifier:@"Add Account" sender:self];
}

- (IBAction)settings:(id)sender {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                 message:NSLocalizedString(@"Are you sure to log out?", @"")
                                                delegate:self
                                       cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                       otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    [av show];
}

#pragma mark - UIAlertViewDelegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString(@"OK", @"")]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
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
    
    cell.acccountNameLabel.text = account.accountName;
    cell.usernameLabel.text = account.username;
    cell.passwordLabel.text = [self securePasswordStringForCount:(int)account.encryptedPassword.length];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"Show Account" sender:indexPath];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Account"]) {
        id controller = segue.destinationViewController;
        if ([controller isKindOfClass:[DRKAccountViewController class]]) {
            DRKAccountViewController *accountViewController = controller;
            if ([sender isKindOfClass:[NSIndexPath class]]) {
                NSIndexPath *indexPath = (NSIndexPath *)sender;
                accountViewController.account = self.accounts[indexPath.row];
                accountViewController.user = self.user;
            }
        }
    } else if ([segue.identifier isEqualToString:@"Add Account"]) {
        id controller = segue.destinationViewController;
        if ([controller isKindOfClass:[UINavigationController class]]) {
            controller = [[controller viewControllers] firstObject];
        }
        if ([controller isKindOfClass:[DRKAddAccountViewController class]]) {
            DRKAddAccountViewController *aavc = (DRKAddAccountViewController *)controller;
            aavc.user = self.user;
        }
    }
}

@end
