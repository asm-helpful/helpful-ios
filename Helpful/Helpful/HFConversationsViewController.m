//
//  HFConversationsViewController.m
//  Helpful
//
//  Created by Matthias Plappert on 28/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFConversationsViewController.h"

#import "HFAccount.h"
#import "HFConversation.h"
#import "HFMessage.h"

@interface HFConversationsViewController ()

@property (nonatomic, copy, readwrite) NSArray *conversations;

- (void)hf_fetchConversations;
- (void)hf_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation HFConversationsViewController

- (id)initWithAccount:(HFAccount *)account {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        _account = account;
        
        self.title = NSLocalizedString(@"Conversations", nil);
    }
    return self;
}

#pragma mark - Accessors

- (void)setConversations:(NSArray *)conversations {
    if (![_conversations isEqualToArray:conversations]) {
        _conversations = [conversations copy];
        [self.tableView reloadData];
    }
}

#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.conversations) {
        [self hf_fetchConversations];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    [self hf_configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods

- (void)hf_fetchConversations {
    // Fetch all accounts.
    RKObjectRequestOperation *operation = [HFConversation fetchConversationsRequestOperationForAccount:self.account archived:nil];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.conversations = [mappingResult array];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // TODO: handle this!
        NSLog(@"could not fetch conversations: %@", error);
    }];
    [operation start];
}

- (void)hf_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    HFConversation *conversation = self.conversations[indexPath.row];
    HFMessage *latestMessage = [conversation.messages lastObject];
    cell.textLabel.text = conversation.subject;
    cell.detailTextLabel.text = latestMessage.body;
}

@end
