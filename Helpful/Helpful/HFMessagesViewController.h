//
//  HFMessagesViewController.h
//  Helpful
//
//  Created by Jeroen Leenarts on 01-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HFConversation;

@interface HFMessagesViewController : UITableViewController

- (id)initWithConversation:(HFConversation *)conversation;

/// The `HFConversation` that the `HFMessages` are associated with.
@property (nonatomic, strong, readonly) HFConversation *conversation;

@end
