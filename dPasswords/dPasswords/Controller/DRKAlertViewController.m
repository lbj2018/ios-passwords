//
//  DRKAlertViewController.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 9/9/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKAlertViewController.h"

@implementation DRKAlertViewController

+ (void)showSimpleAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
                                                 message:message
                                                delegate:nil
                                       cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                       otherButtonTitles:nil];
    [av show];
}

@end
