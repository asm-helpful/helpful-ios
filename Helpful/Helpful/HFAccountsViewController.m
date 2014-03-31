//
//  HFAccountsViewController.m
//  Helpful
//
//  Created by Matthias Plappert on 31/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "HFAccountsViewController.h"
#import "HFLoginViewController.h"

#import "HFCredentials.h"
#import "HFAccount.h"

@interface HFAccountsViewController () <HFLoginViewControllerDelegate>

@property (nonatomic, copy, readwrite) NSArray *accounts;

- (void)hf_presentLoginViewController;

@end

@implementation HFAccountsViewController

- (id)init {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

@end
