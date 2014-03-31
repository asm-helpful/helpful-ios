//
//  HFConversationsViewController.h
//  Helpful
//
//  Created by Matthias Plappert on 28/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HFAccount;

@interface HFConversationsViewController : UITableViewController

- (id)initWithAccount:(HFAccount *)account;

@property (nonatomic, strong, readonly) HFAccount *account;

@end
