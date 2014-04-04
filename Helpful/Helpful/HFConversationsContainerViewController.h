//
//  HFConversationsContainerViewController.h
//  Helpful
//
//  Created by Matthias Plappert on 04/04/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HFConversationsViewController, HFAccount;

@interface HFConversationsContainerViewController : UIViewController

- (instancetype)initWithAccount:(HFAccount *)account;

@property (nonatomic, strong, readonly) HFAccount *account;

@property (nonatomic, strong, readonly) HFConversationsViewController *inboxViewController;
@property (nonatomic, strong, readonly) HFConversationsViewController *archiveViewController;

@end
