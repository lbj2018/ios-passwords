//
//  DRKAccountViewController.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 30/7/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKAccountViewController.h"
#import "DRKAccountStore.h"

@interface DRKAccountViewController ()
@property (nonatomic, weak) IBOutlet UITextField *companyNameField;
@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@end

@implementation DRKAccountViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.account.companyName.length) [self.companyNameField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self updateAccount];
}

- (void)updateUI
{
    self.navigationItem.title = self.account.companyName;
    
    self.companyNameField.text = self.account.companyName;
    self.usernameField.text = self.account.username;
    self.passwordField.text = self.account.password;
}

- (void)updateAccount
{
    self.account.companyName = self.companyNameField.text;
    self.account.username = self.usernameField.text;
    self.account.password = self.passwordField.text;
}

@end
