//
//  HFViewController.m
//  Helpful
//
//  Created by Ashish Awaghad on 1/12/13.
//  Copyright (c) 2013 Helpful. All rights reserved.
//

#import "HFViewController.h"

@interface HFViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)signInButtonPressed:(id)sender;
@end

@implementation HFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.usernameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInButtonPressed:(id)sender {
    [self login];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if(textField == self.passwordTextField) {
        [self login];
    }
    
    return false;
}

- (void) login
{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (username.length == 0 || password.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter username and password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
    else {
        [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Welcome %@!", username] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

@end
