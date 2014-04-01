//
//  HFConversationsViewController.h
//  Helpful
//
//  Created by Matthias Plappert on 28/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HFAccount;

/// `HFConversationsViewController` fetches and displays a list of `HFConversation`s
/// for the given `HFAccount`.
@interface HFConversationsViewController : UITableViewController

/// Initializes a new `HFConversationsViewController` with the given `HFAccount`.
- (id)initWithAccount:(HFAccount *)account NS_DESIGNATED_INITIALIZER;

/// The `HFAccount` that the `HFConversations` are associated with.
@property (nonatomic, strong, readonly) HFAccount *account;

/// An array of `HFConversation`s that have been fetched.
@property (nonatomic, copy, readonly) NSArray *conversations;

@end
