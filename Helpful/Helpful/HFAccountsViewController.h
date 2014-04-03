//
//  HFAccountsViewController.h
//  Helpful
//
//  Created by Matthias Plappert on 31/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <UIKit/UIKit.h>

/// `HFAccountsViewController` fetches and displays a list of all `HFAccount`s for the currently
/// logged in user.
@interface HFAccountsViewController : UITableViewController

/// An array of `HFAccount`s that have been fetched.
@property (nonatomic, copy, readonly) NSArray *accounts;

@end
