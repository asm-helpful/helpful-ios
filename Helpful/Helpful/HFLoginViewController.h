//
//  HFLoginViewController.h
//  Helpful
//
//  Created by Matthias Plappert on 28/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HFAccount;
@protocol HFLoginViewControllerDelegate;

@interface HFLoginViewController : UIViewController

- (instancetype)initWithAccount:(HFAccount *)account;

@property (nonatomic, strong, readonly) HFAccount *account;

@property (nonatomic, weak) id <HFLoginViewControllerDelegate> delegate;

- (void)cancel;
- (void)validate;

@property (nonatomic, assign, readonly, getter = isValidating) BOOL validating;

@end

@protocol HFLoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidCancel:(HFLoginViewController *)controller;
- (void)loginViewController:(HFLoginViewController *)controller didLogIntoAccount:(HFAccount *)account;

@end
