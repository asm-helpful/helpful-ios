//
//  HFCredentials.h
//  Helpful
//
//  Created by Matthias Plappert on 28/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFCredentials : NSObject

/// Returns the default credentials.
+ (instancetype)defaultCredentials;

/// The username.
@property (nonatomic, copy, readonly) NSString *username;

/// The password.
@property (nonatomic, copy, readonly) NSString *password;

/// Indicates if the credentials have a proper username and password set.
/// @warning This propery does not indicate if the credentials are actually valid!
@property (nonatomic, assign, readonly, getter = isComplete) BOOL complete;

/// Updates the username and password and persists those values to disk.
- (void)setUsername:(NSString *)username password:(NSString *)password;

@end
