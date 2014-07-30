//
//  DRKAppDelegate.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 25/7/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKAppDelegate.h"
#import "DRKAccountStore.h"

@implementation DRKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[DRKAccountStore sharedStore] saveAccounts];
}

@end
