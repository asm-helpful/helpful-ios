//
//  HFConversationsContainerViewController.m
//  Helpful
//
//  Created by Matthias Plappert on 04/04/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFConversationsContainerViewController.h"
#import "HFConversationsViewController.h"

#import "HFConversationsContainerView.h"

static NSUInteger const HFConversationsContainerViewControllerInboxIndex = 0;
static NSUInteger const HFConversationsContainerViewControllerArchiveIndex = 1;

@interface HFConversationsContainerViewController ()

@property (nonatomic, strong, readwrite) HFConversationsViewController *inboxViewController;
@property (nonatomic, strong, readwrite) HFConversationsViewController *archiveViewController;

@property (nonatomic, strong) HFConversationsViewController *activeViewController;
@property (nonatomic, strong) HFConversationsContainerView *containerView;

- (void)hf_loadContainerView;
- (void)hf_segmentedControlDidChange:(UISegmentedControl *)sender;
- (HFConversationsViewController *)hf_viewControllerForIndex:(NSUInteger)index;
- (void)hf_presentViewControllerAtIndex:(NSUInteger)index;

@end

@implementation HFConversationsContainerViewController

- (id)initWithAccount:(HFAccount *)account {
    if ((self = [super init])) {
        _account = account;
        
        // Load view controllers.
        _inboxViewController = [[HFConversationsViewController alloc] initWithAccount:account contentType:HFConversationsViewControllerContentTypeInbox];
        _archiveViewController = [[HFConversationsViewController alloc] initWithAccount:account contentType:HFConversationsViewControllerContentTypeArchive];
        
        self.title = NSLocalizedString(@"Conversations", nil);
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hf_loadContainerView];
    [self hf_presentViewControllerAtIndex:self.containerView.segmentedControl.selectedSegmentIndex];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat topOffset = self.topLayoutGuide.length;
    CGSize viewSize = self.view.bounds.size;
    self.containerView.frame = CGRectMake(0.0f, topOffset, viewSize.width, viewSize.height - topOffset);
}

#pragma mark - Private Methods

- (void)hf_loadContainerView {
    HFConversationsContainerView *containerView = [[HFConversationsContainerView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    // Configure segmented control.
    UISegmentedControl *segmentedControl = self.containerView.segmentedControl;
    NSUInteger index = HFConversationsContainerViewControllerInboxIndex;
    [segmentedControl insertSegmentWithTitle:[self hf_viewControllerForIndex:index].title atIndex:index animated:NO];
    index = HFConversationsContainerViewControllerArchiveIndex;
    [segmentedControl insertSegmentWithTitle:[self hf_viewControllerForIndex:index].title atIndex:index animated:NO];
    segmentedControl.selectedSegmentIndex = HFConversationsContainerViewControllerInboxIndex;
    [segmentedControl addTarget:self action:@selector(hf_segmentedControlDidChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)hf_segmentedControlDidChange:(UISegmentedControl *)sender {
    NSUInteger index = sender.selectedSegmentIndex;
    [self hf_presentViewControllerAtIndex:index];
}

- (HFConversationsViewController *)hf_viewControllerForIndex:(NSUInteger)index {
    switch (index) {
        case HFConversationsContainerViewControllerInboxIndex:
            return self.inboxViewController;
            
        case HFConversationsContainerViewControllerArchiveIndex:
            return self.archiveViewController;
            
        default:
            NSAssert(NO, @"Undefined controller index: %@", @(index));
            return nil;
    }
}

- (void)hf_presentViewControllerAtIndex:(NSUInteger)index {
    if (self.activeViewController) {
        [self.activeViewController willMoveToParentViewController:nil];
        [self.activeViewController.view removeFromSuperview];
        [self.activeViewController removeFromParentViewController];
    }
    
    HFConversationsViewController *newController = [self hf_viewControllerForIndex:index];
    [self addChildViewController:newController];
    self.containerView.contentView = newController.view;
    [newController didMoveToParentViewController:self];
    
    self.activeViewController = newController;
}

@end
