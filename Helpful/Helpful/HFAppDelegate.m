//
//  HFAppDelegate.m
//  Helpful
//
//  Created by Ashish Awaghad on 1/12/13.
//  Copyright (c) 2013 Helpful. All rights reserved.
//

#import "HFAppDelegate.h"
#import "HFConversationsViewController.h"

@implementation HFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Load the initial controller stack. We have a navigation controller, that
    // contains the conversations view controller.
    HFConversationsViewController *viewController = [[HFConversationsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    // Make the navigation controller the root controller of the window, thereby
    // presenting it.
    self.window.rootViewController = navigationController;
    
    return YES;
}

@end
