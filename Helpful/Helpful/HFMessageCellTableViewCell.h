//
//  HFMessageCellTableViewCell.h
//  Helpful
//
//  Created by Jeroen Leenarts on 04-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HFMessage.h"
#import "HFTagEvent.h"
#import "HFAssignmentEvent.h"

@interface HFMessageCellTableViewCell : UITableViewCell

@property (weak, nonatomic) HFMessage* message;
@property (weak, nonatomic) HFTagEvent* tagEvent;
@property (weak, nonatomic) HFAssignmentEvent* assignmentEvent;

@property (weak, nonatomic) NSString* conversationSubject;

@property (weak, nonatomic) IBOutlet UILabel *nameMailLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *portratImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *decorationBarConstraint;
@end
