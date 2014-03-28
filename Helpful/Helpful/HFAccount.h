//
//  HFAccount.h
//  Helpful
//
//  Created by Matthias Plappert on 28/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFAccount : NSObject

/// Returns the default account.
+ (instancetype)defaultAccount;

/// The username of the account.
@property (nonatomic, copy, readonly) NSString *username;

/// The password of the account.
@property (nonatomic, copy, readonly) NSString *password;

/// Updates the username and password and persists those values to disk.
- (void)setUsername:(NSString *)username password:(NSString *)password;

@end
