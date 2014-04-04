//
//  HFConversationsContainerViewController.h
//  Helpful
//
//  Created by Matthias Plappert on 04/04/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HFConversationsViewController, HFAccount;

/// `HFConversationsContainerViewController` displays either the inbox or the archive and provides
/// UI elements to switch between the two.
@interface HFConversationsContainerViewController : UIViewController

/// Initializes a new `HFConversationsViewController` with the given `HFAccount`.
- (instancetype)initWithAccount:(HFAccount *)account NS_DESIGNATED_INITIALIZER;

/// The account.
@property (nonatomic, strong, readonly) HFAccount *account;

@end
