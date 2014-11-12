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
#import "HFAssignee.h"

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

- (void)setMessage:(HFMessage *)message {
    [self resetCellContent];
    _message = message;

    self.messageLabel.text = message.body;
    self.messageLabel.numberOfLines = 2;
    self.nameMailLabel.text = message.person.name;
    
    [self setImageForUrlString:message.person.gravatarUrl];
    [self setTimeLabelForDate:message.created];
}

- (void)setAssignmentEvent:(HFAssignmentEvent *)assignmentEvent {
    [self resetCellContent];
    _assignmentEvent = assignmentEvent;
    self.nameMailLabel.numberOfLines = 0;

    NSMutableAttributedString *assignmentTitleText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ assigned %@", assignmentEvent.person.name, assignmentEvent.assignee.person.name] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Semibold" size:12.0]}];
    [assignmentTitleText appendAttributedString:[[NSAttributedString alloc] initWithString:@" this ticket" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12.0]}]];

    
    [self setImageForUrlString:_assignmentEvent.person.gravatarUrl];
    [self setTimeLabelForDate:_assignmentEvent.created];
    self.messageLabel.text = nil;
    self.nameMailLabel.attributedText = assignmentTitleText;
}

- (void)setTagEvent:(HFTagEvent *)tagEvent {
    [self resetCellContent];
    _tagEvent = tagEvent;
    self.nameMailLabel.numberOfLines = 0;

    [self setImageForUrlString:_tagEvent.person.gravatarUrl];
    [self setTimeLabelForDate:_tagEvent.created];
    self.messageLabel.text = [NSString stringWithFormat:@"# %@", tagEvent.tagName];

    self.nameMailLabel.text = [NSString stringWithFormat:@"%@ tagged this ticket with", tagEvent.person.name];
}

- (void) setImageForUrlString:(NSString *)imageUrlString {
    self.portratImage.image = [UIImage imageNamed:@"portrait"];
    NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imageUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error loading URL %@", imageUrl);
            return;
        }
        self.portratImage.image = [[UIImage imageWithData:data] roundImageFor:self.portratImage.bounds];
    }];
}

- (void) setTimeLabelForDate:(NSDate*)createdDate {
    NSString *timeString = [self.timeIntervalFormatter stringForTimeInterval:[createdDate timeIntervalSinceDate:[NSDate new]]];
    self.timeLabel.text = timeString;
}

- (void) resetCellContent {
    _message = nil;
    _assignmentEvent = nil;
    _tagEvent = nil;
    self.nameMailLabel.numberOfLines = 1;
    self.nameMailLabel.text = nil;
    self.nameMailLabel.attributedText = nil;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
