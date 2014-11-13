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

@property (nonatomic, assign) NSInteger currentConversationIndex;

- (id)initWithConversations:(NSArray *)conversations;

@end
