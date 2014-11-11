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

- (void)setMessage:(HFMessage *)message {
    _message = message;
    _assignmentEvent = nil;
    _tagEvent = nil;

    self.messageLabel.text = message.body;
    self.messageLabel.numberOfLines = 2;
    self.nameMailLabel.text = [NSString stringWithFormat:@"%@, %@", message.person.name, message.person.email];
    
    [self setImageForUrlString:message.person.gravatarUrl];
    [self setTimeLabelForDate:_message.created];
}

- (void)setAssignmentEvent:(HFAssignmentEvent *)assignmentEvent {
    _message = nil;
    _assignmentEvent = assignmentEvent;
    _tagEvent = nil;
    
    [self setImageForUrlString:_assignmentEvent.person.gravatarUrl];
    [self setTimeLabelForDate:_assignmentEvent.created];
}

- (void)setTagEvent:(HFTagEvent *)tagEvent {
    _message = nil;
    _assignmentEvent = nil;
    _tagEvent = tagEvent;
    
    [self setImageForUrlString:_tagEvent.person.gravatarUrl];
    [self setTimeLabelForDate:_tagEvent.created];
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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
