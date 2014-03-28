//
//  HFLoginViewController.m
//  Helpful
//
//  Created by Matthias Plappert on 28/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFLoginViewController.h"
#import "HFAccount.h"

@interface HFLoginViewController ()

@property (nonatomic, strong) UIBarButtonItem *cancelButtonItem;
@property (nonatomic, strong) UIBarButtonItem *loginButtonItem;

@property (nonatomic, assign, readwrite, getter = isValidating) BOOL validating;

- (void)hf_enableUI;
- (void)hf_disableUI;
- (void)hf_validationDidFinish;
- (void)hf_validationDidFail;

@end

@implementation HFLoginViewController

- (id)initWithAccount:(HFAccount *)account {
    if ((self = [super initWithNibName:@"HFLoginViewController" bundle:nil])) {
        _account = account;
        
        // Load the bar buttons.
        _cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem = _cancelButtonItem;
        
        _loginButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Log In", nil) style:UIBarButtonItemStyleDone target:self action:@selector(validate)];
    }
    return self;
}

#pragma mark - Actions

- (void)cancel {
    [self.delegate loginViewControllerDidCancel:self];
}

- (void)validate {
    self.validating = YES;
    [self hf_disableUI];
    
    // TODO: issue request to validate
}

#pragma mark - Private Methods

- (void)hf_validationDidFail {
    self.validating = NO;
    [self hf_enableUI];
    
    // Present alert view.
    // TODO: refine text
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid Credentials", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}

- (void)hf_validationDidFinish {
    // Update account.
    NSString *username, *password;
    [self.account setUsername:username password:password];
    
    [self.delegate loginViewController:self didLogIntoAccount:self.account];
}

- (void)hf_enableUI {
    self.cancelButtonItem.enabled = YES;
    self.loginButtonItem.enabled = YES;
    // TODO: enable text fields
}

- (void)hf_disableUI {
    self.cancelButtonItem.enabled = NO;
    self.loginButtonItem.enabled = NO;
    // TODO: disable text fields
}

@end
