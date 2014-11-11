//
//  HFAppDelegate.m
//  Helpful
//
//  Created by Ashish Awaghad on 1/12/13.
//  Copyright (c) 2013 Helpful. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "HFAppDelegate.h"
#import "HFAccountsViewController.h"
#import "HFCredentials.h"

#import "Helpful-Swift.h"

@implementation HFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Restkit uses AFNetworking, which allows easy activity indication...
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
//    Open Sans / OpenSans
//    Open Sans / OpenSans-Bold
//    Open Sans Semibold / OpenSans-Semibold
    
    //Apple styles
    
    [UINavigationBar appearance].barTintColor = [UIColor blackBackgroundColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Semibold" size:24.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    [UITableView appearance].backgroundColor = [UIColor lightBlueBackground];
    [UITableView appearance].separatorColor = [UIColor separatorColor];
    [UITableViewCell appearance].backgroundColor = [UIColor clearColor];
//    [UILabel appearance].font = [UIFont fontWithName:@"OpenSans-Semibold" size:24.0];
//    [UITableViewCell appearance].textLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:24.0];
//    [UITableViewCell appearance].detailTextLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:24.0];

    // Configure RestKit.
    NSURL *baseURL = [NSURL URLWithString:HFBaseURLString];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:baseURL];
    HFCredentials *credentials = [HFCredentials defaultCredentials];
    [manager.HTTPClient setAuthorizationHeaderWithUsername:credentials.username password:credentials.password];
    [RKObjectManager setSharedManager:manager];
    
    // Load the initial controller stack. We have a navigation controller, that
    // contains the conversations view controller.
    HFAccountsViewController *viewController = [[HFAccountsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    // Make the navigation controller the root controller of the window, thereby
    // presenting it.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
