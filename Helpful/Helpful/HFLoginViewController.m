//
//  HFLoginViewController.m
//  Helpful
//
//  Created by Matthias Plappert on 28/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFLoginViewController.h"
#import "HFCredentials.h"
#import "HFAccount.h"

@interface HFLoginViewController ()

@property (nonatomic, strong) UIBarButtonItem *cancelButtonItem;
@property (nonatomic, strong) UIBarButtonItem *loginButtonItem;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, assign, readwrite, getter = isValidating) BOOL validating;

- (void)hf_updateUserInterface;
- (void)hf_validationDidFinishWithAccounts:(NSSet *)accounts;
- (void)hf_validationDidFailWithError:(NSError *)error;

@end

@implementation HFLoginViewController

- (id)initWithCredentials:(HFCredentials *)credentials {
    if ((self = [super initWithNibName:@"HFLoginViewController" bundle:nil])) {
        _credentials = credentials;
        _username = [credentials.username copy];
        _password = [credentials.password copy];
        
        // Load the bar buttons.
        _cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem = _cancelButtonItem;
        
        _loginButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Log In", nil) style:UIBarButtonItemStyleDone target:self action:@selector(validate)];
        self.navigationItem.rightBarButtonItem = _loginButtonItem;
        
        // Configure controller.
        self.title = NSLocalizedString(@"Login", nil);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameTextField.text = self.username;
    self.passwordTextField.text = self.password;
    [self hf_updateUserInterface];
}

#pragma mark - UIViewController

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Actions

- (void)cancel {
    [self.delegate loginViewControllerDidCancel:self];
}

- (void)validate {
    self.validating = YES;
    [self hf_updateUserInterface];
    
    // Update the HTTP client.
    AFHTTPClient *client = [RKObjectManager sharedManager].HTTPClient;
    [client setAuthorizationHeaderWithUsername:self.username password:self.password];
    
    // Fetch all accounts.
    RKObjectRequestOperation *operation = [HFAccount accountsRequestOperation];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self hf_validationDidFinishWithAccounts:[mappingResult set]];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self hf_validationDidFailWithError:error];
    }];
    [operation start];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if ([textField isEqual:self.usernameTextField]) {
        self.username = self.usernameTextField.text;
    } else if ([textField isEqual:self.passwordTextField]) {
        self.password = self.passwordTextField.text;
    }
    [self hf_updateUserInterface];
}

#pragma mark - Private Methods

- (void)hf_validationDidFailWithError:(NSError *)error {
    self.validating = NO;
    [self hf_updateUserInterface];
    
    // Present alert view.
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid Credentials", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}

- (void)hf_validationDidFinishWithAccounts:(NSSet *)accounts {
    // Update credentials.
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    [self.credentials setUsername:username password:password];
    
    [self.delegate loginViewController:self didLogIntoAccounts:accounts];
}

- (void)hf_updateUserInterface {
    // Enable/disable input.
    BOOL enableInput = !self.validating;
    self.cancelButtonItem.enabled = enableInput;
    self.loginButtonItem.enabled = enableInput;
    self.usernameTextField.enabled = enableInput;
    self.passwordTextField.enabled = enableInput;
    
    // Always disable login button if one of the text fields is empty.
    if (self.username.length == 0 || self.password.length == 0) {
        self.loginButtonItem.enabled = NO;
    }
}

@end
