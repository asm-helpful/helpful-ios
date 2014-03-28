//
//  HFAppDelegate.m
//  Helpful
//
//  Created by Ashish Awaghad on 1/12/13.
//  Copyright (c) 2013 Helpful. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "HFAppDelegate.h"
#import "HFConversationsViewController.h"
#import "HFCredentials.h"

@implementation HFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Configure RestKit.
    NSURL *baseURL = [NSURL URLWithString:@"https://helpful.io"];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:baseURL];
    HFCredentials *credentials = [HFCredentials defaultCredentials];
    [manager.HTTPClient setAuthorizationHeaderWithUsername:credentials.username password:credentials.password];
    [RKObjectManager setSharedManager:manager];
    
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
