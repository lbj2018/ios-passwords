//
//  DRKAccount.h
//  dPasswords
//
//  Created by zhou dengfeng derek on 28/9/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DRKAccount : NSManagedObject

@property (nonatomic, retain) NSString * accountId;
@property (nonatomic, retain) NSString * accountName;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * encryptedPassword;
@property (nonatomic, retain) NSString * username;

@end
