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

/// `HFLoginViewController` logs in a user and validates if the provided username/password
/// combination is valid.
/// @note This controller should be presented inside of an `UINavigationController`. In this case,
/// it will automatically present "Cancel" and "Log In" buttons. If you chose to present
/// it differently, you are responsible for creating the buttons yourself.
@interface HFLoginViewController : UIViewController

/// Initializes a new `HFLoginViewController` with the given `HFCredentials`.
/// The credentials wil be updated if the user changes them and they are valid.
- (instancetype)initWithCredentials:(HFCredentials *)credentials NS_DESIGNATED_INITIALIZER;

/// The `HFCredentials` that the `HFLoginViewController` is associated with.
@property (nonatomic, strong, readonly) HFCredentials *credentials;

/// The delegate of the `HFLoginViewController`.
/// @warning Since the delegate is responsible to dismiss the controller, it should always
/// be provided.
@property (nonatomic, weak) id <HFLoginViewControllerDelegate> delegate;

/// Cancels the presentation of `HFLoginViewController`.
/// @note This method relies on `delegate` to actually dismiss the controller.
- (void)cancel;

/// Starts validating the username/password combination. If the combination is valid,
/// the controller will call the `- loginViewCntroller:didLogIntoAccounts:` delegate method.
- (void)validate;

/// Indicates if the controller is currently validating.
@property (nonatomic, assign, readonly, getter = isValidating) BOOL validating;

/// @name Outlets

/// The username text field.
@property (nonatomic, strong) IBOutlet UITextField *usernameTextField;

/// The password text field.
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

/// The action that is called when either of the text fields change.
- (IBAction)textFieldDidChange:(UITextField *)textField;

@end


@protocol HFLoginViewControllerDelegate <NSObject>

/// Called when the user cancels the login process.
- (void)loginViewControllerDidCancel:(HFLoginViewController *)controller;

/// Called if the provided username/password combination is valid.
- (void)loginViewController:(HFLoginViewController *)controller didLogIntoAccounts:(NSSet *)accounts;

@end
