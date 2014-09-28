//
//  DRKHttpRequestStore.m
//  dPasswords
//
//  Created by zhou dengfeng derek on 25/9/14.
//  Copyright (c) 2014 Zhou Dengfeng Derek. All rights reserved.
//

#import "DRKHttpRequestStore.h"
#import "NSString+MD5.h"
#import "DRKAccountStore.h"

@implementation DRKHttpRequestStore

#define SUCCESS_STATUS  @"1"
#define FAIL_STATUS     @"0"

//#define BASE_URL        @"http://localhost:8080/dPasswords/"
#define BASE_URL        @"http://121.199.0.190:8080/dPasswords/"

static NSDateFormatter *formatter = nil;
+ (NSDate *)dateFromString:(NSString *)dateString {
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    return [formatter dateFromString:dateString];
}

+ (NSString *)dateStringFromDate:(NSDate *)date {
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }

    return [formatter stringFromDate:date];
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(NSError *error, DRKUser *obj))handler {
    
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:@"login"]];
    
    NSString *md5Password = [password md5];
    
    NSString *bodyString = [NSString stringWithFormat:@"username=%@&password=%@", username, md5Password];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (connectionError) {
             // handle for connection error
             handler(connectionError, nil);
         } else {
             if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                 if (httpResponse.statusCode == 200) {
                     NSString *status = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                     NSLog(@"Status: %@", status);
                     if (![status isEqualToString:FAIL_STATUS]) {
                         DRKUser *user = [[DRKUser alloc] initWithUserId:[status intValue] userName:username password:password];
                         
                         handler(nil, user);
                     } else {
                         handler([[NSError alloc] init], nil);
                     }
                 } else {
                     // handle for data exception
                     handler([[NSError alloc] init], nil);
                 }
             }
         }
     }];
}

+ (void)registerWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(NSError *error))handler {
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:@"register"]];

    NSString *bodyString = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (connectionError) {
             // handle for connection error
             handler(connectionError);
         } else {
             if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                 if (httpResponse.statusCode == 200) {
                     NSString *status = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                     NSLog(@"Status: %@", status);
                     if ([status isEqualToString:SUCCESS_STATUS]) {
                         handler(nil);
                     } else {
                         handler([[NSError alloc] init]);
                     }
                 } else {
                     // handle for data exception
                     handler([[NSError alloc] init]);
                 }
             }
         }
     }];
}

+ (void)addAccountWithAccountId:(NSString *)accountId accountName:(NSString *)accountName userName:(NSString *)userName password:(NSString *)password forUserId:(int)userId completion:(void(^)(NSError *error, NSDate *obj))handler {
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:@"insertAccount"]];

    NSString *bodyString = [NSString stringWithFormat:@"user_id=%d&account_id=%@&account_name=%@&user_name=%@&password=%@", userId, accountId, accountName, userName, password];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (connectionError) {
             // handle for connection error
             handler(connectionError, nil);
         } else {
             if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                 if (httpResponse.statusCode == 200) {
                     NSString *status = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                     NSLog(@"Status: %@", status);
                     if (![status isEqualToString:FAIL_STATUS]) {
                         NSDate *dateCreated = [self dateFromString:status];
                         handler(nil, dateCreated);
                     } else {
                         handler([[NSError alloc] init], nil);
                     }
                 } else {
                     // handle for data exception
                     handler([[NSError alloc] init], nil);
                 }
             }
         }
     }];
}

+ (void)loadAccountsForUserId:(int)userId completion:(void(^)(NSError *error))handler {
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:@"loadAccounts"]];

    NSString *bodyString = [NSString stringWithFormat:@"user_id=%d", userId];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (connectionError) {
             // handle for connection error
             handler(connectionError);
         } else {
             if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                 if (httpResponse.statusCode == 200) {
                     NSString *status = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                     NSLog(@"Status: %@", status);
                     if (![status isEqualToString:FAIL_STATUS]) {
                         
                         NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                         for (NSDictionary *json in jsonArray) {
                             NSString *accountId = json[@"account_id"];
                             if (![[DRKAccountStore sharedStore] isExistForAccountId:accountId]) {
                                 NSString *dateString = json[@"date_created"];
                                 [[DRKAccountStore sharedStore] addAccountWithAccountId:accountId
                                                                            accountName:json[@"account_name"]
                                                                               username:json[@"user_name"]
                                                                      encryptedPassword:json[@"password"]
                                                                            dateCreated:[self dateFromString:dateString]];
                             }
                         }
                         handler(nil);
                     } else {
                         handler([[NSError alloc] init]);
                     }
                 } else {
                     // handle for data exception
                     handler([[NSError alloc] init]);
                 }
             }
         }
     }];
}

+ (void)deleteAccountWithAccountId:(NSString *)accountId forUserId:(int)userId completion:(void(^)(NSError *error))handler {
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:@"deleteAccount"]];
    
    NSString *bodyString = [NSString stringWithFormat:@"user_id=%d&account_id=%@", userId, accountId];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (connectionError) {
             // handle for connection error
             handler(connectionError);
         } else {
             if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                 if (httpResponse.statusCode == 200) {
                     NSString *status = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                     NSLog(@"Status: %@", status);
                     if (![status isEqualToString:FAIL_STATUS]) {
                         handler(nil);
                     } else {
                         handler([[NSError alloc] init]);
                     }
                 } else {
                     // handle for data exception
                     handler([[NSError alloc] init]);
                 }
             }
         }
     }];
}

+ (void)changeAccountWithAccountId:(NSString *)accountId accountName:(NSString *)accountName userName:(NSString *)userName password:(NSString *)password forUserId:(int)userId completion:(void(^)(NSError *error))handler {
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:@"changeAccount"]];
    
    NSString *bodyString = [NSString stringWithFormat:@"user_id=%d&account_id=%@&account_name=%@&user_name=%@&password=%@", userId, accountId, accountName, userName, password];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (connectionError) {
             // handle for connection error
             handler(connectionError);
         } else {
             if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                 if (httpResponse.statusCode == 200) {
                     NSString *status = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                     NSLog(@"Status: %@", status);
                     if (![status isEqualToString:FAIL_STATUS]) {
                         handler(nil);
                     } else {
                         handler([[NSError alloc] init]);
                     }
                 } else {
                     // handle for data exception
                     handler([[NSError alloc] init]);
                 }
             }
         }
     }];
}

@end
