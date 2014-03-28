//
//  HFLoginViewController.h
//  Helpful
//
//  Created by Matthias Plappert on 28/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HFCredentials;
@protocol HFLoginViewControllerDelegate;

@interface HFLoginViewController : UIViewController

- (instancetype)initWithCredentials:(HFCredentials *)credentials;

@property (nonatomic, strong, readonly) HFCredentials *credentials;

@property (nonatomic, weak) id <HFLoginViewControllerDelegate> delegate;

- (void)cancel;
- (void)validate;

@property (nonatomic, assign, readonly, getter = isValidating) BOOL validating;

/// @name Outlets

@property (nonatomic, strong) IBOutlet UITextField *usernameTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
- (IBAction)textFieldDidChange:(UITextField *)textField;

@end

@protocol HFLoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidCancel:(HFLoginViewController *)controller;
- (void)loginViewController:(HFLoginViewController *)controller didLogIntoAccounts:(NSSet *)accounts;

@end
