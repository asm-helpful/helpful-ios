//
//  HFConversationsContainerView.m
//  Helpful
//
//  Created by Matthias Plappert on 04/04/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFConversationsContainerView.h"

#import "Helpful-Swift.h"

static CGFloat const HFConversationsContainerViewSegmentedControlPadding = 10.0f;

@interface HFConversationsContainerView ()

- (void)hf_conversationsContainerViewCommonInit;

- (void)hf_drawSegmentedControlContainerBorder;

- (CGRect)hf_segmentedControlContainerFrame;
- (CGRect)hf_segmentedControlFrame;
- (CGRect)hf_contentViewFrame;

- (UIColor *)hf_defaultBackgroundColor;
- (UIColor *)hf_defaultBorderColor;

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

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self hf_drawSegmentedControlContainerBorder];
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
    
    // Configure view.
    self.backgroundColor = [self hf_defaultBackgroundColor];
    self.contentMode = UIViewContentModeRedraw;
}

#pragma mark -

- (void)hf_drawSegmentedControlContainerBorder {
    CGRect containerFrame = [self hf_segmentedControlContainerFrame];
    [[self hf_defaultBorderColor] set];
    CGFloat lineWidth = 1.0f / self.window.screen.scale;
    UIRectFill(CGRectMake(0.0f, CGRectGetMaxY(containerFrame) - lineWidth, self.bounds.size.width, lineWidth));
}

#pragma mark - 

- (CGRect)hf_segmentedControlContainerFrame {
    static CGFloat padding = HFConversationsContainerViewSegmentedControlPadding;
    CGRect frame = CGRectInset([self hf_segmentedControlFrame], 0.0f, -padding);
    frame.origin.x = 0.0f;
    frame.size.width = self.bounds.size.width;
    frame = CGRectIntegral(frame);
    return frame;
}

- (CGRect)hf_segmentedControlFrame {
    static CGFloat padding = HFConversationsContainerViewSegmentedControlPadding;
    CGSize size = [self.segmentedControl sizeThatFits:self.bounds.size];
    CGRect frame = CGRectMake((self.bounds.size.width - size.width) / 2.0f, padding,
                              size.width, size.height);
    frame = CGRectIntegral(frame);
    return frame;
}

- (CGRect)hf_contentViewFrame {
    CGRect containerFrame = [self hf_segmentedControlContainerFrame];
    CGRect frame = CGRectMake(0.0f, CGRectGetMaxY(containerFrame), self.bounds.size.width,
                              self.bounds.size.height - CGRectGetMaxY(containerFrame));
    return CGRectIntegral(frame);
}

#pragma mark -

- (UIColor *)hf_defaultBackgroundColor {
    return [UIColor separatorColor];
}

- (UIColor *)hf_defaultBorderColor {
    return [UIColor colorWithWhite:197.0f / 255.0f alpha:1.0f];
}

@end
