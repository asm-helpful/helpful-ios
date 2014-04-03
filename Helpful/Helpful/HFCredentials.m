//
//  HFCredentials.m
//  Helpful
//
//  Created by Matthias Plappert on 28/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <FXKeychain/FXKeychain.h>
#import <RestKit/RestKit.h>

#import "HFCredentials.h"

static NSString *const HFCredentialsUsernameKey = @"CredentialsUsernameKey";

@interface HFCredentials ()

@property (nonatomic, strong) FXKeychain *keychain;

@property (nonatomic, copy, readwrite) NSString *username;
@property (nonatomic, copy, readwrite) NSString *password;

- (void)hf_loadUsername;
- (void)hf_loadPassword;

@end

@implementation HFCredentials

+ (instancetype)defaultCredentials {
    static HFCredentials *credentials;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        credentials = [[HFCredentials alloc] init];
    });
    return credentials;
}

- (id)init {
    if ((self = [super init])) {
        _keychain = [FXKeychain defaultKeychain];
        [self hf_loadUsername];
        [self hf_loadPassword];
    }
    return self;
}

#pragma mark - Accessors

- (void)setUsername:(NSString *)username password:(NSString *)password {
    if (![self.username isEqualToString:username]) {
        // The username changed. Remove the old entry from the keychain and update
        // the user defaults.
        if (self.username.length > 0) {
            [self.keychain removeObjectForKey:self.username];
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:username forKey:HFCredentialsUsernameKey];
        [defaults synchronize];
        self.username = username;
    }
    
    if (![self.password isEqualToString:password]) {
        // The password changed. Update the keychain.
        if (username.length > 0 && password.length > 0) {
            [self.keychain setObject:password forKey:username];
        }
        self.password = password;
    }
}

- (BOOL)isComplete {
    return (self.username.length > 0 && self.password.length > 0);
}

#pragma mark - Private Methods

- (void)hf_loadUsername {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.username = [defaults stringForKey:HFCredentialsUsernameKey];
}

- (void)hf_loadPassword {
    // Retrieve the password from the keychain. The key is the username, so
    // we can potentially use the same keychain in the future to store multiple
    // credentials.
    if (self.username.length > 0) {
        self.password = [self.keychain objectForKey:self.username];
    } else {
        self.password = nil;
    }
}

@end
