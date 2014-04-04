//
//  HFConversationsContainerView.h
//  Helpful
//
//  Created by Matthias Plappert on 04/04/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFConversationsContainerView : UIView

@property (nonatomic, strong, readonly) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIView *contentView;

@end
