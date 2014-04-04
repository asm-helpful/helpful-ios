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

- (void)hf_segmentedControlDidChange:(UISegmentedControl *)sender;
- (HFConversationsViewController *)hf_viewControllerForIndex:(NSUInteger)index;
- (void)hf_presentViewControllerAtIndex:(NSUInteger)index;

@end

@implementation HFConversationsContainerViewController

- (id)initWithAccount:(HFAccount *)account {
    if ((self = [super init])) {
        _account = account;
        
        _inboxViewController = [[HFConversationsViewController alloc] initWithAccount:account contentType:HFConversationsViewControllerContentTypeInbox];
        _archiveViewController = [[HFConversationsViewController alloc] initWithAccount:account contentType:HFConversationsViewControllerContentTypeArchive];
        
        // We don't want extended layout for the top.
        self.edgesForExtendedLayout = self.edgesForExtendedLayout & ~UIRectEdgeTop;
    }
    return self;
}
\
#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    HFConversationsContainerView *containerView = [[HFConversationsContainerView alloc] initWithFrame:CGRectZero];
    
    // Configure segmented control.
    NSUInteger index = HFConversationsContainerViewControllerInboxIndex;
    [containerView.segmentedControl insertSegmentWithTitle:[self hf_viewControllerForIndex:index].title atIndex:index animated:NO];
    index = HFConversationsContainerViewControllerArchiveIndex;
    [containerView.segmentedControl insertSegmentWithTitle:[self hf_viewControllerForIndex:index].title atIndex:index animated:NO];
    containerView.segmentedControl.selectedSegmentIndex = HFConversationsContainerViewControllerInboxIndex;
    [containerView.segmentedControl addTarget:self action:@selector(hf_segmentedControlDidChange:) forControlEvents:UIControlEventValueChanged];
    
    self.view = containerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hf_presentViewControllerAtIndex:self.containerView.segmentedControl.selectedSegmentIndex];
}

- (HFConversationsContainerView *)containerView {
    HFConversationsContainerView *view = (HFConversationsContainerView *)[super view];
    NSAssert([view isKindOfClass:[HFConversationsContainerView class]], @"Invalid view class");
    return view;
}

#pragma mark - Private Methods

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
