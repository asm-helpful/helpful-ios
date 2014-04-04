//
//  HFConversationsContainerView.h
//  Helpful
//
//  Created by Matthias Plappert on 04/04/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <UIKit/UIKit.h>

/// `HFConversationsContainerView` is used to display a `UISegmentedControl` next to a content view.
@interface HFConversationsContainerView : UIView

/// The `UISegmentedControl`.
@property (nonatomic, strong, readonly) UISegmentedControl *segmentedControl;

/// The content view.
@property (nonatomic, strong) UIView *contentView;

@end
