//
//  DRKRegisterViewController.h
//  dPasswords
//
//  Created by zhou dengfeng derek on 26/9/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DRKRegisterViewControllerDelegate;

@interface DRKRegisterViewController : UITableViewController
@property (nonatomic, weak) id<DRKRegisterViewControllerDelegate> delegate;
@end

@protocol DRKRegisterViewControllerDelegate <NSObject>

- (void)registerViewController:(DRKRegisterViewController *)controller
       didRegisterWithUsername:(NSString *)username
                      password:(NSString *)password;

@end
