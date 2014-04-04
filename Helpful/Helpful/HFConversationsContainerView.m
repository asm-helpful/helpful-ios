//
//  HFConversationsContainerView.m
//  Helpful
//
//  Created by Matthias Plappert on 04/04/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFConversationsContainerView.h"

@interface HFConversationsContainerView ()

- (void)hf_conversationsContainerViewCommonInit;

- (CGRect)hf_segmentedControlFrame;
- (CGRect)hf_contentViewFrame;

@end

@implementation HFConversationsContainerView

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self hf_conversationsContainerViewCommonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self hf_conversationsContainerViewCommonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.segmentedControl.frame = [self hf_segmentedControlFrame];
    self.contentView.frame = [self hf_contentViewFrame];
}

#pragma mark - Accessors

- (void)setContentView:(UIView *)contentView {
    if (![_contentView isEqual:contentView]) {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        [self addSubview:contentView];
        
        [self setNeedsLayout];
    }
}

#pragma mark - Private Methods

- (void)hf_conversationsContainerViewCommonInit {
    // Load the segmented control.
    _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
    [self addSubview:_segmentedControl];
    
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 

- (CGRect)hf_segmentedControlFrame {
    CGSize size = [self.segmentedControl sizeThatFits:self.bounds.size];
    CGRect frame = CGRectMake((self.bounds.size.width - size.width) / 2.0f, 0.0f,
                              size.width, size.height);
    frame = CGRectIntegral(frame);
    return frame;
}

- (CGRect)hf_contentViewFrame {
    CGRect segmentedControlFrame = [self hf_segmentedControlFrame];
    return CGRectMake(0.0f, CGRectGetMaxY(segmentedControlFrame), self.bounds.size.width,
                      self.bounds.size.height - CGRectGetMaxY(segmentedControlFrame));
}

@end
