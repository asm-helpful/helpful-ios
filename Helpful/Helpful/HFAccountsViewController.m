//
//  HFAccountsViewController.m
//  Helpful
//
//  Created by Matthias Plappert on 31/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "HFAccountsViewController.h"
#import "HFConversationsViewController.h"
#import "HFLoginViewController.h"

#import "HFCredentials.h"
#import "HFAccount.h"

@interface HFAccountsViewController () <HFLoginViewControllerDelegate>

@property (nonatomic, copy, readwrite) NSArray *accounts;

- (void)hf_presentLoginViewController;
- (void)hf_fetchAccounts;
- (void)hf_configureTableViewCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation HFAccountsViewController

- (id)init {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        self.title = NSLocalizedString(@"Accounts", nil);
    }
    return self;
}

#pragma mark - Accessors

- (void)setAccounts:(NSArray *)accounts {
    if (![_accounts isEqualToArray:accounts]) {
        _accounts = [accounts copy];
        [self.tableView reloadData];
    }
}

#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Check if we have complete credentials.
    HFCredentials *credentials = [HFCredentials defaultCredentials];
    if (!credentials.complete) {
        [self hf_presentLoginViewController];
    } else if (self.accounts.count == 0) {
        [self hf_fetchAccounts];
    }
}

#pragma mark - HFLoginViewControllerDelegate

- (void)loginViewControllerDidCancel:(HFLoginViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)loginViewController:(HFLoginViewController *)controller didLogIntoAccounts:(NSSet *)accounts {
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    // Transform to an array because we need an order collection to present
    // it in a table view.
    self.accounts = [accounts allObjects];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [self hf_configureTableViewCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HFAccount *account = self.accounts[indexPath.row];
    [self hf_presentConversationsForAccount:account];
}

#pragma mark - Private Methods

- (void)hf_presentLoginViewController {
    HFLoginViewController *controller = [[HFLoginViewController alloc] initWithCredentials:[HFCredentials defaultCredentials]];
    controller.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)hf_fetchAccounts {
    // Fetch all accounts.
    RKObjectRequestOperation *operation = [HFAccount fetchAccountsRequestOperation];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.accounts = [mappingResult array];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // TODO: handle this!
        NSLog(@"could not fetch accounts: %@", error);
    }];
    [operation start];
}

- (void)hf_configureTableViewCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    HFAccount *account = self.accounts[indexPath.row];
    cell.textLabel.text = account.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)hf_presentConversationsForAccount:(HFAccount *)account {
    HFConversationsViewController *controller = [[HFConversationsViewController alloc] initWithAccount:account];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
