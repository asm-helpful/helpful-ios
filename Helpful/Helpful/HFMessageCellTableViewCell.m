//
//  HFMessageCellTableViewCell.m
//  Helpful
//
//  Created by Jeroen Leenarts on 04-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFMessageCellTableViewCell.h"

#import "HFPerson.h"
#import "HFConversation.h"

#import "Helpful-Swift.h"

#import <TTTTimeIntervalFormatter.h>

static TTTTimeIntervalFormatter *_timeIntervalFormatter;

@interface HFMessageCellTableViewCell ()

@property (nonatomic, readonly) TTTTimeIntervalFormatter *timeIntervalFormatter;

@end

@implementation HFMessageCellTableViewCell

- (TTTTimeIntervalFormatter *)timeIntervalFormatter {
    //This is pretty ugly, but since all UI code is executed on Main this is safe.
    if (_timeIntervalFormatter == nil) {
        _timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc]init];
        _timeIntervalFormatter.usesAbbreviatedCalendarUnits = YES;
        _timeIntervalFormatter.pastDeicticExpression = nil;
    }
    
    return _timeIntervalFormatter;
}

- (void)setConversationSubject:(NSString *)conversationSubject {
    self.titleLabel.text = conversationSubject;
}

- (NSString *)conversationSubject {
    return self.titleLabel.text;
}

- (void)setMessage:(HFMessage *)message {
    _message = message;
    
    self.messageLabel.text = message.body;
    self.messageLabel.numberOfLines = 2;
    self.nameMailLabel.text = [NSString stringWithFormat:@"%@, %@", message.person.name, message.person.email];
    NSURL *imageUrl = [NSURL URLWithString:message.person.gravatarUrl];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imageUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error loading URL %@", imageUrl);
            return;
        }
        self.portratImage.image = [[UIImage imageWithData:data] roundImageFor:self.portratImage.bounds];
    }];
    
    NSString *timeString = [self.timeIntervalFormatter stringForTimeInterval:[self.message.created timeIntervalSinceDate:[NSDate new]]];
    self.timeLabel.text = timeString;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
